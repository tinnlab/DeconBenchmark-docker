# DeconBenchmark Docker Images

This repository contains Dockerfiles for all methods in the [DeconBenchmark](https://github.com/tinnlab/DeconBenchmark) project.

## QUICK START

To build the docker image for a method, on a Linux system, run the following command:

```bash
PREFIX=deconvolution
TAG=latest
METHOD=AdRoit # or any other method name

# build base image first
cd ./base
docker build -t ${PREFIX,,}/base:${TAG,,} .

# build method image
cd ../${METHOD}
docker build --build-arg BASE_IMAGE=${PREFIX,,}/base:${TAG,,} -t ${PREFIX,,}/${METHOD,,}:${TAG,,} .

# print newly built images
docker image ls | grep ${METHOD,,} 
```

## DETAILS

Each of the Dockerfiles in this repository is a Docker image for a method.
All Docker images use the same based image, where we installed the necessary dependencies and set up the environment.

In the base image, we provide some utility functions to help with reading input and writing output files.
Specifically, in `R`, we provide a package `DeconUtils` with two functions `DeconUtils::readArgs` and `DeconUtils::writeH5`.
See folder `base/R` for the source code and documentation of these functions.

The `DeconUtils::readArgs` function reads the input arguments from a `.h5` file and returns a list of arguments.
This `.h5` file is written by `DeconBenchmark::.writeArgs`.
See `?DeconBenchmark::.writeArgs` for the details of all possible inputs and the structure of the `.h5` file.

The `DeconUtils::writeH5` function writes the output cell type proportion and signature matrix to a `.h5` file.

We also provide an equivalent Python package for the same purpose.

To test the newly built docker image, run the following command:

```bash
PREFIX=deconvolution
TAG=latest
METHOD=AdRoit

# Change this to the input file written by DeconBenchmark::.writeArgs
# Or you can use the example file in the `data` folder
INPUT_FILE=./input/input.h5 

docker run --rm -v $INPUT_FILE:/input.h5 -v $PWD:/output -e INPUT_PATH=/input.h5 -e OUTPUT_PATH=/output/$METHOD-results.h5 ${PREFIX,,}/${METHOD,,}:$TAG
```

This command will map `INPUT_FILE` to `/input.h5` in the docker container,
the method will read the input arguments from `/input.h5`.
The output will be written to `/output/$METHOD-results.h5` in the container,
which is mapped to `$PWD/$METHOD-results.h5` in the host machine.

**NOTE**: If you use `Singularity`, the equivalent command is:

```bash
singularity run --env INPUT_PATH=$INPUT_FILE --env OUTPUT_PATH=$METHOD-results.h5 ${PREFIX,,}/${METHOD,,}:$TAG
```

## BUILD YOUR OWN DOCKER IMAGE
To build your own image that works with the `DeconBenchmark`,
the `RUN` command must read the data from the `INPUT_PATH` environment variable
and write the results to `OUTPUT_PATH` environment variable.
The simplest way is to utilize the DeconUtils package.

For example, the running `R` script can be:
```R
args <- DeconUtils::getArgs(c("bulk", "nCellTypes")) # read input arguments from input.h5

result <- # do your work here

S <- result$proportion
P <- result$signature

DeconUtils::writeH5(S, P, "methodName") #Method name is not important, only for logging purpose
```

**NOTE**: For the image to work with `Singularity`, the container must not write files to paths that require root privilege.

## Note on methods that require MATLAB
`BayesCCE`, `Deblender`, and `DecOT` require a MATLAB license to run.
Visit the Matlab license center at [https://www.mathworks.com/licensecenter/licenses](https://www.mathworks.com/licensecenter/licenses) to obtain a license file.
The `hostid` of this license is the same as the `hostid` of the host machine.
If `docker` is used, the user of this license must be `root`.
If `singularity` is used, the user of this license is the same as the user of the host machine.

To run these methods, pass the license file to the container using the environment variable `MLM_LICENSE_FILE`.
For example :
```bash
MLM_LICENSE_FILE=/path/to/license.lic
docker run -v $MLM_LICENSE_FILE:/license.lic -e MLM_LICENSE_FILE=/license.lic ...
```
or 
```bash
singularity run --env MLM_LICENSE_FILE=$MLM_LICENSE_FILE ...
```