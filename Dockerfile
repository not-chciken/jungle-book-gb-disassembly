FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq
RUN apt-get install  -yq
RUN  apt-get install -yq \
     build-essential \
     cmake \
     gcc \
     git-all \
     python3 \
     python3-pip \
     zip

RUN pip3 install numpy
RUN ln -s /usr/local/lib/python3.8/dist-packages/numpy/core/include/numpy/ /usr/include/numpy
RUN pip3 install bitstream

# Install RGBDS
RUN apt-get install -yq libpng-dev pkg-config bison
RUN git clone --recurse-submodules https://github.com/gbdev/rgbds.git
WORKDIR rgbds
RUN git checkout tags/v0.9.0
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build -j$(nproc)
RUN cmake --install build
WORKDIR ..

# Get JB disassembly
# RUN git clone --recurse-submodules https://github.com/not-chciken/jungle-book-gb-disassembly
# WORKDIR jungle-book-gb-disassembly
# RUN wget rom
# RUN unzip -P ${{secrets.ROM_PASSWORD}} jb.zip
# RUN ./utils/asset_extractor.py jb.sym jb.gb
# RUN cp -r assets/bin src/bin
# RUN cp -r assets/gfx src/gfx
# WORKDIR src
# RUN make all
# RUN md5sum game.gb

ENTRYPOINT bash