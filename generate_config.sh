#!/bin/bash

cat <<_EOF
auth_order radius,local
login_tries 4
login_timeout 60
nologin /etc/nologin
issue /etc/radiusclient/issue
authserver ${RADIUS_SERVER_ADDRESS}:${RADIUS_SERVER_PORT}
#acctserver RADIUS_SERVER_IP_OR_HOSTNAME:1813
servers /etc/radiusclient/servers
dictionary /etc/radiusclient/dictionary
login_radius /usr/sbin/login.radius
seqfile /var/run/radius.seq
mapfile /etc/radiusclient/port-id-map
default_realm
radius_timeout 10
radius_retries 3
login_local /bin/login
_EOF