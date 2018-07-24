FROM nginx:latest

COPY default.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/index.html

COPY entrypoint.sh /usr/share/nginx/bin/entrypoint.sh

RUN chmod a+x /usr/share/nginx/bin/entrypoint.sh

RUN chmod -R a+rwX /usr/share/nginx /etc/nginx /var/cache/nginx /var/run

EXPOSE 8000

CMD /usr/share/nginx/bin/entrypoint.sh
