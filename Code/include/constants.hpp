/**
 * @file constants.hpp
 * @author Aniruddh Balram (aniruddhbalaram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief Provides constant values for propeties, for  multiple members  
 * @version Implementation 1
 * @date 2022-10-18
 * 
 * @copyright Copyright (c) 2022
 * 
 */

// Constants.h
#include <fstream>

#include <opencv2/opencv.hpp>

// #ifndef MYLIB_CONSTANTS_H
// #define MYLIB_CONSTANTS_H

#ifndef CODE_INCLUDE_CONSTANTS_HPP_
#define CODE_INCLUDE_CONSTANTS_HPP_

// using namespaces
using namespace std;
using namespace cv;
using namespace cv::dnn;
/**
 * @brief Provides constant values  for blob size, image size, filter thresholds, interface colours and font properties 
 * 
 */
namespace ODConstants {
    // Declaring constants for the input blob size
    // Using 640x640 input images
    const double WIDTH_OF_INPUT = 640.0;
    const double HEIGHT_OF_INPUT = 640.0;
    // Defining the thresholds for filtering
    // To filter low probability class score
    const double THRES_SCORE = 0.5;
     // To filter out overlapping boxes using NMS
    const double THRES_NMS = 0.5;
    // Confidence threshold which filters out low confidence detections
    const double THRES_CONF = 0.5;
    // Defining colors
    Scalar R = Scalar(255, 0, 0);
    Scalar G = Scalar(0, 255, 0);
    Scalar B = Scalar(0, 0, 255);
    Scalar BLACK = Scalar(0, 0, 0);
    Scalar WHITE = Scalar(255, 255, 255);
    // Defining font properties
    const double F_SCALE = 1;
    const int F_STYLE = FONT_HERSHEY_COMPLEX;
    const int F_THICKNESS = 2;
}  // namespace ODConstants
#endif  // CODE_INCLUDE_CONSTANTS_HPP_
