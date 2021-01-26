FROM rustlang/rust:nightly-buster-slim as builder
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y build-essential make git pkg-config openssl libssl-dev
RUN apt-get install -y libreadline-gplv2-dev libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN apt-get install -y llvm llvm-dev clang cmake

RUN apt-get install -y wget
RUN wget https://www.python.org/ftp/python/3.5.9/Python-3.5.9.tgz
RUN tar xfz Python-3.5.9.tgz
RUN cd Python-3.5.9 && ./configure && make altinstall -j$(nproc)

RUN mkdir /build
COPY . /build
WORKDIR /build

RUN make init
RUN make build

FROM node:current-alpine3.12
RUN apk --no-cache -U upgrade

COPY ./util /contract
RUN yarn install

COPY --from=builder /build/target/ink/erc721.* /contract
COPY --from=builder /build/target/ink/metadata.json /contract

#ENTRYPOINT ["/bin/cargo-contractnode-wivsupplychain"]
#CMD ["--dev", "--ws-external", "--base-path", "/data"]
