FROM redis

COPY redis-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/redis-entrypoint.sh

VOLUME /etc/redis

EXPOSE 6379

ENTRYPOINT ["bash", "redis-entrypoint.sh"]

