#
#  node.js maintenance test service.
#
FROM node:slim

RUN mkdir -p /srv/maintenance-test /var/www/ &&  \
    ln -s /srv/maintenance-test /var/www

COPY server.js /srv/maintenance-test/
ADD  config/   /srv/maintenance-test/config/

WORKDIR /srv/maintenance-test

EXPOSE 8080

CMD ["node", "/srv/maintenance-test/server.js"]
