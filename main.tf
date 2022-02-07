terraform {
    required_providers { iterative = { source = "iterative/iterative"} }
}
provider "iterative" {}

resource "iterative_task" "tpi-docker-examples" {
    name      = "tpi-docker-examples"
    cloud     = "aws"
    region    = "us-east-2"
    machine   = "m+k80"
    workdir { input = "." }

    script = <<-END
    #!/bin/bash
    sudo apt update -qq && sudo apt install -yqq software-properties-common build-essential ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall
    sudo curl -fsSL https://get.docker.com | sudo sh -
    sudo usermod -aG docker ubuntu
    sudo setfacl --modify user:ubuntu:rw /var/run/docker.sock
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu20.04/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update && sudo apt install -y nvidia-docker2
    sudo systemctl restart docker
    rm get-docker.sh
    
    nvidia-smi
    
    docker run --rm --gpus all -v "$PWD":/app maria9pk2hq/bees:bees python3 src/train.py    
    END
}