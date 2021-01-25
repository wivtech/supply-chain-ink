FROM rustlang/rust:nightly-buster-slim as builder
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y make git pkg-config openssl libssl-dev
RUN apt-get install -y llvm llvm-dev clang

RUN mkdir build
COPY . /build
WORKDIR /build

RUN make init && make build

FROM debian:buster-slim
#COPY --from=builder /build/target/release/node-wivsupplychain /bin/

#RUN mkdir /data

#ENTRYPOINT ["/bin/node-wivsupplychain"]
#CMD ["--dev", "--ws-external", "--base-path", "/data"]
