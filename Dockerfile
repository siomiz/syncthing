FROM golang:1.3

RUN mkdir -p src/github.com/syncthing
WORKDIR /go/src/github.com/syncthing

ENV PULSE_VERSION v0.10.25

RUN git clone https://github.com/syncthing/syncthing

WORKDIR /go/src/github.com/syncthing/syncthing/
RUN git checkout "$PULSE_VERSION"

RUN go run build.go

RUN mkdir /opt/syncthing && cp bin/syncthing /opt/syncthing/syncthing
RUN rm -rf /go/src/github.com

WORKDIR /opt/syncthing

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/opt/syncthing/config.d"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080 22000 21025/udp

CMD ["/opt/syncthing/syncthing", "-home=/opt/syncthing/config.d"]
