resource "aws_instance" "web_server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.ec2_sg.id]
  key_name        =  var.key_name # Allow SSH access



  tags = { Name = "TF-WebServer" }

  user_data = <<-EOF
  #!/bin/bash
  set -e

  # Update and install Nginx
  apt update -y
  apt install -y nginx

  # Enable and start Nginx
  systemctl enable nginx
  systemctl start nginx

  # Create custom index.html
  cat <<EOT > /var/www/html/index.html
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
  EOT

  # Set ownership and permissions
  chown -R www-data:www-data /var/www/html/
  chmod -R 755 /var/www/html/

  # Restart nginx
  systemctl restart nginx
EOF

}
