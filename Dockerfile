FROM lambci/lambda:build-python3.6

#RUN yum update -y && \
RUN  yum install -y gcc g++ gcc-c++ cmake wget
#bzip2 xz zlib zlib-devel which
# RUN mkdir -p /var && \
#   mkdir -p /var/task

WORKDIR /var/task

RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz && \
  tar -xJf Python-3.6.1.tar.xz && \
  cd Python-3.6.1 && \
  ./configure --prefix=/var/lang && \
  make -j$(getconf _NPROCESSORS_ONLN) libinstall inclinstall

# ENV PATH=/var/task/Python-3.6.1:$PATH

# RUN wget https://bootstrap.pypa.io/get-pip.py && \
#   python get-pip.py

#USED TO BE THIS, MAYBE TRY IF BROKEN? CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/var/task/Python-3.6.1/:/var/task/Python-3.6.1/Include"
ENV CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/var/task/Python-3.6.1/:/var/task/Python-3.6.1/Include

RUN wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz && \
  tar -xvf boost_1_65_1.tar.gz && \
  cd boost_1_65_1/ && \
  ./bootstrap.sh --with-python=python3.6 --with-libraries=python --prefix=/var/task/Python-3.6.1/ && \
  ./b2

ENV BOOST_INCLUDEDIR=/var/task/boost_1_65_1/ BOOST_ROOT=/var/task/boost_1_65_1/ BOOST_LIBRARYDIR=/var/task/boost_1_65_1/stage/lib/
RUN wget http://dlib.net/files/dlib-19.7.tar.bz2 && \
  tar -xvf dlib-19.7.tar.bz2 && \
  cd dlib-19.7/ && \
  mkdir build && \
  cd build && \
  cmake .. && \
  cmake --build . && \
  cd ../ && \
  python3 setup.py install

ENV LD_LIBRARY_PATH=/var/task/boost_1_65_1/stage/lib/:$LD_LIBRARY_PATH
RUN ldconfig && \
  pip3 install face_recognition

ENTRYPOINT '/bin/bash'
# CMD 'ls -la /dlib && env'
