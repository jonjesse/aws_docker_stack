#USAGE

Get latest terraform docker

```
git pull hashicorp/terraform:latest
```

Run terraform:

```
docker run -it --rm -v <dir>/aws_docker2:/go -v /root/aws:/root -w /go hashicorp/terraform:latest init -var-file="/root/production.tfvars"
```

You may forgo "-var-file", terraform will ask you for the variable when you run it
