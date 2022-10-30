/**
 * @file constants.hpp
 * @author Aniruddh Balram (aniruddhbalram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
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

#ifndef INCLUDE_CONSTANTS_HPP_
#define INCLUDE_CONSTANTS_HPP_
/**
 * @brief Provides constant values  for blob size, image size, filter thresholds, interface colours and font properties 
 * 
 */
namespace ODConstants {
    const double WIDTH_OF_INPUT = 640.0;  /// width of input image
    const double HEIGHT_OF_INPUT = 640.0;  /// height of input image
    /// score-threshold: to eliminate low-scored predictions
    const double THRES_SCORE = 0.5;
    /// NMS-threshold: to eliminate low NMS bounding boxes
    const double THRES_NMS = 0.5;
    /// confidence-threshold: to eliminate low-confidence predictions
    const double THRES_CONF = 0.5;
    cv::Scalar R = cv::Scalar(255, 0, 0);  /// red-color
    cv::Scalar G = cv::Scalar(0, 255, 0);  /// green-color
    cv::Scalar B = cv::Scalar(0, 0, 255);  /// blue-color
    cv::Scalar BLACK = cv::Scalar(0, 0, 0);  /// black-color
    cv::Scalar WHITE = cv::Scalar(255, 255, 255);  /// white-color
    const double F_SCALE = 0.5;  /// font-scale
    const int F_STYLE = cv::FONT_HERSHEY_SIMPLEX;  /// font-style
    const double F_THICKNESS = 0.2;  /// font-thickness
}  // namespace ODConstants
#endif  // INCLUDE_CONSTANTS_HPP_
