provider "aws" {
  region                        = "${var.aws_info["region"]}"
  shared_credentials_file       = "${var.aws_info["credentials_file"]}"
  profile                       = "${var.aws_info["profile"]}"
}

data "template_file" "docker_compose" {
  template = "${file("docker-compose.tpl")}"

  vars {
    kcptun_server_listen_port   = "${var.kcptun_server["listen"]}"
    kcptun_server_mode          = "${var.kcptun_server["mode"]}"
    ss_server_listen_port       = "${var.ss_server["listen"]}"
    ss_server_mode              = "${var.ss_server["mode"]}"
    ss_server_workers_count     = "${var.ss_server["workers"]}"
    password                    = "${var.password}"
  }
}

resource "local_file" "docker_compose" {
    content     = "${data.template_file.docker_compose.rendered}"
    filename    = "docker-compose.yml"
}

data "aws_ami" "ubuntu" {
  most_recent   = true
  owners        =  ["099720109477"]

  filter {
    name        =  "name"
    values      =  ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name        =  "virtualization-type"
    values      =  ["hvm"]
  }
}

data "aws_security_group" "vpc_default" {
  name          =  "default"
}

resource "aws_security_group" "allow_access" {
  name          =  "allow_access"
  description   =  "Allow connect inbound traffic with (ssh/ss-client/kcp-client)"

  ingress       {
    protocol="tcp",
    cidr_blocks = ["0.0.0.0/0"],
    from_port=22,
    to_port=22
                }

  ingress       {
    protocol="tcp",
    cidr_blocks = ["0.0.0.0/0"],
    from_port="${var.ss_server["listen"]}",
    to_port="${var.ss_server["listen"]}"
  }

  ingress       {
    protocol="udp",
    cidr_blocks = ["0.0.0.0/0"],
    from_port="${var.kcptun_server["listen"]}",
    to_port="${var.kcptun_server["listen"]}"
  }

  tags          {
    Name="allow_access"
  }
}

data "template_file" "ssh_public_key" {
  template      =  "${file("${var.aws_ssh_key_file}.pub")}"
}

resource "aws_key_pair" "deployer" {
  key_name      =  "deployer-key"
  public_key    =  "${data.template_file.ssh_public_key.rendered}"
}

resource "aws_instance" "shadowsocks" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name        = "shadowsocks"
  }

  security_groups = [
    "${data.aws_security_group.vpc_default.name}",
    "${aws_security_group.allow_access.name}"
  ]

  key_name = "${aws_key_pair.deployer.key_name}"

  depends_on    =  [
    "aws_security_group.allow_access",
    "aws_key_pair.deployer",
  ]

  provisioner "local-exec" {
    command     =  "ansible-galaxy install nickjj.docker"
    on_failure  =  "continue"
  }

  provisioner "local-exec" {
    command     =  "ansible-playbook -i hosts site.yml -e host_ip=${self.public_ip} -e ssh_key=${var.aws_ssh_key_file}"
    on_failure  =  "continue"
  }

  provisioner "local-exec" {
    command     =  "ansible-playbook -i hosts provision.yml -e host_ip=${self.public_ip} -e ssh_key=${var.aws_ssh_key_file}"
    on_failure  =  "continue"
  }
}

output "aws_shadowsocks_host_ip" {
  value         =  "${aws_instance.shadowsocks.public_ip}"
}

output "aws_shadowsocks_ssh_key_file" {
  value         =  "${var.aws_ssh_key_file}"
}

output "ssh_to_server" {
  value         =   "\nYou could also ssh to your server with command: \n ssh ubuntu@${aws_instance.shadowsocks.public_ip} -i ${var.aws_ssh_key_file}"
}
