resource "aws_iam_role" "codebuild_role" {
    name = "${var.project_name}"
    assume_role_policy = jsonencode({
        Version: "2012-10-17"
        Statement = [{
            Effect = "Allow",
            Principal = { Service = "codebuild.amazonaws.com" }
            Action = "sts:AssumeRole"
        }]
    })
}

data "aws_iam_policy_document" "codebuild_policy_doc" {
    statement {
      sid = "CloudWatchLogs"
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["*"]
    }

  statement {
    sid       = "ECRLogin"
    effect    = "Allow"
    actions   = [
        "ecr:GetAuthorizationToken",
        "ecr-public:GetAuthorizationToken",
        "sts:GetServiceBearerToken"
    ]
    resources = ["*"]
  }

    statement {
      sid = "ECRPush"
      effect = "Allow"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
      resources = [var.ecr_repository_arn]
    }

      statement {
    sid    = "AllowS3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.codepipeline_artifacts.arn,
      "${aws_s3_bucket.codepipeline_artifacts.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.project_name}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "codebuild_role_attach" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_codebuild_project" "app_build" {
  name = "${var.project_name}-app-build"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true 
    # image_pull_credentials_type = "SERVICE_ROLE"

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      value = var.ecr_repository_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }

   tags = { Name = "${var.project_name}-codebuild" }
}

resource "aws_iam_role" "codepipeline_role" {
    name = "${var.project_name}-codepipeline-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = { Service = "codepipeline.amazonaws.com" }
            Action = "sts:AssumeRole"
        }]
    })
}

data "aws_iam_policy_document" "codepipeline_policy_doc" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.codepipeline_artifacts.arn,
      "${aws_s3_bucket.codepipeline_artifacts.arn}/*",
    ]
  }

  statement {
    sid    = "AllowCodeBuild"
    effect = "Allow"
    actions = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"]
    resources = [aws_codebuild_project.app_build.arn]
  }

  statement {
    sid    = "AllowSource"
    effect = "Allow"
    actions = ["codestar-connections:UseConnection"]
    resources = [var.codestar_connection_arn]
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.project_name}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "${var.project_name}-codepipeline-artifacts-${var.aws_account_id}"
}

resource "aws_codepipeline" "app_pipeline" {
    name = "${var.project_name}-app-pipeline"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
      location = aws_s3_bucket.codepipeline_artifacts.bucket
      type = "S3"
    }

 stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn 
        FullRepositoryId = "danielzamignani/moment-mail-server"
        BranchName       = "main"
      }
    }
  }
      stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }
}


    
