terraform {
    required_providers {
        iterative = {
            source = "iterative/iterative",
        }
    }
}

provider "iterative" {}

resource "iterative_task" "tpi-examples-basic" {
    name      = "tpi-examples-basic "
    cloud     = "aws"
    region    = "us-east-2"
    machine   = "l+k80"
    directory = "."

    script = <<-END
    #!/bin/bash
    sudo apt update
    sudo apt-get install -y python3-pip
    pip3 install -r requirements.txt
    python3 src/train.py 
    END
}

resource "iterative_task" "tpi-examples-gpu" {
    name      = "ami-gpu-example"
    cloud     = "aws"
    region    = "us-east-2"
    machine   = "m+k80"
    disk_size = "130"
    image     = "ubuntu@898082745236:x86_64:Deep Learning AMI (Ubuntu 18.04) Version 54.0"
    directory = "."

    script = <<-END
    #!/bin/bash
    pip3 install -r requirements.txt
    python3 src/train.py 
    END
}
