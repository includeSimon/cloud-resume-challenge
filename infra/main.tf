resource "aws_lambda_function" "myfunction" {
  function_name = "myfunction"
  handler = "myfunction.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.iam_for_lambda.arn
  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {

  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
    policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
            "dynamodb:PutItem",
			"dynamodb:GetItem"
          ],
        "Resource": "arn:aws:dynamodb:*:010438510855:table/cloudresume-test"
        },
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
  
}

data "archive_file" "zip" {
  type = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function_url" "url" {
    function_name = aws_lambda_function.myfunction.function_name
    authorization_type = "NONE"

    cors {
        allow_credentials = true
        allow_methods = ["*"]
        allow_origins = ["*"]
        max_age = 86401
    }
}