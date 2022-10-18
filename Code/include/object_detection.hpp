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

#include <fstream>
#include <vector>
#include <string>

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;
using namespace cv::dnn;
/**
 * @brief Used to generata blobes and get their dimensions
 * 
 */
class BlobGenerator{
 private:
    Mat blob;
 public:
    /**
     * @brief Generates a blobs from a given image
     * 
     * @param image_in 
     */
    void generateBlobFromImage(Mat &image_in);
    /**
        * @brief Gets a blob, its dimensions and prints its N, C, H and W values
        * 
        * @return Mat 
        */
    Mat getBlob();
};

/**
 * @brief Derived from BlobGenerator by inheritance, this class is used to detect humans in an image.
 * This includes methods to draw bounding boxes, creating lables, blob conversion and post-processing  
 */
class HumanObjectDetector: public BlobGenerator {
 private:
    vector<int> ids;
    vector<float> confidence_values;
    vector<Rect> bounding_boxes;
    Net net;
    vector<Mat> detections;

 public:
    /**
     * @brief Function used to draw a label around the 'class-text. ' 
     * Creates a lable for the detected object, which is contained in a rectangle 
     * @param image_in 
     * @param label_value 
     * @param posTop 
     * @param posLeft 
     */
    void labelBox(Mat& image_in, string label_value, int posTop, int posLeft);

    /**
     * @brief Gets an image ready for prepocessing and converts an input image to a blob (forward propagate the input blob into a model).  
     * Trained on COCO 2017 dataset to obtain properties such as confidence and class prediction
     * @param blob 
     * @param net 
     * @return vector<Mat> 
     */
    vector<Mat> preProcessAlgorithm(Mat blob, Net &net);
    /**
     * @brief  Gets the valid class from the preprocessed blob 
     * 
     * @param preprocessed_data 
     * @param image_in 
     * @param name_of_class 
     * @return vector<Rect> 
     */
    vector<Rect> postProcessAlgorithm(vector<Mat>& preprocessed_data,
    Mat& image_in, const vector<string>& name_of_class);
    /**
     * @brief Applies Non Maximal Supression and draws bounding boxes around detected objects
     * 
     * @param image_in 
     * @param bounding_boxes 
     * @param name_of_class 
     * @return Mat 
     */
    Mat applyNMSAndAppendRectanglesToImage(Mat &image_in,
    vector<Rect> &bounding_boxes, const vector<string> &name_of_class);
};

