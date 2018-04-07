# Shadowsocks Provider

Providing the containerized Shadowsocks with KCPTun enabled on AWS by the Terraform and Ansible in seconds.

## prerequisite

* AWS Account
* Terraform installed
* Ansible installed

## Get started

### **Step One**

Create the IAM Access Keys from AWS Management Console.

### **Step Two**

* Generate the your own SSH Key for accessing the EC2 instance

```
ssh-keygen -P '' -f ~/.ssh/aws_shadowsocks_ssh_key
```

* Update the variables

Update the variables in `terraform.tfvars` accordingly.

* **Step Three**

Initial and Apply the terraform state

```
terraform init
terraform apply
```

## FAQ

Perform the ansible palybook manually if it is necessary.

```
ansible-playbook -i hosts site.yml -e "$(terraform output --json)"
ansible-playbook -i hosts provision.yml -e "$(terraform output --json)"
```
