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

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_C_COMPILER=/usr/bin/gcc-9 \
-D PYTHON_EXECUTABLE=/usr/lib/python3.8 \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D BUILD_PYTHON_SUPPORT=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D WITH_TBB=ON \
-D WITH_CUDA=ON \
-D BUILD_opencv_cudacodec=OFF \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D WITH_CUBLAS=1 \
-D WITH_V4L=ON \
-D WITH_QT=OFF \
-D WITH_OPENGL=ON \
-D WITH_GSTREAMER=ON \
-DCV_ENABLE_INTRINSICS=ON -DWITH_EIGEN=ON -DWITH_PTHREADS=ON -DWITH_PTHREADS_PF=ON \
-D WITH_JPEG=ON -DWITH_PNG=ON -DWITH_TIFF=ON\
-D OPENCV_GENERATE_PKGCONFIG=YES \
-D OPENCV_PC_FILE_NAME=opencv.pc \
-D OPENCV_ENABLE_NONFREE=ON \
-D OPENCV_PYTHON3_INSTALL_PATH=/usr/lib/python3/dist-packages \
-D OPENCV_EXTRA_MODULES_PATH=/home/ryan90/code/Dockerfile/opencv_contrib-4.5.2/modules \
-D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
-D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
-D OPENCV_DNN_CUDA=OFF \
-D CUDA_ARCH_BIN=7.5 \
-D BUILD_EXAMPLES=OFF ..
# -D WITH_CUDNN=ON \
# -D OPENCV_PYTHON3_VERSION=ON \


# make -j$(nproc)
# make install

# ldconfig
# pkg-config --modversion opencv4

# mv /usr/lib/python3/dist-packages/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/cv2/python-3.6/cv2.so
# ln -s /usr/lib/python3/dist-packages/cv2/python-3.6/cv2.so /usr/local/lib/python3.6/dist-packages/cv2.so

# cd /home
# rm opencv.zip opencv_contrib.zip
# rm -rf opencv opencv_contrib