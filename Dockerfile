FROM ubuntu
MAINTAINER leifj@sunet.se
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-shib2 ssl-cert augeas-tools
RUN a2dismod mpm_prefork mpm_worker
RUN a2enmod rewrite ssl shib2 proxy proxy_http proxy_balancer lbmethod_byrequests headers cgi mpm_event
ENV SP_HOSTNAME ac.example.com
ENV SP_CONTACT noc@nordu.net
ENV SP_ABOUT /about
ENV METADATA_SIGNER md-signer.crt
ENV APPSERVERS "app1.example.com app2.example.com"
ENV DEFAULT_LOGIN md.nordu.net
RUN rm -f /etc/apache2/sites-available/*
RUN rm -f /etc/apache2/sites-enabled/*
ADD start.sh /start.sh
RUN chmod a+rx /start.sh
ADD md-signer.crt /etc/shibboleth/md-signer.crt
ADD attribute-map.xml /etc/shibboleth/attribute-map.xml
ADD secure /var/www/secure
ADD shibd.logger /etc/shibboleth/shibd.logger
COPY /apache2.conf /etc/apache2/
EXPOSE 443
EXPOSE 80
ENTRYPOINT ["/start.sh"]
