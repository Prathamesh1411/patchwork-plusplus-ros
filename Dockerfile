# Base image with ROS Noetic
FROM ros:noetic-ros-core

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Patchwork++
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    ros-noetic-catkin \
    ros-noetic-pcl-ros \
    ros-noetic-velodyne-pointcloud \
    ros-noetic-tf \
    ros-noetic-cv-bridge \
    ros-noetic-image-transport \
    ros-noetic-rviz \
    libeigen3-dev \
    python3 \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install necessary GUI libraries and dependencies for X11 forwarding
RUN apt-get update && apt-get install -y --no-install-recommends \
    x11-apps \
    mesa-utils \
    libgl1-mesa-glx \
    libxrender1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install any additional dependencies for Patchwork++
# (Make sure to adjust this based on the actual dependencies required by Patchwork++)

# Clone and build Patchwork++
WORKDIR /workspace/src
RUN set -e && \
    git clone https://github.com/url-kaist/patchwork-plusplus-ros.git && \
    cd /workspace && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

WORKDIR /workspace/scripts
RUN git clone https://github.com/amslabtech/semantikitti2bag

WORKDIR /workspace
COPY requirements.txt .
RUN pip install -r /workspace/requirements.txt

# Source the workspace
RUN echo "source /workspace/devel/setup.bash" >> ~/.bashrc

# Set entrypoint
ENTRYPOINT ["/bin/bash"]
