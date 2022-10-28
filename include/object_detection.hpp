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



/**
 * @brief Class used to contain the functions required to use the webcam, and detect a person    
 * 
 */

class CameraModule{
 private:
       cv::Mat cm_image_in;
       cv::Mat cm_img;
 public:
       /**
        * @brief function that displays webcam's image and creates a bounding box around a person
        * 
        * @param cm_yolo_model -contains path to YOLOv5s.onnx, which contain YOLOv5s models
        * @param cm_file_name -contains path to coco.names, which contain object titles  
        * @param cm_class_list -contains list of objects titles 
        */
       void generateImage(cv::dnn::Net cm_yolo_model,
       std::string cm_file_name, std::vector<std::string> cm_class_list);
};



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
        void generateBlobFromImage(cv::Mat &image_in);
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

 public:
        /**
        * @brief Function used to draw a label around the 'class-text. ' 
        * Creates a lable for the detected object, which is contained in a rectangle 
        * @param image_in - image input in Mat datatype
        * @param label_value - value to the label of the bounding-box. For eg: "Person"
        * @param posTop - top position pixel of the bounding-box
        * @param posLeft - left position pixel of the bounding-box
        */
        void labelBox(cv::Mat& image_in,
        std::string label_value, int posTop, int posLeft);
        /**
        * @brief Gets an image ready for prepocessing and converts an input image to a blob (forward propagate the input blob into a model).  
        * Trained on COCO 2017 dataset to obtain properties such as confidence and class prediction
        * @param blob - converted image blob
        * @param net - Neural Network model
        * @return vector<Mat> 
        */
        std::vector<cv::Mat> preProcessAlgorithm(
        cv::Mat blob, cv::dnn::Net &net);
        /**
        * @brief  Gets the valid class from the preprocessed blob 
        * 
        * @param preprocessed_data - output from preProcessAlgorithm 
        * @param image_in - image input as Mat datatype
        * @param name_of_class 
        * @return vector<cv::Rect> 
        */
        std::vector<cv::Rect> postProcessAlgorithm(
        std::vector<cv::Mat>& preprocessed_data,
        cv::Mat& image_in,
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
        cv::Mat applyNMSAndAppendRectanglesToImage(cv::Mat &image_in,
        std::vector<cv::Rect> &bounding_boxes,
        const std::vector<std::string> &name_of_class);
        /**
         * @brief Combined post and pre-processing methods  
         * 
         * @param image_in -input image from webcam
         * @param yolo_model-contains path to YOLOv5s.onnx, which contain YOLOv5s models 
         * @param class_list -contains list of objects titles 
         * @param file_name -contains path to coco.names, which contain object titles  
         * @return cv::Mat 
         */
        cv::Mat objectDetectorModel(cv::Mat image_in, cv::dnn::Net &yolo_model,
       std::vector<std::string> &class_list,
       std::string &file_name);
};


