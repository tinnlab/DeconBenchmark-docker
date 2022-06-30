# DeconBenchmark Docker Images

This repository contains Dockerfiles for all methods in the [DeconBenchmark](https://github.com/tinnlab/DeconBenchmark) project.

To build the docker image for a method, on a Linux system, run the following command:

```bash
PREFIX=deconbenchmark
TAG=latest
METHOD=AdRoit

# build base image
cd ./base
docker build -t ${PREFIX,,}/base:${TAG,,} .

# build method image
cd ../${METHOD}
docker build --build-arg BASE_IMAGE=${PREFIX,,}/base:${TAG,,} -t ${PREFIX,,}/${METHOD,,}:latest .

# print newly built images
docker image ls | grep ${PREFIX,,} 
```
