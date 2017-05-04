FROM ubuntu:14.04.5
MAINTAINER Przemek Szalko <przemek@mobtitude.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y pptpd iptables radiusclient1

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/* /etc/ppp/

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

COPY ./etc/radiusclient/* /etc/radiusclient/
RUN echo "INCLUDE /etc/radiusclient/dictionary.microsoft" >> /etc/radiusclient/dictionary

COPY ./generate_config.sh /generate_config.sh
RUN chmod +x /generate_config.sh
RUN cp /etc/radiusclient/servers /etc/radiusclient/servers.local

CMD ["/entrypoint.sh"]
