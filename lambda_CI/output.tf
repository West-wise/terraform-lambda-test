#IAM User Credentials
output "cloudgoat_output_bob_access_key_id" {
  value = aws_iam_access_key.cg-bob.id
}
output "cloudgoat_output_bob_secret_key" {
  value     = aws_iam_access_key.cg-bob.secret
  sensitive = true
}

output "cloudgoat_output_username" {
  value = aws_iam_user.cg-bob.name
}

output "EC2_Instance_Public_IP" {
  value = aws_instance.my_instance.public_ip
}

output "cloudgoat_output_kitri_access_key_id" {
  value = aws_iam_access_key.cg-kitri.id
}
output "cloudgoat_output_kitri_secret_key" {
  value     = aws_iam_access_key.cg-kitri.secret
  sensitive = true
}

output "cloudgoat_output_username_kitri" {
  value = aws_iam_user.cg-kitri.name
}
