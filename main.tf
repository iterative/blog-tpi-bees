terraform {
  required_providers { iterative = { source = "iterative/iterative" } }
}
provider "iterative" {}

# Basic (CPU) version
resource "iterative_task" "example-basic" {
  cloud   = "aws"    # or any of: gcp, az, k8s
  machine = "m"      # medium. Or any of: l, xl, m+k80, xl+v100, ...
  spot    = 0        # auto-price. Default -1 to disable, or >0 for hourly USD limit
  timeout = 24*60*60 # 24h
  image   = "ubuntu"

  storage {
    workdir = "shared"
    output  = "."
  }
  script = <<-END
    #!/bin/bash
    sudo apt-get update -q
    sudo apt-get install -yq python3-pip
    pip3 install -r requirements.txt
    python3 train.py --output metrics-cpu.json
  END
}

# GPU version
resource "iterative_task" "example-gpu" {
  cloud   = "aws"
  machine = "m+t4"   # 4 CPUs and an NVIDIA Tesla T4 GPU
  spot    = 0
  timeout = 24*60*60
  image   = "nvidia" # has CUDA GPU drivers

  storage {
    workdir = "shared"
    output  = "."
  }
  script = <<-END
    #!/bin/bash
    sudo apt-get update -q
    sudo apt-get install -yq python3-pip
    pip3 install -r requirements.txt
    python3 train.py --output metrics-gpu.json
  END
}
