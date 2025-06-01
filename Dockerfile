FROM arm64v8/ubuntu:22.04

SHELL ["/bin/bash", "-c"]

# Avoid interactive prompts during installs
ENV DEBIAN_FRONTEND=noninteractive

# Set locale
RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Add the ROS 2 GPG key and repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=arm64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list

# Install ROS 2 Humble
RUN apt-get update && apt-get install -y ros-humble-desktop python3-rosdep python3-colcon-common-extensions \
    && rosdep init \
    && rosdep update

# Source ROS in bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Create workspace
WORKDIR /app

# Install dependencies for libcamera
RUN apt-get update && apt-get install -y \
    vim iputils-ping \
    git python3-pip python3-jinja2 \
    libboost-dev \
    libgnutls28-dev openssl libtiff-dev pybind11-dev \
    meson cmake \
    python3-yaml python3-ply \
    libglib2.0-dev libgstreamer-plugins-base1.0-dev \
    ros-humble-rqt-image-view \
    ros-humble-demo-nodes-cpp ros-humble-demo-nodes-py \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --upgrade meson

# Clone and build libcamera
RUN git clone https://github.com/raspberrypi/libcamera.git \
  && cd libcamera \
  && meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled \
  && ninja -C build install

# Clone and build camera_ros
RUN mkdir -p /app/src \
  && cd /app/src \
  && git clone https://github.com/christianrauch/camera_ros.git

# Install ROS 2 dependencies (after source)
RUN source /opt/ros/humble/setup.bash \
  && cd /app \
  && rosdep install -y --from-paths src --ignore-src --rosdistro humble --skip-keys=libcamera \
  && rm -rf libcamera/build/meson-private \
  && colcon build --event-handlers=console_direct+

# Add entrypoint
COPY docker_entrypoint.sh /app/
ENTRYPOINT ["/app/docker_entrypoint.sh"]
CMD ["bash"]
