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
// #include "opencv2/imgproc.hpp"
// #include "opencv2/highgui.hpp"
// #include "opencv2/videoio.hpp"
#include <opencv2/opencv.hpp>
#include <object_detection.hpp>

// const int max_value_H = 360/2;
// const int max_value = 255;
// const String window_capture_name = "Video Capture";
// const String window_detection_name = "Object Detection";
// int low_H = 0, low_S = 0, low_V = 0;
// int high_H = max_value_H, high_S = max_value, high_V = max_value;
// static void on_low_H_thresh_trackbar(int, void *)
// {
//     low_H = min(high_H-1, low_H);
//     setTrackbarPos("Low H", window_detection_name, low_H);
// }
// static void on_high_H_thresh_trackbar(int, void *)
// {
//     high_H = max(high_H, low_H+1);
//     setTrackbarPos("High H", window_detection_name, high_H);
// }
// static void on_low_S_thresh_trackbar(int, void *)
// {
//     low_S = min(high_S-1, low_S);
//     setTrackbarPos("Low S", window_detection_name, low_S);
// }
// static void on_high_S_thresh_trackbar(int, void *)
// {
//     high_S = max(high_S, low_S+1);
//     setTrackbarPos("High S", window_detection_name, high_S);
// }
// static void on_low_V_thresh_trackbar(int, void *)
// {
//     low_V = min(high_V-1, low_V);
//     setTrackbarPos("Low V", window_detection_name, low_V);
// }
// static void on_high_V_thresh_trackbar(int, void *)
// {
//     high_V = max(high_V, low_V+1);
//     setTrackbarPos("High V", window_detection_name, high_V);
// }














int main() {

//  VideoCapture cap(argc > 1 ? atoi(argv[1]) : 0);
//     namedWindow(window_capture_name);
//     namedWindow(window_detection_name);
//     // Trackbars to set thresholds for HSV values
//     createTrackbar("Low H", window_detection_name, &low_H, max_value_H, on_low_H_thresh_trackbar);
//     createTrackbar("High H", window_detection_name, &high_H, max_value_H, on_high_H_thresh_trackbar);
//     createTrackbar("Low S", window_detection_name, &low_S, max_value, on_low_S_thresh_trackbar);
//     createTrackbar("High S", window_detection_name, &high_S, max_value, on_high_S_thresh_trackbar);
//     createTrackbar("Low V", window_detection_name, &low_V, max_value, on_low_V_thresh_trackbar);
//     createTrackbar("High V", window_detection_name, &high_V, max_value, on_high_V_thresh_trackbar);
//     Mat frame, frame_HSV, frame_threshold;
//     while (true) {
//         cap >> frame;
//         if(frame.empty())
//         {
//             break;
//         }
//         // Convert from BGR to HSV colorspace
//         cvtColor(frame, frame_HSV, COLOR_BGR2HSV);
//         // Detect the object based on HSV Range Values
//         inRange(frame_HSV, Scalar(low_H, low_S, low_V), Scalar(high_H, high_S, high_V), frame_threshold);
//         // Show the frames
//         imshow(window_capture_name, frame);
//         imshow(window_detection_name, frame_threshold);
//         char key = (char) waitKey(30);
//         if (key == 'q' || key == 27)
//         {
//             break;
//         }
//     }
    


















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



