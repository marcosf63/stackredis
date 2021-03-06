#!/bin/bash

set e

echo "##############################"
echo "Fazendo o deply da stack-redis"
echo "##############################"

export REDIS_MASTER_HOSTNAME=manager01
export REDIS_WORKER_NODE1_HOSTNAME=manager02
export REDIS_WORKER_NODE2_HOSTNAME=manager03

if [ -z $REDIS_MASTER_HOSTNAME  ] || [ -z $REDIS_WORKER_NODE1_HOSTNAME  ]  || [ -z $REDIS_WORKER_NODE2_HOSTNAME  ] ; 
then
    echo "Faltando argumentos: REDIS_MASTER_HOSTNAME, REDIS_SLAVE_NODE1_HOSTNAME, REDIS_SLAVE_NODE1_HOSTNAME" >&2
    exit 1;
fi



echo "1 - Construindo as imagens usadas nos serviços redis master e workers..."
docker-compose -f redis-master-worker/master-worker-compose-build.yml build
docker-compose -f redis-master-worker/master-worker-compose-build.yml push
echo "Construção finalizada\n"

echo "2 - Construindo a imagem usada no serviço redis-sentinel..."
docker-compose -f redis-sentinel/sentinel-compose-build.yml build
docker-compose -f redis-sentinel/sentinel-compose-build.yml push
echo "Construção finalizada\n"

echo "3 - Fazendo o deploy da Stack"
export REDIS_MASTER_IP=$(docker inspect --format {{.Status.Addr}} $REDIS_MASTER_HOSTNAME)

echo "Master hostname e IP: $REDIS_MASTER_HOSTNAME $REDIS_MASTER_IP"
echo "Redis worker 1 hostname: $REDIS_WORKER_NODE1_HOSTNAME"
echo "Redis worker 2 hostname: $REDIS_WORKER_NODE2_HOSTNAME"

docker stack deploy -c redis-stack.yml stack-redis

echo "Deploy finalizado. Aguarde enqendo os serviços são inicliazado\n\n"

sleep 5s

docker service ls
