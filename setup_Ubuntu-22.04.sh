#!/usr/bin/env sh

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg


echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null


sudo apt update
sudo apt upgrade -y

sudo apt install ros-humble-desktop

sudo apt install ros-humble-clearpath-desktop
sudo apt-get install ros-humble-clearpath-simulator

# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc


mkdir ~/catkin_ws/src -p

code ~/catkin_ws/src

sudo apt-get update
sudo apt-get upgrade -y
