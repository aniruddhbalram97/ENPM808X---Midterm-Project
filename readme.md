## Midterm - Human Object Detection
# C++ Boilerplate Badges
[![Build Status](https://github.com/joshuag1214/ENPM808X---Midterm-Project/actions/workflows/build_and_coveralls.yml/badge.png)](https://github.com/joshuag1214/ENPM808X---Midterm-Project/actions/workflows/build_and_coveralls.yml)

[![Coverage Status](https://coveralls.io/repos/github/joshuag1214/ENPM808X---Midterm-Project/badge.png?branch=master)](https://coveralls.io/github/joshuag1214/ENPM808X---Midterm-Project?branch=master)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT) 


### Authors and Roles
Phase1:
Driver- Aniruddh Balram,
Navigator-Mayank Sharma,
Design Keeper- Joshua Gomes

Phase2:
Driver- Joshua Gomes,
Navigator-Aniruddh Balram,
Design Keeper-Mayank Sharma


### Introduction
Human (N>=1) obstacle detector and tracker based on C++ and OpenCV that employ a computer vision algorithm for location and categorization of human(N>=1) in the picture.
We are seeking to create this tracker utilizing a monocular camera, directly usable in a robot’s reference frame according to the need specifications supplied to us by ACME robotics .

For human recognition and tracking, we will use the robust YOLOv3 neural network model trained on the COCO dataset, which is one of the most accurate real-time object detection techniques. 

### UML Diagram:
![alt text](./UML_Diagram/Class_DiagramV2.png)

### Activity Diagram:
![alt text](./UML_Diagram/Activity_Diagram.png)

### Tasks complete

IB: 1.101 Get preprocessing working, 
IB: 1.102 Get postprocessing working,
IB: 1.103 Setup coverCV, 
IB: 1.105 Create an iteration development branch/ development branch, 
IB: 1.106 Select and add a software license as a file named LICENSE, 
IB: 1.107 Update UML,
IB: 1.110 Update readme, 
IB: 1.112 Create classes for program, 
IB: 1.113 Implement cpplint and cppcheck, 
IB: 1.114 Create proper comments and revise old ones, 
IB: 1.115 Update Cmake, 

IB: 1.108 Create a docs directory with generated Doxygen files, 
IB: 1.109 Create unit tests and test coverage, 
IB: 1.111 URL of a 3 minute (max) video explaining the Phase 1 status of your API 
### Results

Input frame:

![WhatsApp Image 2022-10-19 at 9 26 58 PM(1)](https://user-images.githubusercontent.com/106330112/196838006-43acb54a-aca2-4058-98d4-3e163d732f37.jpeg)

Humans detected in the frame can be seen below:


Output:

![Output](https://user-images.githubusercontent.com/106330112/196838392-56e96d2a-b8b9-4585-b071-a476316717a1.jpeg)



### Task completed partially (Might contains errors due to  build method):

IB: 1.104 Setup Github CI
### Task incomplete: 


### Spreedsheet and Sprint Meeting Document Link

Spreadsheet link: https://docs.google.com/spreadsheets/d/1zVApmpAVnc7thu606UrYKJ7nqtlWpkH1Bv99EHn_2Is/edit?usp=sharing 

Sprint Meeting Document Link: https://docs.google.com/document/d/154Ga8EMY9PfcyO2QEEYlObfffHEXi2clT9GDjFAgel4/edit?usp=sharing

### Phase 1 Status video:


https://drive.google.com/file/d/1SrriQnXhLH50-QhWuF40HRacuLYLgIPe/view?usp=sharing

## Known Iissues/Bugs

error with the badge, it  constructed but shows build:failed

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

2 team members cannot build the program. Might have to do something with incorrect installation


### Notes

Doxyfile is found in Code/doc_directory/Doxyfile 
Tasks IB: 1.108 and IB: 1.104 may be implemented incorectly due to build methods 
### Overview and purpose:
This program allows an image to be fed into the program, creating a bounding boxes around every detected human. The goal is to use this program and make a human tracker out of it, with the input being a video feed. In the current program, the input image is a piture of traffic (found in Code/app). The methods to build and run the program is shown in the bottom of this read me. The header file constants.hpp, defines important constant values for the program such as blob size, image size, filter thresholds, interface colours and font properties. The header file object_detection.hpp initiallizes the two classes used in this program. Both classes' methods are defined in the implementation file found in Code/app.

The two classes used in this program are BlobGenerator and HumanObjectDetector. The BlobGenerator allows an image is used to generata blobs and get their dimensions. BlobGenerator::generateBlobFromImage() allows an image to be inputed and creates a blob from it. BlobGenerator::getBlob() returns a blob's N, C, H and W values. Derived from BlobGenerator by inheritance, the HumanObjectDetector class is used to detect humans in an image. This includes methods to draw bounding boxes, creating labels, blob conversion and post-processing. HumanObjectDetector:: labelBox() is used to draw a label around the 'class-text,' creating a lable for the detected object, which is contained in a rectangle. HumanObjectDetector::preProcessAlgorithm() gets an image ready for prepocessing and converts an input image to a blob (forward propagate the input blob into a model). It is trained on COCO 2017 dataset to obtain properties such as confidence and class prediction. HumanObjectDetector:: postProcessAlgorithm() receives the valid class from a pre-processed blob. HumanObjectDetector::
applyNMSAndAppendRectanglesToImage() applies Non Maximal Supression and eliminates the redundant overlapping bounding boxes.
### Generate Doxygen document:
Step1: creates a Doxyfile  
Doxygen -g  

Step 2: Edit the Doxyfile (INPUT and PROJECT_NAME)  

Step 3: To generate html and latex folder  
doxygen ./Doxyfile  

Once thats done, two folders will be created html and latex, the html folder has index.html which will have the doxygen data  

Step 4: INPUT parameter in Doxyfile is the files you want to run doxygen on PROJECT_NAME parameter is the name of the title  

### Steps to Run test:
./test/cpp-test  

### Steps to Build and Run Demo: 
```
# Create build directory and switch into it
mkdir -p build && cd build

# Configure
cmake  ../opencv

#Build
cmake --build .

cd <directory_of_repo>
bash run_detector.sh
```
