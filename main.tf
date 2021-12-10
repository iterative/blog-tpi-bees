terraform {
    required_providers {
        iterative = {
            source = "iterative/iterative",
        }
    }
}

provider "iterative" {}

resource "iterative_task" "tpi-examples-gpu" {
    name      = "tpi-examples-gpu"
    cloud     = "aws"
    region    = "us-east-2"
    machine   = "m+k80"
    directory = "."

    script = <<-END
    #!/bin/bash
    sudo apt update
    sudo apt-get install -y software-properties-common build-essential ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall
    sudo curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh &&
    sudo usermod -aG docker ubuntu
    sudo setfacl --modify user:ubuntu:rw /var/run/docker.sock
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu20.04/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update && sudo apt install -y nvidia-docker2
    sudo systemctl restart docker
    rm get-docker.sh
    nvidia-smi
    docker run --rm --gpus all -v "$PWD:/tpi" iterativeai/cml:0-dvc2-base1-gpu \
        /bin/bash -c "cd /tpi; pip install -r requirements.txt; python src/train.py"
    END
}