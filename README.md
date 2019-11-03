# dl-docker
pytorch docker file based on ubuntu-18.04-cuda 10.0-cudnn7

1. build docker images
> docker build -f /home/ryan/Documents/GitHub/dl-docker/Dockerfile.gpu -t ryan_pytorch_gpu .

for other packages, add the install command at the bottom of the dockerfile to reduce the compile time.

2. Use docker compose config file *.yml as interpreter in pycharm. 
Remember to change the mapping path in .yml.
