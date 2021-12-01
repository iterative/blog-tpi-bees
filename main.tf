terraform {
  required_providers {
    iterative = {
      source  = "iterative/iterative"
    }
  }
}

provider "iterative" {}

resource "iterative_task" "gpu_tutorial" {
  name  = "bees-gpu-training-1"
  cloud = "aws" 
  region = "us-east-2"
  machine = "p2.xlarge"

  directory = "${path.root}/shared"

  script = <<-END
    #!/bin/bash
    sudo apt update && sudo apt install --yes docker.io  
    sudo usermod -aG docker $USER
    newgrp docker
    docker pull maria9pk2hq/bees:bees
    docker run maria9pk2hq/bees:bees

  END
}





