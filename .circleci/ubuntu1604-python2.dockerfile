FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        chromium-browser \
        cmake \
        expect \
        expect-dev \
        gdb \
        gir1.2-gstreamer-1.0 \
        gir1.2-gudev-1.0 \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-tools \
        gstreamer1.0-x \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        liblockdev1-dev \
        libopencv-dev \
        liborc-0.4-dev \
        librsvg2-bin \
        libudev-dev \
        libxrandr-dev \
        lighttpd \
        moreutils \
        pep8 \
        python-dev \
        python-docutils \
        python-flask \
        python-gi \
        python-jinja2 \
        python-kitchen \
        python-lxml \
        python-matplotlib \
        python-mock \
        python-nose \
        python-numpy \
        python-opencv \
        python-pip \
        python-pysnmp4 \
        python-qrcode \
        python-requests \
        python-scipy \
        python-serial \
        python-yaml \
        python-zbar \
        ratpoison \
        socat \
        swig \
        tesseract-ocr \
        tesseract-ocr-deu \
        tesseract-ocr-eng \
        v4l-utils \
        wget \
        xdotool \
        xserver-xorg-video-dummy \
        xterm && \
    apt-get clean

RUN pip install \
        astroid==1.4.8 \
        isort==3.9.0 \
        pylint==1.6.4 \
        pytest==3.3.1 \
        responses==0.5.1

RUN mkdir -p /src && \
    cd /src && \
    git clone -b libcec-3.1.0 https://github.com/Pulse-Eight/libcec.git && \
    git clone -b p8-platform-2.0.1 https://github.com/Pulse-Eight/platform.git && \
    mkdir platform/build && \
    cd platform/build && \
    cmake .. && \
    make && \
    sudo make install && \
    cd ../.. && \
    mkdir libcec/build && \
    cd libcec/build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -DPYTHON_INCLUDE_DIR:PATH=/usr/include/python2.7 \
        -DPYTHON_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libpython2.7.so \
        -DPYTHON_EXECUTABLE:FILEPATH=/usr/bin/python2.7 \
        .. && \
    make && \
    sudo make install

# Ubuntu parallel package conflicts with moreutils, so we have to build it
# ourselves.
RUN mkdir -p /src && \
    cd /src && \
    { wget http://ftpmirror.gnu.org/parallel/parallel-20140522.tar.bz2 || \
      wget http://ftp.gnu.org/gnu/parallel/parallel-20140522.tar.bz2 || \
      exit 0; } && \
    tar -xvf parallel-20140522.tar.bz2 && \
    cd parallel-20140522/ && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd && \
    rm -rf /src && \
    mkdir -p $HOME/.parallel && \
    touch $HOME/.parallel/will-cite  # Silence citation warning
