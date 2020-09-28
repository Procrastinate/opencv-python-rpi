FROM python:3.8-slim-buster

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    cmake \
    wget \
    unzip \
    pkg-config \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libatlas-base-dev \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

RUN pip install numpy

WORKDIR /
ENV OPENCV_VERSION="4.4.0"
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
    && unzip opencv.zip \
    && unzip opencv_contrib.zip \
    && mkdir /opencv-${OPENCV_VERSION}/build \
&& cd /opencv-${OPENCV_VERSION}/build \
&& cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_opencv_java=OFF \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D CMAKE_INSTALL_PREFIX=$(python3.8 -c "import sys; print(sys.prefix)") \
    -D PYTHON_INCLUDE_DIR=$(python3.8 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -D PYTHON_PACKAGES_PATH=$(python3.8 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    .. \
    && make -j4 \
    && make install \
    && rm /opencv.zip \
    && rm -r /opencv-${OPENCV_VERSION} \
    && rm /opencv_contrib.zip \
    && rm -r /opencv_contrib-${OPENCV_VERSION}

RUN ln -s \
    /usr/local/python/cv2/python-3.5/cv2.cpython-38m-arm-linux-gnueabihf.so \
    /usr/local/lib/python3.8/site-packages/cv2.so \
    && ldconfig


