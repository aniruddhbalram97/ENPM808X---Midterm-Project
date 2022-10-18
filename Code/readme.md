# C++ Boilerplate Badges
[![Build Status](https://github.com/joshuag1214/Midterm-Project--ENPM808X/actions/workflows/build_and_coveralls.yml/badge.svg)](https://github.com/joshuag1214/Midterm-Project--ENPM808X/actions/workflows/build_and_coveralls.yml)

[![Coverage Status](https://coveralls.io/repos/github/joshuag1214/Midterm-Project--ENPM808X/badge.svg?branch=master)](https://coveralls.io/github/joshuag1214/Midterm-Project--ENPM808X?branch=master)


## Steps to run: 
```
# Create build directory and switch into it
mkdir -p build && cd build

# Configure
cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules ../opencv

#Build
cmake --build .

cd <directory_of_repo>/Code
bash run_detector.sh
```
