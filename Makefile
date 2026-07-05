DC_FILE = infra/docker-compose-databases.yml
DC_DATABASE_ENV = infra/.env

.PHONY: db-up-postgres db-up-mysql db-up-sqlserver db-up-oracle db-up-cassandra db-up-mongodb db-up-redis 
.PHONY: execute-postgres execute-mysql execute-sqlserver execute-oracle execute-cassandra execute-mongodb execute-redis
.PHONY: only-delete-containers delete-all-containers delete-all-container-volumes delete-all-containter-networks delete-all-container-images 

ifneq ($(wildcard $(DC_DATABASE_ENV)),)
include $(DC_DATABASE_ENV)
export
endif

# Postgres
db-up-postgres:	
	docker compose -f $(DC_FILE) up -d $(POSTGRES_CONTAINER_NAME)

execute-postgres:
	docker exec -it $(POSTGRES_CONTAINER_NAME) psql -U $(POSTGRES_DB_USER) -d $(POSTGRES_DB_NAME)

# MySQL
db-up-mysql:
	docker compose -f $(DC_FILE) up -d $(MYSQL_CONTAINER_NAME)

execute-mysql:
	docker exec -it $(MYSQL_CONTAINER_NAME) mysql -u $(MYSQL_DB_USER) -p$(MYSQL_DB_PASSWORD) $(MYSQL_DB_NAME)

# Microsoft SQL SERVER
db-up-sqlserver:
	docker compose -f $(DC_FILE) up -d $(MSSQL_CONTAINER_NAME)

execute-sqlserver:
	docker exec -it $(MSSQL_CONTAINER_NAME) /opt/mssql-tools/bin/sqlcmd -S localhost -U $(MSSQL_DB_USER) -P $(MSSQL_DB_PASSWORD) -d $(MSSQL_DB_NAME)

# Oracle
db-up-oracle:
	docker compose -f $(DC_FILE) up -d $(ORACLE_CONTAINER_NAME)

execute-oracle:
	docker exec -it $(ORACLE_CONTAINER_NAME) sqlplus $(ORACLE_DB_USER)/$(ORACLE_DB_PASSWORD)@$(ORACLE_DB_NAME)

# Cassandra
db-up-cassandra:
	docker compose -f $(DC_FILE) up -d $(CASSANDRA_CONTAINER_NAME)

execute-cassandra:
	docker exec -it $(CASSANDRA_CONTAINER_NAME) cqlsh -u $(CASSANDRA_DB_USER) -p $(CASSANDRA_DB_PASSWORD) $(CASSANDRA_HOST_PORT)

# MongoDB
db-up-mongo:
	docker compose -f $(DC_FILE) up -d $(MONGO_CONTAINER_NAME)

execute-mongo:
	docker exec -it $(MONGO_CONTAINER_NAME) mongo -u $(MONGO_DB_USER) -p $(MONGO_DB_PASSWORD) --authenticationDatabase admin $(MONGO_DB_NAME)	

# Redis
db-up-redis:
	docker compose -f $(DC_FILE) up -d $(REDIS_CONTAINER_NAME)

execute-redis:
	docker exec -it $(REDIS_CONTAINER_NAME) redis-cli -a $(REDIS_DB_PASSWORD) -u redis://$(REDIS_DB_USER):$(REDIS_DB_PASSWORD)@localhost:$(REDIS_HOST_PORT)/0

only-delete-containers:
	docker rm -f $$(docker ps -aq)

# Delete all containers, volumes, networks, and images
delete-all-containers:
	docker system prune -a --volumes -f

delete-all-container-volumes:
	docker volume prune -f

delete-all-container-networks:
	docker network prune -f

delete-all-container-images:
	docker image prune -a -f