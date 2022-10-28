#include <gtest/gtest.h>
#include <opencv2/opencv.hpp>
#include <object_detection.hpp>


TEST(Human_Object_Detector, Check_Image_Dimensions) {
cv::Mat image_in = cv::imread("./../app/traffic.jpg");
std::cout << "test:"<<image_in.size();
EXPECT_EQ(660, image_in.size().height);
}

TEST(Human_Object_Detector, Check_Blob_Dimensions) {
BlobGenerator Blob;
cv::Mat image_in;
image_in = cv::imread("./../app/traffic.jpg");
std::cout << "test2: " << image_in.size();
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
/*
std::vector<cv::Mat> preprocessed_data;

preprocessed_data = HOD.preProcessAlgorithm(blob, yolo_model);
EXPECT_EQ(25200, preprocessed_data[0].size[1]);
EXPECT_EQ(85, preprocessed_data[0].size[2]);
*/
}

