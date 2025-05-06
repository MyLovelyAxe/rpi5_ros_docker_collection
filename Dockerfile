FROM arm64v8/ros:humble

SHELL ["/bin/bash", "-c"]

WORKDIR /app

# Install Dependencies for libcamera
RUN apt update && apt install -y git python3-pip python3-jinja2 \
      libboost-dev \
      libgnutls28-dev openssl libtiff-dev pybind11-dev \
      meson cmake \
      python3-yaml python3-ply \
      libglib2.0-dev libgstreamer-plugins-base1.0-dev \
      ros-humble-rqt-image-view \
      ros-humble-turtlesim \
      && python3 -m pip install --upgrade pip \
      && python3 -m pip install --upgrade meson

# Clone and build raspberrypi's libcamera fork
RUN git clone https://github.com/raspberrypi/libcamera.git \
  && cd libcamera \
  && meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled \
  && ninja -C build install

# Clone and build the camera_ros node
RUN mkdir -p /app/src \
  && cd /app/src \
  && git clone https://github.com/christianrauch/camera_ros.git \
  && source /opt/ros/$ROS_DISTRO/setup.bash \
  && cd /app \
  && rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO --skip-keys=libcamera \
  && rm -rf libcamera/build/meson-private \
  && colcon build --event-handlers=console_direct+

COPY docker_entrypoint.sh /app/

ENTRYPOINT ["/app/docker_entrypoint.sh"]
CMD ["bash"]