/**
 * @file object_detection.hpp
 * @author Aniruddh Balram (aniruddhbalaram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief Contains fucntions and variables for class BlobGenerator and HumanObjectDetector
 * @version Implementation 1
 * @date 2022-10-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#pragma once

#include <fstream>
#include <vector>
#include <string>
#include <opencv2/opencv.hpp>

/**
 * @brief Used to generata blobes and get their dimensions
 * 
 */
class BlobGenerator {
 private:
        cv::Mat blob;
 public:
        /**
        * @brief Generates a blobs from a given image
        * 
        * @param image_in - input of image with Mat datatype
        */
        void generateBlobFromImage(const cv::Mat &image_in);
        /**
        * @brief Gets a blob, its dimensions and prints its rows, columns, height and width values
        * 
        * @return Mat 
        */
        cv::Mat getBlob();
};

/**
 * @brief Derived from BlobGenerator by inheritance, this class is used to detect humans in an image.
 * This includes methods to draw bounding boxes, creating labels, blob conversion and post-processing  
 */
class HumanObjectDetector: public BlobGenerator {
 private:
        std::vector<int> ids;
        std::vector<float> confidence_values;
        std::vector<cv::Rect> bounding_boxes;
        cv::dnn::Net net;
        std::vector<cv::Mat> detections;
        std::vector<int> id_nms;
        /// Assuming average height of every human in US is 170.018cm(5'7)
        const double avg_height_of_person = 170.018;
        /// Assuming focal length of our camera to be 1053
        /// https://learnopencv.com/approximate-focal-length-for-webcams-and-cell-phone-cameras/
        const double focal_length = 1053;

 public:
        /**
        * @brief Function used to draw a label around the 'class-text. ' 
        * Creates a lable for the detected object, which is contained in a rectangle 
        * @param image_in - image input in Mat datatype
        * @param label_value - value to the label of the bounding-box. For eg: "Person"
        * @param posTop - top position pixel of the bounding-box
        * @param posLeft - left position pixel of the bounding-box
        */
        void labelBox(const cv::Mat &image_in, std::string label_value,
        int posTop, int posLeft);
        /**
        * @brief Gets an image ready for prepocessing and converts an input image to a blob (forward propagate the input blob into a model).  
        * Trained on COCO 2017 dataset to obtain properties such as confidence and class prediction
        * @param blob - converted image blob
        * @param net - Neural Network model
        * @return vector<Mat> 
        */
        std::vector<cv::Mat> preProcessAlgorithm(
        cv::Mat blob, cv::dnn::Net net);
        /**
        * @brief  Gets the valid class from the preprocessed blob 
        * 
        * @param preprocessed_data - output from preProcessAlgorithm 
        * @param image_in - image input as Mat datatype
        * @param name_of_class 
        * @return vector<cv::Rect> 
        */
        std::vector<cv::Rect> postProcessAlgorithm(
        const std::vector<cv::Mat>& preprocessed_data,
        const cv::Mat& image_in,
        const std::vector<std::string>& name_of_class);
        /**
        * @brief Applies Non Maximal Supression and 
        eliminates the redundant overlapping bounding boxes
        * 
        * @param image_in - image input in Mat datatype
        * @param bounding_boxes - vector 
        * containing bounding box rectangles
        * @param name_of_class - vector containing 
        * names of classes defined in coco-dataset
        * @return Mat 
        */
        cv::Mat applyNMSAndAppendRectanglesToImage(
        const cv::Mat &image_in,
        const std::vector<cv::Rect> &bounding_boxes,
        const std::vector<std::string> &name_of_class);
        void robotCoordinateConversion(const cv::Rect &bbox, int human_id);
        cv::Mat objectDetectorModel(cv::Mat image_in,
        cv::dnn::Net yolo_model,
        const std::vector<std::string> &class_list);
        std::vector<int> getNMSID() {
              return id_nms;
        }
};

class Camera: public HumanObjectDetector {
 private:
        std::vector<std::string> class_list;
        HumanObjectDetector HOD;
        std::ifstream ifs;
        std::string line;
        std::string file_name = "./../app/coco.names";
        cv::dnn::Net yolo_model =
        cv::dnn::readNet("./../app/models/YOLOv5s.onnx");
        cv::Mat image_in;
        cv::Mat img;
 public:
        void runLiveDetector(bool live, bool test);
        cv::Mat getImageInput();
};


