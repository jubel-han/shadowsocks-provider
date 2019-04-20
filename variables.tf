variable "obfs_server" {
  description = "The obfs server configuration"

  default = {
    listen = "80"
    mode = "http"  # http or tls
  }
}

variable "kcptun_server" {
  description = "The KCPTun server configuration"

  default = {
    listen = "4000"
    mode = "fast2"
  }
}

variable "ss_server" {
  description = "The shadowocks server configuration"

  default = {
    listen = "8838"
    mode = "aes-256-gcm"
    workers = "10"
  }
}

variable "password" {
  description = "The password using for connecting ss and kcptun server"

  default = "password"
}

variable "aws_info" {
  description = "The AWS cloud provider information"

  default = {
    region = "ap-northeast-1"
    credentials_file = "~/.aws/credentials"
    profile = "default"
  }
}

variable "aws_ssh_key_file" {
  description = "The ssh key file using for logining server"

  default = "~/.ssh/aws_shadowsocks_ssh_key"
}
