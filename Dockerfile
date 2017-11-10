FROM amazonlinux:2017.03.1.20170812

RUN yum install -y blas-devel boost-devel lapack-devel gcc-c++ cmake python-devel git

RUN git clone https://github.com/davisking/dlib.git /dlib-src

RUN cd /dlib-src/python_examples/ && \
  mkdir build && \
  cd build && \
  cmake -D USE_SSE4_INSTRUCTIONS:BOOL=ON ../../tools/python && \
  cmake --build . --config Release --target install

RUN mkdir -p /dlib && \
  cp /dlib-src/python_examples/dlib.so /dlib/__init__.so && \
  cp /usr/lib64/libboost_python-mt.so.1.53.0 /dlib/ && \
  touch /dlib/__init__.py

ENTRYPOINT '/bin/bash'
CMD 'ls -la /dlib'
