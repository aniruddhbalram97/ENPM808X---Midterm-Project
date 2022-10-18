/**
 * @file main.cpp
 * @author Aniruddh Balram (aniruddhbalaram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief This program will draw a rectangle around a human, once it is detected in an image
 * @version Implementation 1
 * @date 2022-10-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#pragma once

#include <iostream>
#include <string>
#include <fstream>
#include <vector>

#include <object_detection.hpp>
#include <opencv2/opencv.hpp>


// #include <constants.hpp>

// using namespaces
using namespace std;
using namespace cv;
using namespace cv::dnn;

int main() {
vector<string> class_list;
ifstream ifs;
// string line;
const char* line;
BlobGenerator Blob;
HumanObjectDetector HOD;
// string file_name = "./../app/coco.names";
const char* file_name = "./../app/coco.names";
/**
 * @brief Reads coco.names file, which contains the classes defined within the coco dataset.
 * 
 */
ifs.open(file_name.c_str());
if(ifs.is_open()) {
    cout << "file " << file_name << " is open" << endl;
    while (getline(ifs, line)) {
    class_list.push_back(line);
}
} else {
    cout << "error with file opening" << endl;
    exit(1);
}
ifs.close();
Mat image_in;
image_in = imread("./../app/traffic.jpg");

/**
 * @brief Generate blob from image.
 * 
 */
Blob.generateBlobFromImage(image_in);
Mat blob = Blob.getBlob();

Net yolo_model;/**<Loads the model*/
yolo_model =
readNet("./../app/models/YOLOv5s.onnx");
vector<Mat> preprocessed_data;
preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
vector<Rect> bounding_boxes = HOD.postProcessAlgorithm(preprocessed_data,
image_in, class_list);
Mat img = HOD.applyNMSAndAppendRectanglesToImage(image_in, bounding_boxes,
class_list);
imshow("output", img);
waitKey(0);
return 0;
}



