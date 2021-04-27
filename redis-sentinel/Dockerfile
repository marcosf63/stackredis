FROM redis

EXPOSE 26379

COPY redis-sentinel2.conf /etc/redis/sentinel.conf

RUN chown redis:redis /etc/redis/sentinel.conf

ENV REDIS_MASTER_NAME=mymaster
ENV REDIS_MASTER_HOST=redis-master
ENV REDIS_MASTER_PORT=6379
ENV SENTINEL_QUORUM=2
ENV SENTINEL_DOWN_AFTER=30000
ENV SENTINEL_PARALLEL_SYNC=1
ENV SENTINEL_FAILOVER_TIMEOUT=18000

COPY redis-sentinel-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/redis-sentinel-entrypoint.sh

VOLUME /etc/redis

ENTRYPOINT ["bash", "redis-sentinel-entrypoint.sh"]

