sshec2:
	ssh -i "tf-key-pair.pem" ubuntu@$$(terraform output -raw ec2_dns_public_name)
	