FROM ubuntu:22.04 AS BUILDING
RUN  apt-get update
RUN  apt-get install git clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-server p7zip -y
RUN  update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN  update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
COPY . /app
RUN  mkdir build
WORKDIR /app/build
RUN  cmake ../
RUN  make -j 2
RUN  make install

ENTRYPOINT [ "echo",  "Check the README.md file for instructions"]
