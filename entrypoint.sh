#!/bin/bash

set -e

# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# configure firewall
iptables -t nat -A POSTROUTING -s 10.99.99.0/24 ! -d 10.99.99.0/24 -j MASQUERADE
iptables -A FORWARD -s 10.99.99.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356

cp -f /etc/ppp/pptpd-options.local /etc/ppp/pptpd-options
cp -f /etc/radiusclient/servers.local /etc/radiusclient/servers
if [[ $RADIUS_SERVER_ADDRESS ]]; then
    if [[ -z "${RADIUS_SERVER_PORT}" ]]; then
        RADIUS_SERVER_PORT=1812
        exit -1
    fi

    echo "plugin radius.so" >> /etc/ppp/pptpd-options
    echo "plugin radattr.so" >> /etc/ppp/pptpd-options
    echo "${RADIUS_SERVER_ADDRESS} ${RADIUS_SERVER_SECRET}" >> /etc/radiusclient/servers
    /generate_config.sh > /etc/radiusclient/radiusclient.conf
fi

exec pptpd --fg
