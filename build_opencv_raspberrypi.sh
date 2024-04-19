###
 # @Author: Ryan Yu
 # @Date: 2020-02-13 10:44:05
 # @LastEditTime: 2021-09-27 21:41:19
 # @LastEditors: Ryan Yu
 # @Description: script for opencv 3.4.4
 # @FilePath: /Dockerfile/opencv_4.5.sh
 ###
cd /home
# wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.0.zip
# wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.0.zip

unzip opencv.zip
unzip opencv_contrib.zip

mv opencv-4.5.0 opencv
mv opencv_contrib-4.5.0 opencv_contrib

cd /home/opencv
mkdir build
cd build

cd /home
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.2.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.2.zip

unzip opencv.zip
unzip opencv_contrib.zip

mv opencv-4.5.2 opencv
mv opencv_contrib-4.5.2 opencv_contrib

cd /home/opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D PYTHON_EXECUTABLE=/usr/lib/python3 \
-D CMAKE_INSTALL_PREFIX=/usr/local/opencv-4.5.2 \
-D OPENCV_EXTRA_MODULES_PATH=/home/opencv_contrib/modules \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D BUILD_TESTS=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D OPENCV_ENABLE_NONFREE=ON \
-D WITH_GSTREAMER=ON \
-D BUILD_EXAMPLES=OFF ..

make -j$(nproc)
make install

mv /usr/local/opencv-4.5.2/lib/python3.7/dist-packages/cv2/python-3.7/cv2.cpython-37m-arm-linux-gnueabihf.so /usr/local/opencv-4.5.2/lib/python3.7/dist-packages/cv2/python-3.7/cv2.so
ln -s /usr/local/opencv-4.5.2/lib/python3.7/dist-packages/cv2/python-3.7/cv2.so /usr/local/lib/python3.7/dist-packages/cv2.so

cd /home
rm opencv.zip opencv_contrib.zip
rm -rf opencv opencv_contrib
