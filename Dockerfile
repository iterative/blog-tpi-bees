FROM --platform=linux/amd64 nvidia/cuda:11.3.0-cudnn8-runtime-ubuntu20.04
SHELL ["/bin/bash", "-c"]

# Install wget and python
RUN apt-get update && apt-get install -y wget python3-pip

# Add the required packages to the environment
COPY ./src/requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt

WORKDIR app
