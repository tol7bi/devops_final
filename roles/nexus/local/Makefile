CONTAINER_NAME = nexus
IMAGE_NAME = nexus-installer:latest

HOST_PORT = 8081
CONTAINER_PORT = 8081

build:
	docker build -t $(IMAGE_NAME) .

run:         
	docker run -d -p $(HOST_PORT):$(CONTAINER_PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME)        

clean:
	docker stop $(CONTAINER_NAME)          
	docker rm $(CONTAINER_NAME)
	docker rmi ${IMAGE_NAME}            

status:
	docker ps -a | grep $(CONTAINER_NAME)  