#!/bin/bash

# for PyTorch v1.4.0, install OpenBLAS
sudo apt-get install libopenblas-base

# Python 3.6 (download pip wheel from above)
cd /tmp
wget https://nvidia.box.com/shared/static/ncgzus5o23uck9i5oth2n8n06k340l6k.whl -O torch-1.4.0-cp36-cp36m-linux_aarch64.whl
sudo pip3 install Cython
sudo pip3 install numpy torch-1.4.0-cp36-cp36m-linux_aarch64.whl
