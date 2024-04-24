
# Run these commands to create multiple docker containers to setup crAPI app:
curl -o docker-compose.yml https://raw.githubusercontent.com/OWASP/crAPI/main/deploy/docker/docker-compose.yml

docker-compose pull

docker-compose -f docker-compose.yml --compatibility up -d



# Stop the containers and delete them:
docker-compose -f docker-compose.yml --compatibility down --volumes




git config --global user.name "Hazem Waddah"
git config --global user.email hazemwaddah@gmail.com