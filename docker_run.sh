docker run -it --user root \
  --privileged \
  --net=host \
  -v /dev:/dev/ \
  -v /run/udev/:/run/udev/ \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  --group-add video \
  -e HOME=/tmp \
  ros_rpios_jazzy_camera \
  bash
