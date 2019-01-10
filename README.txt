
                 SCALE and MAMBA

Secure Computation Algorithms from LEuven : SCALE

Multiparty AlgorithMs Basic Argot         : MAMBA

           Tweaked for Docker container.

First type
	make doc
Then *read* the documentation!

The following changes have been made compare to the
original repository:
- Adjusted test scripts to work with docker containers instead of local processes
- Compiling SCALE MPC library as shared library

Testing
To run tests for docker containers for all share configurations, call
run_tests.sh <docker_prefix> <docker_image_name> <docker_volume_arguments> <test_name>

to run tests for docker containers for the currently configured setup, call
Scripts/test.sh <docker_prefix> <docker_image_name> <docker_volume_arguments> <test_name>
where
docker_container_prefix: 
	is a prefix appended to all created containers and volumes
docker_image_name: 
	is the name of the SCALE-MAMBA Docker image (usually: lumip/scale-mamba)
docker_volume_arguments: 
	is a string of Docker volume arguments (-v .... -v ...), e.g.
	"-v $docker_prefix-data:/scale-mamba/data [...]"
test_name: 
	Optionally: one of the test programs to be run. 
	If not given, the scripts runs all test programs.

run_tests.sh requires a docker network to be present as well as the volumes
configured in <docker_volume_arguments> to contain the contents of the Programs 
and Auto-Test-Data folders (Auto-Test-Data/Cert-Store in the cert-ctore volume).

Scripts/test.sh requires the data volume to contain the share and network configuration
to run tests on as well as the certificates in the cert-store volume.

Both script also require a network <docker_prefix>-testnet to be set up with IP
subnet 172.16.0.0/24 (change this in Scripts/run-common.sh if required) and a
container instance with name <docker_prefix>-dummy in which the volumes are mounted.

See the README of the repository for the Docker container [1] for more information
about expected/available volumes.

The test scripts available in that repository also automate testing completey, i.e.,
setting up the Docker environment (volumes, network, dummy container) and execute all
test cases.

[1]: https://github.com/lumip/SCALE-MAMBA-docker
