FROM ubuntu:22.04 AS BUILDING
RUN  apt-get update
RUN  apt-get install git clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-server p7zip -y
RUN  update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN  update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
COPY . /app
RUN  mkdir build
WORKDIR /app/build
RUN  cmake ../
RUN  make

FROM alpine:3.17.0 AS APPLICATION
COPY --from=BUILDING /app/build/src/server/authserver/authserver /usr/bin/authserver
COPY --from=BUILDING /app/build/src/server/worldserver/worldserver /usr/bin/worldserver
COPY --from=BUILDING /app/build/src/tools/map_extractor/map_extractor /usr/bin/map_extractor
COPY --from=BUILDING /app/build/src/tools/mmaps_generator/mmaps_generator /usr/bin/mmaps_generator
COPY --from=BUILDING /app/build/src/tools/vmap4_assembler/vmap4_assembler /usr/bin/vmap4_assembler
COPY --from=BUILDING /app/build/src/tools/vmap4_extractor/vmap4_extractor /usr/bin/vmap4_extractor

ENTRYPOINT [ "echo",  "Check the README.md file for instructions"]
