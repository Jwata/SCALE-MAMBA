container: Dockerfile
	-cd ../ ; docker build -t ${CONTAINER}:latest -f docker/Dockerfile .

env:
	./create_env.sh

clean:
	./clean_env.sh
