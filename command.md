<!--
 * @Author: your name
 * @Date: 2019-12-06 11:06:21
 * @LastEditTime: 2020-02-25 21:24:52
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /dl-docker/command.md
 -->
docker build -f /home/ryan/Documents/GitHub/dl-docker/Dockerfile.gpu -t ryan_pytorch_gpu .

docker build -f /home/ryan/Documents/GitHub/dl-docker/Dockerfile.cpu -t ryan_python .

docker create --name <CONTAINER NAME> -it \
-m 8gb \
-e DISPLAY=unix$DISPLAY \
-e GDK_SCALE \
-e GDK_DPI_SCALE \
-v /dev/video0:/dev/video0 \
-v /dev/video1:/dev/video1 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /root/Proj_code:/root/code \
-v /mnt/d/Data:/root/data \
--gpus all \
<IMAGE ID> \
/bin/zsh

