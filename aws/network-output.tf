# Output for the public subnet 1 id
output "public_subnet_1_id" {
  value = aws_subnet.public_1.id
}

# Output for the public subnet 2 id
output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
}
