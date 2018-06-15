#!/bin/bash

for i in "$@"
do
case $i in
    -r=*|--repo=*)
    REPO_URL="${i#*=}"
    shift
    ;;
esac
done
echo "REPO  = ${REPO_URL}"

sudo apt-get install git cmake curl aptitude

#Install NodeJS
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

#Install JSON for C
sudo apt-get install -y libjson0 libjson0-dev
sudo apt-get install -y libjson0-dbg

#Install Curl library
sudo apt-get install -y libcurl4-gnutls-dev

#Install forever
sudo npm install -y forever -g

#Installation of opencv-3.2.0
sudo apt-get purge -y libopencv4tegra-python libopencv4tegra-dev libopencv4tegra
sudo apt-get purge -y libopencv4tegra-repo
sudo apt-get purge -y python-numpy
sudo apt autoremove -y
sudo apt-get install gir1.2-gstreamer-1.0 gstreamer-tools gstreamer1.0-alsa gstreamer1.0-clutter gstreamer1.0-clutter-3.0 gstreamer1.0-fluendo-mp3 gstreamer1.0-nice gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad-faad gstreamer1.0-plugins-bad-videoparsers gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-ugly-amr gstreamer1.0-pulseaudio gstreamer1.0-tools gstreamer1.0-x libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 libgstreamer-plugins-good1.0-0 libgstreamer1.0-0 libgstreamer1.0-dev libreoffice-avmedia-backend-gstreamer  gstreamer1.0-libav

cd ${PWD}/installation/base64-simple
make
sudo make install

#Remove this add our sh of buildOpencv
#OpenCV Installation
cd ${PWD}/installation/installComputeEngineYOLO
sudo chmod u+x buildOpenCV.sh
./buildOpenCV.sh
cd ~/opencv/build
sudo make install

cd ~/
if [[ -d "ComputeEngine" ]]; then
    echo "In project Directory"
 sudo rm -rf ComputeEngine
 fi
git clone ${REPO_URL}/ComputeEngine

#Installation of project 
cd ~/ComputeEngine/darknet
wget https://pjreddie.com/media/files/yolo.weights
make

cd ~/ComputeEngine/jetsonNodeServer
sudo npm install

cd ${PWD}/installation/installComputeEngineYOLO
sudo chmod +x addCronComputeEngine.sh
./addCronComputeEngine.sh

echo "Installation is done..Do configuration step"