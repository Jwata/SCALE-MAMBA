CONTAINER?=jwata/scale-mamba
TAG?=latest

container: Dockerfile
	-cd ../ ; docker build -t $(CONTAINER):$(TAG) -f docker/Dockerfile .

