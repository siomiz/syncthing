FROM golang:1.9-alpine

LABEL maintainer="Tomohisa Kusano <siomiz@gmail.com>"

ENV PULSE_VERSION v0.14.44

WORKDIR /go/src/github.com/syncthing/syncthing/

COPY entrypoint.sh /entrypoint.sh

RUN apk add -U gnupg git curl build-base \
        && gpg --keyserver keyserver.leg.uct.ac.za --recv-key 49F5AEC0BCE524C7 D26E6ED000654A3E \
	&& git clone https://github.com/syncthing/syncthing . \
	&& git verify-tag "$PULSE_VERSION" \
	&& git checkout "$PULSE_VERSION" \
	&& go run build.go -no-upgrade \
	&& mkdir -p /opt/syncthing \
	&& cp bin/syncthing /opt/syncthing/syncthing \
	&& rm -rf /go/src/github.com /go/src/golang.org /root/.gnupg \
	&& apk del -r --purge gnupg git curl build-base \
	&& chmod +x /entrypoint.sh

WORKDIR /opt/syncthing

VOLUME ["/opt/syncthing/config.d"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8384 22000 21025/udp

CMD ["/opt/syncthing/syncthing", "-home=/opt/syncthing/config.d"]
