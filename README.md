# Collection of docker configurations for ROS on Raspberry Pi 5

This is a collection of docker configurations for ROS on Raspberry Pi 5, including different ROS versions or installed with different OS (e.g. Rasbian OS 64Bit, Ubuntu24.04)

The branches' names indicate the focus and configuration, which follows this naming-style:

```
ros_<OS version>_<ROS version>_<special focus>
```

For exmaple, branch `ros_rpios_jazzy_camera` contains the docker files for ROS jazzy when your RPI5 is installed with Raspberry Pi OS, which has camera access to [camera module 3](https://www.raspberrypi.com/products/camera-module-3/) along with [camera_ros](https://github.com/christianrauch/camera_ros/) node.

Checkout to the branch according to the docker configuration you need, and follow the `README.md` on that branch to build images and containers.

The original master branch is forked from [camera_rpi5_ros2_docker](https://github.com/nguyen-v/camera_rpi5_ros2_docker)
