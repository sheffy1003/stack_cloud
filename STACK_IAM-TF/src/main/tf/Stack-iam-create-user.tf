resource "aws_iam_user" "user" {
  name          = "stackuser1"
  path          = "/"
  force_destroy = true
  #permissions_boundary = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_login_profile" "log-prof" {
  user    = aws_iam_user.user.name
  pgp_key = "keybase:sheriffstack"
}

output "password" {
  value = aws_iam_user_login_profile.log-prof.encrypted_password
}
resource "aws_iam_group" "group" {
  name = "stack-group"
}

resource "aws_iam_policy" "policy" {
  name        = "stack-ec2-s3-iam-access"
  description = "A policy that gives ec2, s3 and iam access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    { 
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "stack-attach" {
  name       = "stack-attachment"
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "team" {
  name = "stack-group-membership"

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.group.name
}

