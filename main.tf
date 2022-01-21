terraform {
  required_providers { iterative = { source = "iterative/iterative" } }
}
provider "iterative" {}

resource "iterative_task" "example-gpu" {
  cloud   = "aws"
  machine = "m+t4"   # 4 CPUs and an NVIDIA Tesla T4 GPU
  spot    = 0
  timeout = 24*60*60
  image   = "nvidia" # has CUDA GPU drivers & Docker

  storage {
    workdir = "src"
    output  = "results-gpu"
  }
  environment = { TF_CPP_MIN_LOG_LEVEL = "1" }
  script = <<-END
    #!/bin/bash
    docker run --rm --gpus all -v "$PWD:/tpi" iterativeai/cml:0-dvc2-base1-gpu \
      /bin/bash -c "cd /tpi; pip install -r requirements.txt tensorflow==2.8.0; python train.py --output results-gpu/metrics.json"
  END
}
