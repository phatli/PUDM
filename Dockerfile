ARG PYTORCH="1.11.0"
ARG CUDA="11.3"
ARG CUDNN="8"
ARG distro="ubuntu1804"
ARG arch="x86_64"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

RUN apt-key del 7fa2af80 && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && rm /etc/apt/sources.list.d/nvidia-ml.list



# Set timezone
RUN echo 'Etc/UTC' > /etc/timezone \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Singapore /etc/localtime \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install some basic utilities
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y software-properties-common \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    tmux \
    wget \
    netcat \
    iproute2 \
    iputils-ping \
    gnupg2 \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.8 and pip
RUN apt-get update \
    && apt-get install -y python3.8 python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 10 \
    && rm -rf /var/lib/apt/lists/*

# Install Zsh and setup oh-my-zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t ys \
    -p vi-mode \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    && chsh -s /bin/zsh

# Configure tmux to use Zsh as default shell
RUN echo "set-option -g default-shell /bin/zsh" >> ~/.tmux.conf

WORKDIR /root


SHELL ["/bin/zsh", "-c"]

RUN apt-get update && apt-get install -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir open3d termcolor tqdm einops transforms3d==0.3.1 msgpack-numpy lmdb h5py hydra-core==0.11.3 pytorch-lightning==0.7.1 scikit-image black usort flake8 matplotlib jupyter imageio fvcore plotly opencv-python && \
    pip install --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1110/download.html



# Set the default command to zsh
ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]

