resource "aws_iam_role" "scsrole" {
  name = "student-role-${var.prefix}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "scsprofile" {
  name = "student-profile-${var.prefix}"
  role = aws_iam_role.scsrole.name
}
