FROM golang:1.3

RUN mkdir -p src/github.com/syncthing
WORKDIR /go/src/github.com/syncthing

ENV PULSE_VERSION v0.10.3

RUN git clone https://github.com/syncthing/syncthing

WORKDIR /go/src/github.com/syncthing/syncthing/
RUN git checkout "$PULSE_VERSION"

RUN go run build.go

RUN mkdir /opt/syncthing && cp bin/syncthing /opt/syncthing/syncthing
RUN rm -rf /go/src/github.com

WORKDIR /opt/syncthing

CMD ["-home=config", "-gui-address=0.0.0.0:8080"]

EXPOSE 8080 22000 21025/udp

ENTRYPOINT ["./syncthing"]
