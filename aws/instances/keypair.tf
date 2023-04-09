# Resources for the key pair for the instances
resource "aws_key_pair" "k8s_key" {
  key_name   = "self-k8s-key"
  public_key = tls_private_key.rsa_k8s.public_key_openssh
  depends_on = [tls_private_key.rsa_k8s]

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    "Name" = "${local.name_suffix}-key-pair"
  }
}

# Generating a rsa key for the ec2 instances to get the public key
resource "tls_private_key" "rsa_k8s" {
  algorithm = "ED25519"
  lifecycle {
    prevent_destroy = true
  }
}

# Strping the private key in the local using a local file resource block
resource "local_file" "k8s_key_private" {
  content  = tls_private_key.rsa_k8s.private_key_pem
  filename = "self-k8s-key.pem"

  lifecycle {
    prevent_destroy = true
  }
}
