FROM ubuntu:16.04
MAINTAINER Przemek Szalko <przemek@mobtitude.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y pptpd iptables freeradius-client

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh

COPY ./etc/radiusclient/* /etc/radiusclient/
RUN echo "INCLUDE /etc/radiusclient/dictionary.microsoft" >> /etc/radiusclient

COPY ./generate_config.sh /generate_config.sh
RUN chmod +x /generate_config.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
