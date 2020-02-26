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

docker create --name test -it  \
-p 6006:6006 \
--gpus all \
--env="DISPLAY" \
-e GDK_SCALE \
-e GDK_DPI_SCALE \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /home/ryan/Documents/GitHub:/root/code \
-v /home/ryan/Documents/Data:/root/data \
ryan_torch:latest \
/bin/zsh
