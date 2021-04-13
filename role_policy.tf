#CREATE AN IAM ROLE FOR EC2 INSTANCE
resource "aws_iam_role" "S3role" {
  name = "S3_TERRAFORM_ACCESS_ROLE"
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

  tags = {
    Dev = "Stack"
  }
}

#CREATE S3 FULL ACCESS POLICY
resource "aws_iam_policy" "policy" {
  name        = "s3-access-policy"
  description = "Grants access to S3 resources"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                      "s3:GetObject",
                      "s3:ListObject"
                      ],
            "Resource": "*"
        }
    ]
  })
}

#ATTACH POLICY TO ROLE
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.S3role.name
  policy_arn = aws_iam_policy.policy.arn
}

#CREATE AN INSTANCE PROFILE
#ATTACH ROLE TO PROFILE
resource "aws_iam_instance_profile" "S3profile" {
  name  = "MY_S3_profile"
  role = aws_iam_role.S3role.name
}
