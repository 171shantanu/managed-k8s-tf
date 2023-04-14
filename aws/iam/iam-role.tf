# Creating IAM role for New Relic

resource "aws_iam_role" "new_relic_role" {
  name                = "new-relic-role"
  description         = "Read Only role for New Relic"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Condition = {
            StringEquals = {
              "sts:ExternalId" = "3896369"
            }
          }
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::754728514883:root"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = {
    "Name" = "new-relic-role"
  }
}
`