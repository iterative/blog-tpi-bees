FROM --platform=linux/amd64 nvidia/cuda:11.4.2-runtime-ubuntu20.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
SHELL ["/bin/bash", "-c"]

WORKDIR /app

# Install wget and python
RUN apt-get update && apt-get install -y wget python3

# Download and install Anaconda.
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

# Create the environment and activate it
COPY ./requirements.txt /tmp/requirements.txt

RUN conda init bash && conda install --yes --file /tmp/requirements.txt

COPY ./src/ src/
COPY ./data/ data/

ENTRYPOINT ["python3", "src/train.py"]
