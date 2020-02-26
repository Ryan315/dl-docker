###
 # @Author: Ryan Yu
 # @Date: 2020-02-13 10:44:05
 # @LastEditTime: 2020-02-25 21:58:12
 # @LastEditors: Please set LastEditors
 # @Description: script for opencv 3.4.4
 # @FilePath: /dl-ocker/run.sh
 ###
cd /home
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.4.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.4.zip

unzip opencv.zip
unzip opencv_contrib.zip

mv opencv-3.4.4 opencv
mv opencv_contrib-3.4.4 opencv_contrib

cd /home/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/home/opencv_contrib/modules \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_EXAMPLES=ON ..

make -j4
make install

ldconfig
pkg-config --modversion opencv

mv /usr/local/python/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so /usr/local/python/cv2/python-3.6/cv2.so
ln -s /usr/local/python/cv2/python-3.6/cv2.so /usr/local/lib/python3.6/dist-packages/cv2.so

rm opencv.zip opencv_contrib.zip
rm -rf opencv opencv_contrib