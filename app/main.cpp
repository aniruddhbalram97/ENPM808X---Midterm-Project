/**
 * @file main.cpp
 * @author Aniruddh Balram (aniruddhbalram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief This program will draw a rectangle around a human, once it is detected in an image
 * @version Implementation 1
 * @date 2022-10-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <chrono>
#include <ctime>
#include <opencv2/highgui.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/opencv.hpp>
#include <object_detection.hpp>



int main() {
std::vector<std::string> class_list;
std::ifstream ifs;
std::string line;
std::string file_name = "./../app/coco.names";
ifs.open(file_name.c_str());
if(ifs.is_open()) {
    std::cout << "file " << file_name << " is open" << std::endl;
    while (std::getline(ifs, line)) {
    class_list.push_back(line);
}
} else {
    std::cout << "error with file opening" << std::endl;
    exit(1);
}
ifs.close();
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");

/*
// !!!!!!!!!!!!!!
cv::Mat image_in;
cv::namedWindow("Object Detection");

cv::VideoCapture cap(0);
if(!cap.isOpened()) {
   std::cout << "Cannot Open Camera";
}
*/

// !!!!!!!!
// cv::Mat img;

CameraModule Camera;

Camera.generateImage(yolo_model, file_name,  class_list);

// !!!!!!!!!!
/*
while (true) {
    auto start = std::chrono::system_clock::now();
    cap >> image_in;

    img = HOD.objectDetectorModel(image_in,yolo_model,
    class_list,file_name);
    
    cv::imshow("Object Detection", img);
    
    auto end = std::chrono::system_clock::now();
    
    std::chrono::duration<double> elapsed_seconds = end-start;
    
    std::cout<<"elapsed time: " << elapsed_seconds.count()<<std::endl;
    
    cv::waitKey(25);
}
*/


// image_in = cv::imread("./../app/traffic.jpg");
// cv::Mat img = HOD.objectDetectorModel(image_in);
// cv::imshow("output", img);
// cv::waitKey(0);
return 0;
}



