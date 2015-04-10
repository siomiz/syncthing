FROM golang:1.3

MAINTAINER Tomohisa Kusano <siomiz@gmail.com>

ENV PULSE_VERSION v0.10.30

WORKDIR /go/src/github.com/syncthing/syncthing/

COPY entrypoint.sh /entrypoint.sh

RUN git clone https://github.com/syncthing/syncthing /go/src/github.com/syncthing/syncthing/. \
	&& git checkout "$PULSE_VERSION" \
	&& go run build.go -no-upgrade \
	&& mkdir /opt/syncthing \
	&& cp bin/syncthing /opt/syncthing/syncthing \
	&& rm -rf /go/src/github.com /go/src/golang.org \
	&& chmod +x /entrypoint.sh

WORKDIR /opt/syncthing

VOLUME ["/opt/syncthing/config.d"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080 22000 21025/udp

CMD ["/opt/syncthing/syncthing", "-home=/opt/syncthing/config.d"]
