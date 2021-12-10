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
    sudo apt-get install -y software-properties-common build-essential python3-pip

    pip3 install -r requirements.txt
    python3 src/train.py 
    END
}