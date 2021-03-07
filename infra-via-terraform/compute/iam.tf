resource "aws_iam_role_policy" "k8s_policy" {
  name = "k8s_policy"
  role = aws_iam_role.k8s_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*",
          "iam:*",
          "route53:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "k8s_role" {
  name = "k8s_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "k8s_profile" {
  name = "k8s_profile"
  role = aws_iam_role.k8s_role.name
}