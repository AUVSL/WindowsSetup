#!/usr/bin/env sh


sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d$

sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt update
sudo apt install ros-melodic-desktop-full -y

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential  -y
sudo apt install python-rosdep  -y

sudo apt-get install ros-melodic-jackal-simulator ros-melodic-jackal-desktop ros-melodic-jackal-navigation  -y
sudo apt-get install ros-melodic-husky-simulator  -y

sudo rosdep init
rosdep update

sudo apt-get update
sudo apt-get upgrade -y

mkdir ~/catkin_ws/src -p
code ~/catkin_ws/src