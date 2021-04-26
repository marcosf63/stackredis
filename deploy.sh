#!/bin/bash

set e

echo "##############################"
echo "Fazendo o deply da stack-redis"
echo "##############################"

export SENTINEL_HOSTNAME=$1
export REDIS_MASTER_HOSTNAME=$2
export REDIS_WORKER_NODE1_HOSTNAME=$3
export REDIS_WORKER_NODE2_HOSTNAME=$4

if [ -z $SENTINEL_HOSTNAME  ] || [ -z $REDIS_MASTER_HOSTNAME  ] || [ -z $REDIS_WORKER_NODE1_HOSTNAME  ]  || [ -z $REDIS_WORKER_NODE2_HOSTNAME  ] ; 
then
    echo "Faltando argumentos: SENTINEL_HOSTNAME, REDIS_MASTER_HOSTNAME, REDIS_SLAVE_NODE1_HOSTNAME, REDIS_SLAVE_NODE1_HOSTNAME" >&2
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

echo "2 - Construindo a imagem usada no serviço app..."
docker-compose -f python-app-example/app-compose-build.yml build
docker-compose -f python-app-example/app-compose-build.yml push
echo "Construção finalizada\n"


echo "4 - Fazendo o deploy da Stack"
echo "Sentinel hostname: $SENTINEL_HOSTNAME"
echo "Master hostname: $REDIS_MASTER_HOSTNAME"
echo "Redis worker 1 hostname: $REDIS_WORKER_NODE1_HOSTNAME"
echo "Redis worker 2 hostname: $REDIS_WORKER_NODE2_HOSTNAME"

docker stack deply -c redis-stack.yml stack-redis

echo "Deploy finalizado. Aguarde enqendo os serviços são inicliazado\n\n"

sleep 3s

docker servces ls



