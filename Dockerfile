#docker build -t gmtsing .

#To run this, with an interactive python temrinal, mounting your current host directory in the container directory at /workspace use:
#sudo docker run -it --rm -v C:\WORK\Projects\:/workspace gmtsing /bin/bash -c "source /opt/conda/bin/activate pygmt

# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth

#Create some directories to work with
WORKDIR /build
RUN mkdir /project && mkdir /scratch

#Install ubuntu libraires and packages
#RUN apt-get update -y

#Install GMT
RUN apt-get update -qq && apt-get dist-upgrade -y && \
    apt install vim gmt gmt-dcw gmt-gshhg netcdf-bin -y && \
    echo "cat /etc/motd" >> /root/.bashrc

#Install a bunch of depencies for python libraries
RUN apt-get update -y && \
	apt-get install libglew-dev python3-pip python3-dev libboost-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-system-dev libqtgui4 libqt4-dev libgdal-dev libcgal-dev libproj-dev libqwt-dev libfreetype6-dev libfontconfig1-dev libxrender-dev libice-dev libsm-dev git wget -y
	

RUN apt-get install make libtiff4-dev libglu1-mesa-dev freeglut3-dev -y

RUN wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz && \
	tar -xzvf ./openmpi-1.10.3.tar.gz && \
	cd openmpi-1.10.3 && \
	./configure --prefix=/usr/local/mpi && \
	make all && \
	make install

#Download conda python and install it
#RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh  && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh 

#Set up the conda environemnt
#COPY environment.yml environment.yml
#RUN /opt/conda/bin/conda env create -f environment.yml

RUN pip install -U pip  # fixes AssertionError in Ubuntu pip
RUN pip install enum34
RUN LLVM_CONFIG=llvm-config-3.6 pip install llvmlite==0.8.0
RUN pip install jupyter markupsafe zmq singledispatch backports_abc certifi jsonschema ipyparallel path.py matplotlib mpi4py==1.3.1 git+https://github.com/badlands-model/triangle pandas plotly
RUN apt-get install -y libnetcdf-dev python-mpltoolkits.basemap
RUN pip install Cython==0.20
RUN pip install h5py
RUN pip install scipy
RUN pip install numpy
RUN pip install numba==0.23.1 ez_setup
RUN pip install gFlex
RUN pip install netcdf4
RUN pip install colorlover
RUN pip install cmocean
RUN pip install scikit-fuzzy
RUN pip install pyevtk

RUN git clone https://github.com/intelligentEarth/Bayeslands_continental.git && \
	cd Bayeslands_continental/pyBadlands/libUtils && \
	make all

#And actuall install Bayeslands to python
RUN cd /build && pip install -e Bayeslands_continental/

RUN git clone https://github.com/phargogh/dbfpy3.git && \
	pip install dbfpy3/

RUN rm -rf /var/lib/apt/lists/*

#Set up GMT
COPY version /etc/motd

#Set up an empty working directory in the container
WORKDIR /workspace
CMD /bin/bash

#Add everything to your path as needed

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/mpi/lib:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils
ENV PYTHON_PATH $PYTHON_PATH:/workspace/Bayeslands-basin-continental/pyBadlands/libUtils


WORKDIR /workspace/Bayeslands-basin-continental
