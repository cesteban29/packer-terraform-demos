# Packer Auto Variables

# Packer will automatically load any var file that matches the name *.auto.pkrvars.hcl
# without the need to pass the file via the command line if you do "packer build ."

aws_region = "us-east-1"
aws_instance_type = "t2.micro"
