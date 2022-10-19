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
#include <opencv2/opencv.hpp>
#include <object_detection.hpp>

int main() {
std::vector<std::string> class_list;
std::ifstream ifs;
std::string line;
BlobGenerator Blob;
HumanObjectDetector HOD;
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
cv::Mat image_in;
image_in = cv::imread("./../app/traffic.jpg");
// generate blob from image
Blob.generateBlobFromImage(image_in);
cv::Mat blob = Blob.getBlob();
// loading the model
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
std::vector<cv::Mat> preprocessed_data;
preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
std::vector<cv::Rect> bounding_boxes =
HOD.postProcessAlgorithm(preprocessed_data,
image_in, class_list);
cv::Mat img = HOD.applyNMSAndAppendRectanglesToImage(image_in,
bounding_boxes, class_list);
cv::imshow("output", img);
cv::waitKey(0);
return 0;
}



