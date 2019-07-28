provider "aws" {
  access_key = "AKIASPN3RTYB6LYTKHGX"
  secret_key = "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"
  region     = "us-east-2"
}

resource "aws_instance" "test-instance7" {
  subnet_id	= "subnet-059bec3bcbb6106a4"
  ami           = "ami-002668d3a55824247"
  instance_type = "t2.micro"
  key_name	= "aws_automation"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0f4a1bccc3dccdda2"]
  root_block_device {
   volume_size = 20
}
tags = {
Name = "test-instance7"
}

}
resource "aws_volume_attachment" "ebs_att" {
device_name = "/dev/sdb"
volume_id = "${aws_ebs_volume.test-ebs.id}"
instance_id = "${aws_instance.test-instance7.id}"
}
resource "aws_ebs_volume" "test-ebs" {
availability_zone = "us-east-2a"
size = 10
type = "gp2"

tags = {
Name = "test-ebs"
}
}
