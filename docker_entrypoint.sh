#!/bin/bash
set -e

source /opt/ros/${ROS_DISTRO}/setup.bash
source /app/install/setup.bash

export ROS_DOMAIN_ID=0 # make sure both devices have the same domain id
export ROS_LOCALHOST_ONLY=0 # make sure ROS not only connect its local host network
export ROS_IP=192.168.178.41 # the IP address of laptop

exec "$@"
