docker-compose -f node-setup-from-snapshot.docker-compose.yml --env-file mainnet.env build --no-cache --force-rm
docker-compose -f node-setup-from-snapshot.docker-compose.yml --env-file mainnet.env up -d --force-recreate --remove-orphans

timeout 10
