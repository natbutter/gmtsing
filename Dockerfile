#docker build -t gmtsing .

#To run this, with an interactive python temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run -it --rm -v C:\WORK\Projects\:/workspace gmtsing /bin/bash -c "source /opt/conda/bin/activate pygmt

# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build

#Install ubuntu libraires and packages
RUN apt-get update -y

#Install GMT
RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

#Install a bunch of depencies for python libraries
RUN apt-get update -y && \
	apt-get install libglew-dev python-dev libboost-dev libboost-python-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqtgui4 libqt4-dev libgdal-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev wget -y &&\
	rm -rf /var/lib/apt/lists/*

#Download conda python and install it
RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh 

#Set up the conda environemnt
COPY environment.yml environment.yml
RUN /opt/conda/bin/conda env create -f environment.yml

#Set up GMT
COPY version /etc/motd

#Set up an empty working directory in the container
WORKDIR /workspace
CMD /bin/bash
