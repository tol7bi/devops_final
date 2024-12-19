DOCKER_IMAGE=sonarqube-installer:latest
CONTAINER_NAME=sonarqube
SONARQUBE_HOST=http://sonarqube:9000
SONAR_SCANNER=sonarsource/sonar-scanner-cli

PROJECT_KEY=AppTest
SONAR_TOKEN=sqa_df5fa946083eb2a86a2240d88b210cbefc086d01

ARCHITECTURE := $(shell uname -m)
ifeq ($(ARCHITECTURE),x86_64)
    PLATFORM := linux/amd64
else ifeq ($(ARCHITECTURE),aarch64)
    PLATFORM := linux/arm64/v8
else
    PLATFORM := linux/amd64
endif

build:
	docker build -t $(DOCKER_IMAGE) .

run:
	docker network create sonarnet
	docker run -d --name $(CONTAINER_NAME) -p 9000:9000 --network sonarnet $(DOCKER_IMAGE)

analyze:
	cd ./code && \
	docker run --rm --platform $(PLATFORM) --network sonarnet -e SONAR_HOST_URL=$(SONARQUBE_HOST) \
		-e SONAR_SCANNER_OPTS="-Dsonar.projectKey=$(PROJECT_KEY) -Dsonar.login=$(SONAR_TOKEN)" \
		-v "$$(pwd):/usr/src" $(SONAR_SCANNER) -X

clean:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
	docker network rm sonarnet
