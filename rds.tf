
# 🗄️ RDS Instance (MySQL in Private Subnet)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = { Name = "RDS-Subnet-Group" }
}

resource "aws_db_instance" "my_rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = "myappdb"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Ensure deletion without final snapshot
  skip_final_snapshot = true
  deletion_protection = false

  tags = { Name = "TF-MyRDS" }
}
