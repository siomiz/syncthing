#!/bin/bash
set -e

/opt/syncthing/syncthing -generate="/opt/syncthing/config.d"

/bin/sed -ri 's/127\.0\.0\.1:8080/0.0.0.0:8080/;' /opt/syncthing/config.d/config.xml

exec "$@"
