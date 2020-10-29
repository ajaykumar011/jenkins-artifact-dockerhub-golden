#!/bin/bash
#docker-compose down -v --rmi=all

docker system prune -f

echo "Stop all running containers"
docker stop $(docker ps -aq)

echo "Remove all containers"
docker rm $(docker ps -aq)

echo "Remove all images"

docker rmi $(docker images -q)
echo "The docker system prune command removes all stopped containers, dangling images, and unused networks:"

docker system prune -f

echo "Stop all running containers"
docker stop $(docker ps -aq)

echo "Remove all containers"
docker rm $(docker ps -aq)

echo "Remove all Volumes and networks"
docker volume prune -f
docker network prune -f
