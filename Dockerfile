# based on Deepmind/alphafold docker file
# adapted for https://github.com/YoshitakaMo/localcolabfold
#
## Copyright 2021 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG CUDA=11.2
ARG CUDA_M=2
FROM nvidia/cuda:${CUDA}.${CUDA_M}-cudnn8-runtime-ubuntu18.04
# FROM directive resets ARGS, so we specify again (the value is retained if
# previously set).
ARG CUDA
ARG CUDA_M
ARG CUDA_JAX=11.1

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      cmake \
      cuda-command-line-tools-${CUDA/./-} \
      git \
      tzdata \
      wget curl\
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
RUN wget https://raw.githubusercontent.com/truatpasteurdotfr/localcolabfold/main/install_colabbatch_linux.sh && bash install_colabbatch_linux.sh
#RUN wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_linux.sh && bash install_colabfold_linux.sh

# We need to run `ldconfig` first to ensure GPUs are visible, due to some quirk
# with Debian. See https://github.com/NVIDIA/nvidia-docker/issues/1399 for
# details.
# ENTRYPOINT does not support easily running multiple commands, so instead we
# write a shell script to wrap them up.
WORKDIR /app/colabfold_batch
