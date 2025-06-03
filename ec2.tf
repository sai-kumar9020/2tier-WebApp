resource "aws_instance" "web_server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.ec2_sg.id]
  key_name        = "var.key_name" # Allow SSH access



  tags = { Name = "TF-WebServer" }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "===== Creating a simple HTML page ====="
    cat <<EOF | sudo tee /var/www/html/index.html > /dev/null
    <!DOCTYPE html>
    <html>
    <head>
       <title>Welcome to Nginx</title>
    </head>
    <body>
       <h1>Hello from $(hostname)!</h1>
       <p>Nginx is successfully installed on your Ubuntu server.</p>
    </body>
    </html>
    sudo chown -R apache:apache /var/www/html/
    sudo chmod -R 755 /var/www/html/
    sudo systemctl restart nginx
EOF
}
