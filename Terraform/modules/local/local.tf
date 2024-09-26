provider "local" {
  # Configuration options
}

resource "local_sensitive_file" "aws-cred" {
  content  = <<EOF
    EOF
  filename = "./aws-cred.txt"
}
