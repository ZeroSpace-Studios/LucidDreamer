FROM nvidia/cuda:11.7.1-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y

RUN apt install -y git libglm-dev ninja-build libgl1-mesa-dev ffmpeg libsm6 libxext6

WORKDIR /ld

RUN git clone https://github.com/ZeroSpace-Studios/LucidDreamer.git

WORKDIR /ld/LucidDreamer

RUN apt install -y python3.9 python3-pip python3.9-dev

RUN python3.9 -m pip install -U pip>=20.3 && python3.9 -m pip install -r requirements.txt

RUN export FORCE_CUDA="1" && export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX" && cd submodules/depth-diff-gaussian-rasterization-min && python3.9 setup.py install && cd ../simple-knn && python3.9 setup.py install && cd ../..

RUN python3.9 run.py || true

CMD CUDA_VISIBLE_DEVICES=0 python3.9 app.py
