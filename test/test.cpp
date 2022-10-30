/**
 * @file test/test.cpp
 * @author Aniruddh Balram (aniruddhbalram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief Contains test-cases for the application
 * @version Implementation 1
 * @date 2022-10-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <gtest/gtest.h>
#include <opencv2/opencv.hpp>
#include <../include/object_detection.hpp>


TEST(Human_Object_Detector, Check_Image_Dimensions) {
Camera cam;
cam.runLiveDetector(false, true);
cv::Mat image_in = cam.getImageInput();
EXPECT_EQ(660, image_in.size().height);
}

TEST(Human_Object_Detector, Check_Blob_Dimensions) {
BlobGenerator Blob;
cv::Mat image_in;
image_in = cv::imread("./../app/traffic.jpg");
Blob.generateBlobFromImage(image_in);
cv::Mat blob = Blob.getBlob();
EXPECT_EQ(1, blob.size[0]);
EXPECT_EQ(3, blob.size[1]);
EXPECT_EQ(640, blob.size[2]);
EXPECT_EQ(640, blob.size[3]);
}

TEST(Human_Object_Detector, Check_Preprocessed_Data_Output) {
BlobGenerator Blob;
HumanObjectDetector HOD;
cv::Mat image_in = cv::imread("./../app/traffic.jpg");
Blob.generateBlobFromImage(image_in);
cv::Mat blob = Blob.getBlob();
EXPECT_EQ(660, image_in.size().height);
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
std::vector<cv::Mat> preprocessed_data;
preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
EXPECT_EQ(25200, preprocessed_data[0].size[1]);
EXPECT_EQ(85, preprocessed_data[0].size[2]);
}

TEST(Human_Object_Detector, Check_Postprocessed_Data_Output) {
BlobGenerator Blob;
HumanObjectDetector HOD;
std::ifstream ifs;
std::string line;
std::vector<std::string> class_list;
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
cv::Mat image_in = cv::imread("./../app/traffic.jpg");
Blob.generateBlobFromImage(image_in);
cv::Mat blob = Blob.getBlob();
EXPECT_EQ(660, image_in.size().height);
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
std::vector<cv::Mat> preprocessed_data;
preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
std::vector<cv::Rect> bounding_boxes;
bounding_boxes = HOD.postProcessAlgorithm(preprocessed_data,
image_in, class_list);
EXPECT_EQ(127, bounding_boxes.size());
}

TEST(Human_Object_Detector, Check_NMS_Output) {
BlobGenerator Blob;
HumanObjectDetector HOD;
std::ifstream ifs;
std::string line;
std::vector<std::string> class_list;
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
cv::Mat image_in = cv::imread("./../app/traffic.jpg");
Blob.generateBlobFromImage(image_in);
cv::Mat blob = Blob.getBlob();
EXPECT_EQ(660, image_in.size().height);
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
std::vector<cv::Mat> preprocessed_data;
preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
std::vector<cv::Rect> bounding_boxes;
bounding_boxes = HOD.postProcessAlgorithm(preprocessed_data,
image_in, class_list);
cv::Mat img = HOD.applyNMSAndAppendRectanglesToImage(image_in,
bounding_boxes, class_list);
std::vector<int> id_nms = HOD.getNMSID();
EXPECT_EQ(13, id_nms.size());
}

TEST(Human_Object_Detector, Check_Final_Image_Dimensions) {
BlobGenerator Blob;
HumanObjectDetector HOD;
std::ifstream ifs;
std::string line;
std::vector<std::string> class_list;
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
cv::Mat image_in = cv::imread("./../app/traffic.jpg");
cv::dnn::Net yolo_model;
yolo_model = cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
cv::Mat img = HOD.objectDetectorModel(image_in, yolo_model,
class_list);
EXPECT_EQ(660, img.size().height);
}
