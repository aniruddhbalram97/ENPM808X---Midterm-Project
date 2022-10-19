## Steps to run: 
```
# Create build directory and switch into it
mkdir -p build && cd build

# Configure
cmake  ../opencv

#Build
cmake --build .

cd <directory_of_repo>/Code
bash run_detector.sh
```
