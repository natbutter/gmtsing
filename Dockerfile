#docker build -t gmtsing .

#To run this, with an interactive python2 temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run -it --rm -v C:\WORK\Projects\:/workspace gmt /bin/bash

#To run a jupyter notebook server with the python 2 conda environement
#sudo docker run -p 8888:8888 -it --rm -v`pwd`:/workspace pyg /bin/bash -c "source activate py2GEOL && jupyter notebook --allow-root --ip=0.0.0.0 --no-browser"

# Pull base image.
# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build

#Install ubuntu libraires and packages
RUN apt-get update -y

RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

RUN apt-get update -y && \
	apt-get install libglew-dev python-dev libboost-dev libboost-python-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqtgui4 libqt4-dev libgdal-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev wget -y &&\
	rm -rf /var/lib/apt/lists/*

#Download conda python because I like it
RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh 

COPY environment.yml environment.yml
RUN /opt/conda/bin/conda env create -f environment.yml

COPY version /etc/motd


WORKDIR /workspace
CMD /bin/bash
