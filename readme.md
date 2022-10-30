# **Midterm - Human Object Detection**
[![Build Status](https://github.com/aniruddhbalram97/ENPM808X---Midterm-Project/actions/workflows/build_and_coveralls.yml/badge.svg)](https://github.com/aniruddhbalram97/ENPM808X---Midterm-Project/actions/workflows/build_and_coveralls.yml)

[![Coverage Status](https://coveralls.io/repos/github/aniruddhbalram97/ENPM808X---Midterm-Project/badge.svg?branch=master)](https://coveralls.io/github/aniruddhbalram97/ENPM808X---Midterm-Project?branch=master)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) 


## **Authors and Roles**
### **Phase1:**
**Driver**- Aniruddh Balram

**Navigator**-Mayank Sharma

**Design Keeper**- Joshua Gomes

### **Phase2:**
**Driver**- Joshua Gomes

**Navigator**-Aniruddh Balram

**Design Keeper**-Mayank Sharma

## **Introduction**
Human (N>=1) obstacle detector and tracker based on C++ and OpenCV that employ a computer vision algorithm for location and categorization of human(N>=1) in the picture.
We are seeking to create this tracker utilizing a monocular camera, directly usable in a robot’s reference frame according to the need specifications supplied to us by ACME robotics .

For human recognition and tracking, we will use the robust YOLOv3 neural network model trained on the COCO dataset, which is one of the most accurate real-time object detection techniques. 

## **Diagrams**
### **UML Class Diagram:**
![alt text](./UML_Diagram/Updated_UMLV3/Class_DiagramV3.png)

### **UML Activity Diagram:**

![alt text](./UML_Diagram/Updated_UMLV3/Activity_DiagramV3.png)


## **Results:**
The application currently performs well on single images. For demo purposes, we have used image from The Beatles album-art "The Abbey Road":
### **Input Frame:**

![Input](./app/traffic.jpg)

Humans detected in the frame can be seen below:

### **Output Frame:**
The application predicts the main 4 humans as well as the one behind (barely-visible)

![Output](./Results/test_result.png)

## **Tasks complete**

**IB: 1.101** Get preprocessing working,

**IB: 1.102** Get postprocessing working,

**IB: 1.103** Setup openCV,

**IB: 1.105** Create an iteration development branch/ development branch,

**IB: 1.106** Select and add a software license as a file named LICENSE,

**IB: 1.107** Update UML,

**IB: 1.110** Update readme,

**IB: 1.112** Create classes for program,

**IB: 1.113** Implement cpplint and cppcheck,

**IB: 1.114** Create proper comments and revise old ones,

**IB: 1.115** Update Cmake,

**IB: 1.108** Create a docs directory with generated Doxygen files,

**IB: 1.109** Create unit tests and test coverage,

**IB: 1.111** URL of a 3 minute (max) video explaining the Phase 1 status of your API 

**IB. 2. 201** Research how to track an object in a video

**IB. 2. 202** Change "covercv" typo found all over the program

**IB. 2. 203** Update UML diagram

**IB. 2. 204** Implement distance tracker

**IB. 2. 205** Interface Webcam

**IB. 2. 206** Create Camera Class

**IB. 2. 207** Make the program work on other machines 

**IB. 2. 208** Create new test cases

**IB. 2. 209** Update readme

**IB. 2. 211** Make the program detect objects in a video

**IB. 2. 212** URL of a 5 minute (max) video explaining the Phase 2

### **Task completed partially (Might contains errors due to  build method):**

**IB: 1.104** Setup Github CI

**IB. 2. 210** Get coverall's and build badge to work

### **Task incomplete:**
None

### **Spreadsheet and Sprint Meeting Document Link**

***Spreadsheet link:*** https://docs.google.com/spreadsheets/d/1zVApmpAVnc7thu606UrYKJ7nqtlWpkH1Bv99EHn_2Is/edit?usp=sharing 

***Sprint Meeting Document Link:*** https://docs.google.com/document/d/154Ga8EMY9PfcyO2QEEYlObfffHEXi2clT9GDjFAgel4/edit?usp=sharing

### **Phase 1 Status video:**

https://drive.google.com/file/d/1SrriQnXhLH50-QhWuF40HRacuLYLgIPe/view?usp=sharing

### **Phase 2 Status video:**
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

## **Known Issues/Bugs:**

- The code coverage works on local-system but fails on github
- To show the build badge, we have edited the .github/workflows/build_and_coveralls.yml and commented out the make code_coverage and coveralls segment

```
[100%] Resetting code coverage counters to zero.
5Processing code coverage counters and generating report.
6Deleting all .da files in . and subdirectories
7Done.
8[==========] Running 1 test from 1 test case.
9[----------] Global test environment set-up.
10[----------] 1 test from dummy
11[ RUN      ] dummy.should_pass
12[       OK ] dummy.should_pass (0 ms)
13[----------] 1 test from dummy (0 ms total)
14
15[----------] Global test environment tear-down
16[==========] 1 test from 1 test case ran. (0 ms total)
17[  PASSED  ] 1 test.
18Capturing coverage data from .
19Found gcov version: 9.4.0
20Using intermediate gcov format
21Scanning . for .gcda files ...
22Found 3 data files in .
23Processing test/CMakeFiles/cpp-test.dir/main.cpp.gcda
24/home/runner/work/ENPM808X---Midterm-Project/ENPM808X---Midterm-Project/build/test/CMakeFiles/cpp-test.dir/main.cpp.gcno:version 'A75*', prefer 'A94*'
25geninfo: ERROR: GCOV failed for /home/runner/work/ENPM808X---Midterm-Project/ENPM808X---Midterm-Project/build/test/CMakeFiles/cpp-test.dir/main.cpp.gcda!
26make[3]: *** [CMakeFiles/code_coverage.dir/build.make:74: CMakeFiles/code_coverage] Error 255
27make[2]: *** [CMakeFiles/Makefile2:137: CMakeFiles/code_coverage.dir/all] Error 2
28make[1]: *** [CMakeFiles/Makefile2:144: CMakeFiles/code_coverage.dir/rule] Error 2
29make: *** [Makefile:169: code_coverage] Error 2
30Error: Process completed with exit code 2.
```

### **Notes**

- Doxyfile is found in Code/doc_directory/Doxyfile 
Tasks 

- IB: 1.108, IB: 1.104 and IB. 2. 210  may be implemented incorectly due to build methods 


## **Overview and purpose:**
This program allows an image to be fed into the program, creating bounding boxes around every detected human. The goal is to use this program and make a human tracker out of it, with the input being a video feed. 

In the current program, the input image is a picture of people on a zebra-crossing (found in ./app). The methods to build and run the program is shown in the bottom of this readme. The header file `constants.hpp`, defines important constant values for the program such as blob size, image size, filter thresholds, interface colours and font properties. The header file `object_detection.hpp` initializes the two classes used in this program. Both classes' methods are defined in the implementation file found in ./app.

The two classes used in this program are `BlobGenerator` and `HumanObjectDetector`. 

The class `BlobGenerator` converts an image into blob and allows us to retrieve it.`BlobGenerator::generateBlobFromImage()` allows an image to be inputted and creates a blob from it. 

`BlobGenerator::getBlob()` returns a blob as Mat datatype. 

Derived from BlobGenerator by inheritance, the `HumanObjectDetector` class is used to detect humans in an image. This includes methods to draw bounding boxes, creating labels, prediction(pre-processing) and post-processing. 

`HumanObjectDetector:: labelBox()` is used to draw a label around the 'class-text,' creating a label for the detected object, which is contained in a rectangle.

`HumanObjectDetector::preProcessAlgorithm()` forward propagates the blob into the yolo network. It is trained on COCO-2017 dataset to obtain properties such as confidence and class prediction. 

`HumanObjectDetector:: postProcessAlgorithm()` filters out the low confidence and low-score classes matches labels the prediction with highest probability class. 

`HumanObjectDetector::applyNMSAndAppendRectanglesToImage()` applies Non Maximal Supression and eliminates the redundant overlapping bounding boxes.

For phase 2, there are new classes and functions. 
`HumanObjectDetector::objectDetectorModel()` Combined post and pre-processing methods 

Class `Camera` contain the functions required to use the webcam, and detect a person 

`Camera::getImageInput()` receives a matrix, which is the image frame received from an .png or webcam stream, depending on the value of bool live in `Camera::runLiveDetector(bool live)`.

`Camera::runLiveDetector(bool live, bool test)` if bool live is true, then the program will receive inputs from a webcam stream. If bool live is false, then a .png will be the input.

### **Generate Doxygen document:**
- **Step1:** creates a Doxyfile  
```
doxygen -g
```  

- **Step 2:** Edit the Doxyfile (INPUT and PROJECT_NAME)  

- **Step 3:** To generate html and latex folder  
doxygen ./Doxyfile. (_Once thats done, two folders will be created html and latex, the html folder has index.html which will have the doxygen data_)  

- **Step 4:** INPUT parameter in Doxyfile is the files you want to run doxygen on PROJECT_NAME parameter is the name of the title

- **Step 5:**: Open the Doxygen html file.
```
cd Docs/html
firefox index.html
```

### **Dependencies:**
| Name | Version |
| :---          |    :---:    |
|OpenCV | 4.x |
|lcov | >1.13|
|pytorch | 1.11|



OpenCV:
```
# Install minimal prerequisites (Ubuntu 18.04 as reference)
sudo apt update && sudo apt install -y cmake g++ wget unzip

# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip
unzip opencv.zip
unzip opencv_contrib.zip

# Create build directory and switch into it
mkdir -p build && cd build

# Configure
cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules ../opencv-4.x
# Build

cmake --build .
```
YOLOv5:

```
# Clone the repository. 
git clone https://github.com/ultralytics/YOLOv5

# Install dependencies.
cd YOLOv5 
pip install -r requirements.txt
pip install onnx
 
# Download .pt model.
wget https://github.com/ultralytics/YOLOv5/releases/download/v6.1/YOLOv5s.pt
 
python3 export.py --weights YOLOv5s.pt --include onnx

#in /YOLOv5, move /models into ENPM808X---Midterm-Project/app/

```

### **Steps to Run test:**
```
./test/cpp-test 
```
 
### **Steps to Build and Run Demo:** 
```
# Create build directory and switch into it
mkdir -p build && cd build

# to run without coverage
cmake ..
make

# App run
./app/shell-app

# Test run
./test/cpp-test

# to run with coverage
cmake -D COVERAGE=ON -D CMAKE_BUILD_TYPE=Debug ../
make
# to make code_coverage
make code_coverage

# In /ENPM808X---Midterm-Project/app/main.cpp, cam.runLiveDetector(true, false) will run object detection the webcam.
# cam.runLiveDetector(false, false) will object detection for a sample .png in place in /ENPM808X---Midterm-Project/app/ 

```


