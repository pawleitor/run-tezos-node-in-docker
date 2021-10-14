docker-compose -f node-setup-from-snapshot.docker-compose.yml --env-file mainnet.env up -d --remove-orphans

timeout 10
