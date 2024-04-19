<!--
 * @Author: Ryan Yu
 * @Date: 2021-01-18 00:30:22
 * @LastEditTime: 2021-01-18 00:55:30
 * @LastEditors: Ryan Yu
 * @Description: Instructions of building docker environment for auto-marking demo.
 * @FilePath: /dockerfile/README.md
 * @---------------------------------
-->

# dl-docker

pytorch docker file based on ubuntu-18.04-cuda 10.2-cudnn7

## 1. Build docker images
for gpu support machine:
> docker build -t image_name:tag -f dockerfile_nroot.gpu .

for cpu support machine:
> docker build -t image_name:tag -f dockerfile_nroot.cpu .

for other packages, add the install command at the bottom of the dockerfile to reduce the compile time.

## 2. Create docker containter

>docker create --name ryan_ocr -it \

-p 6006:6006 \

-p 8080:8080 \

-p 5000:5000 \

-p 10086:22 \

-e DISPLAY=unix$DISPLAY \

-e GDK_SCALE \

-e GDK_DPI_SCALE \

-v /tmp/.X11-unix:/tmp/.X11-unix \

-v /home/ryan/Documents/Github:/home/ryan90/code \

-v /media/ryan/Data:/home/ryan90/data \

--gpus all \

ryan/dl-docker:gpu \

/bin/zsh

## 3. Configurations

1. Use the following command to enable x11 forward to host machine(for GUI applications only)
>xhost +

2. Change the path of the volume that mounted to container using '-v'.

3. For nvidia-GPU support, following the instruction in 'https://github.com/NVIDIA/nvidia-docker' to build nvidia-docker.

## 4. Run
1. use the following command to enter container shell
>docker exec -it container_id /bin/zsh

or use vscode docker extension to manage docker image and container
vscode could config python in container as python interpreter directly.
1. right click on container in vscode
2. attach vistual studio code to container
3. select python in container as interpreter