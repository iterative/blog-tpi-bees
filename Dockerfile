FROM --platform=linux/amd64 nvidia/cuda:11.4.2-runtime-ubuntu20.04
ENV CONDA_PATH=/opt/anaconda3
ENV ENVIRONMENT_NAME=conda-env-py3.7
SHELL ["/bin/bash", "-c"]

# Install curl to download Anaconda.
RUN apt-get update && apt-get install curl -y python3

# Download and install Anaconda.
RUN cd /tmp && curl -O https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
RUN chmod +x /tmp/Anaconda3-2021.05-Linux-x86_64.sh
RUN mkdir /root/.conda
RUN /bin/bash -c "/tmp/Anaconda3-2021.05-Linux-x86_64.sh -b -p ${CONDA_PATH}"
# /bin/bash ~/anaconda.sh -b -p /opt/conda

# Initializes Conda for bash shell interaction.
RUN ${CONDA_PATH}/bin/conda init bash

# Create the work environment and setup its activation on start.
RUN ${CONDA_PATH}/bin/conda create --name ${ENVIRONMENT_NAME} python=3.7 -y 
RUN echo conda activate ${ENVIRONMENT_NAME} >> /root/.bashrc

COPY ./requirements.txt /tmp/requirements.txt
RUN . ${CONDA_PATH}/bin/activate ${ENVIRONMENT_NAME} \
  && conda env update --name ${ENVIRONMENT_NAME} --file /tmp/requirements.txt --prune

CMD ["python3", "src/train.py"]