<!--
 * @Author: your name
 * @Date: 2019-12-06 11:06:21
 * @LastEditTime : 2020-01-04 12:42:59
 * @LastEditors  : Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /dl-docker/command.md
 -->
docker build -f /home/ryan/Documents/GitHub/dl-docker/Dockerfile.gpu -t ryan_pytorch_gpu .


docker build -f /home/ryan/Documents/GitHub/dl-docker/Dockerfile.cpu -t ryan_python .

docker create --name ryan_pytorch_server -it   \
    -p 10086:22    \
    --shm-size=10gb \
    --gpus 0 \
    -e DISPLAY= \
    -v /home/tianze/Github:/home/Github \
    -v /home/tianze/Data:/home/Data \
    ryan/dl-docker:gpu  \
    /bin/zsh

docker create --name ryan_python -it   \
    -v /home/tianze/Github:/home/Github \
    -v /home/tianze/Data:/home/Data \
    ryan/dl-docker:cpu\
    /bin/zsh