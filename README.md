# ROS humble in docker on Raspberry Pi 5 with Rasbian Bookworm 64bit with camera_ros

This branch collects the docker configuration for ROS humble on Rasberry Pi OS with access of [camera module v3](https://www.raspberrypi.com/products/camera-module-3/), along with [camera_ros](https://github.com/christianrauch/camera_ros/) node.

The original master branch is forked from [camera_rpi5_ros2_docker](https://github.com/nguyen-v/camera_rpi5_ros2_docker) but with main changes:

 - Add rqt-image-view for visualize live-stream camera on Rapsberry Pi 5 itself
 - Add turtlesim to check and learn
 - Add user root in docker_run.sh to grand root permission in container
 - Add access to display docker_run.sh

## Test configuration

- Raspberry Pi 5 (8GB Model tested)
- Rasbian OS 64Bit (Bookworm)
- Docker

## Setup

Clone this repo, enter the branch `ros_rpios_humble_camera`, and make sure `docker_run.sh` is executable.

```
git clone git@github.com:MyLovelyAxe/rpi5_ros_docker_collection.git
cd rpi5_ros_docker_collection
git checkout ros_rpios_humble_camera
chmod +x docker_run.sh
```

Also, make sure your current `USER` is inside `groups`, in order to run the following commands without specifying sudo, i.e. use `$ docker` instead of `$ sudo docker`:

```
sudo usermod -aG docker $USER
```

Check if your `USER` is already in `groups` by:

```
groups
```

If your `USER` is in the returned list, then move on.

## Build image

Run the bash file to build the image whose name is the same with the branch name:

```
./build_image.sh
```

## Creat container

Note: The docker build process adds the file `docker_entrypoint.sh` which sources the required ROS2 `setup.bash` files when the container starts.

From the command line, run the following to start the docker container and the `camera_ros` node:

```
./docker_run.sh
```

Check the current runnning container's name by:

```
docker ps
```

## Test camera

Firstly, enable access of display for docker in a terminal:

```
xhost +local:docker
```

Remember: Run this command every time when reboot Raspberry Pi 5.

Then test camera in other terminals:

#### Terminal 1: start camera_ros node

```
docker exec -it <current_container_name> bash
source docker_entrypoint.sh
ros2 run camera_ros camera_node
```

#### Terminal 2: start qrt-image-view GUI

```
docker exec -it <current_container_name> bash
source docker_entrypoint.sh
ros2 run rqt_image_view rqt_image_view
```