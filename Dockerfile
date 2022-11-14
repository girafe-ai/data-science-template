ARG BASE_CONTAINER=ubuntu
ARG UBUNTU_VERSION=20.04

FROM $BASE_CONTAINER:$UBUNTU_VERSION

LABEL version="1.0"

WORKDIR /workspace
COPY pyproject.toml .
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    wget \
    curl \
    git \
    vim \
    openssh-client \
    build-essential \
    zip \
    unzip \
    ffmpeg \
    libsm6 \
    libxext6

# install Poetry
ENV POETRY_VERSION=1.2.2
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

ENV CONDA_VERSION=py39_4.12.0

# install conda
RUN wget -O /tmp/Miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh \
  && bash /tmp/Miniconda3.sh -b
ENV PATH "/root/miniconda3/bin:$PATH"
# TODO create conda env, install kernel exploration tool, nbextensions?

RUN conda init bash
RUN conda create --name conda-poetry python=3.9 pip
# RUN conda activate conda-
RUN echo "conda activate conda-poetry" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN python3.9 -m venv $POETRY_VENV \
  && $POETRY_VENV/bin/pip install -U pip setuptools \
  && $POETRY_VENV/bin/pip install poetry==$POETRY_VERSION

ENV PATH="${PATH}:${POETRY_VENV}/bin"
RUN poetry config virtualenvs.create false

RUN poetry install

CMD jupyter notebook --ip 0.0.0.0 --allow-root --no-browser
