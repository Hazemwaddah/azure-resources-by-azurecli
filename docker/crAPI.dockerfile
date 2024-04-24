
# Run these commands to create multiple docker containers to setup crAPI app:
curl -o docker-compose.yml https://raw.githubusercontent.com/OWASP/crAPI/main/deploy/docker/docker-compose.yml

docker-compose pull

docker-compose -f docker-compose.yml --compatibility up -d



# Stop the containers and delete them:
docker-compose -f docker-compose.yml --compatibility down --volumes

# adding "--volumes" removes the containers after stopping the containers


