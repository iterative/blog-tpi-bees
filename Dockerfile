FROM --platform=linux/amd64 nvidia/cuda:11.3.0-cudnn8-runtime-ubuntu20.04

# Install wget and python
RUN apt-get update && apt-get install -y wget python3-pip

# Add the required packages to the environment
COPY requirements.txt .
RUN pip3 install -r requirements.txt && rm requirements.txt

WORKDIR /tpi