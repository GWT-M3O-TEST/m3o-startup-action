FROM golang:1.17.8-bullseye

WORKDIR /factory

# set up tools
RUN apt-get update && apt-get upgrade -y && apt-get install unzip

# set up FLutter 2.10.3
# RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.3-stable.tar.xz
# RUN mkdir flutterDev && cd flutterDev
# RUN pwd
# RUN tar xf ../flutter_linux_2.10.3-stable.tar.xz
# RUN export PATH="$PATH:`pwd`/flutter/bin" && cd ..

# set up micro/micro
RUN git clone https://github.com/micro/micro.git

# set up micro/services
RUN git clone https://github.com/micro/services.git

# install protoc v3.20.0
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.20.0/protoc-3.20.0-linux-x86_64.zip
RUN unzip protoc-3.20.0-linux-x86_64.zip
RUN mv bin/protoc /go/bin
RUN mv include /go/bin

# install protoc gen micro plugin
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go get github.com/micro/micro/v3/cmd/protoc-gen-micro@master

# Install openapi plugin
RUN go install github.com/GWT-M3O-TEST/m3o/cmd/protoc-gen-openapi@main

# install generators old/new
RUN go install github.com/GWT-M3O-TEST/m3o/cmd/client-generator@main
RUN go install github.com/GWT-M3O-TEST/m3o/cmd/m3o-client-gen@main

# set working directory to factory/services
WORKDIR /factory/services

COPY entrypoint.sh /entrypoint.sh

# change permission to execute entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]