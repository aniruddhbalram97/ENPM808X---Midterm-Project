/**
 * @file human_object_detector.cpp
 * @author Aniruddh Balram (aniruddhbalram97), Mayank Sharma(mayanksharma),  Joshua Gomes (joshuag1214)
 * @brief Implementation file for header files constants.hpp and  <object_detection.hpp
 * @version Implementation 1 
 * @date 2022-10-16
 * 
 * @copyright Copyright (c) 2022
 * 
 */
#include <vector>
#include <constants.hpp>
#include <object_detection.hpp>

void BlobGenerator::generateBlobFromImage(cv::Mat &image_in) {
/// displays dimension of image
std::cout << "Dimensions of Image: " << image_in.size() << std::endl;
std::cout << "Generating Blob from Image.." << std::endl;
cv::dnn::blobFromImage(image_in, blob, 1./255.F,
cv::Size(ODConstants::WIDTH_OF_INPUT,
ODConstants::HEIGHT_OF_INPUT),
cv::Scalar(), true, false);  /// cv2 function to convert image to blob
}

cv::Mat BlobGenerator::getBlob() {
std::cout << "Fetching Blob.." << std::endl;
int N, C, H, W;
N = blob.size[0];
C = blob.size[1];
H = blob.size[2];
W = blob.size[3];
/// displays blob dimensions
std::cout<< "Blob Dimensions:" << N << "x" << C << "x"
<< H << "x" << W << std::endl;
return blob;
}

void HumanObjectDetector:: labelBox(cv::Mat &image_in,
std::string label_value, int posTop, int posLeft) {
    /// base_line is the y-coordinate of the bottom-most text
    int base_line;
    /// getTextSize also sets the base_line for the text.
    /// We pass the address of base_line as a parameter for this reason
    cv::Size size_of_label = cv::getTextSize(label_value,
    ODConstants::F_STYLE, ODConstants::F_SCALE, ODConstants::F_THICKNESS,
    &base_line);
    /// we need the maximum of label or posTop to set the posTop
    posTop = cv::max(posTop, size_of_label.height);
    /// Setting the top-left-corner point based on coordinates
    /// top-left-corner point can be assumed to be image's origin
    cv::Point top_left_corner = cv::Point(posLeft, posTop);
    /// bottom-right-corner point is defined as follows because
    /// positive y axis is downwards as per opencv conventions
    cv::Point bottom_right_corner = cv::Point(posLeft + size_of_label.width,
    posTop + size_of_label.height + base_line);
    /// rectangle - draws a rectangle around the image.
    /// -1 means a filled rectangle.
    /// Can also use cv2::FILLED.
    cv::rectangle(image_in, top_left_corner,
    bottom_right_corner, ODConstants::R, -1);
    /// putText places the text in the position.
    cv::putText(image_in, label_value, cv::Point(posLeft,
    posTop + size_of_label.height),
    ODConstants::F_STYLE, ODConstants::F_SCALE,
    ODConstants::B, ODConstants::F_THICKNESS);
}

std::vector<cv::Mat> HumanObjectDetector:: preProcessAlgorithm(
    cv::Mat blob, cv::dnn::Net &net) {
    std::vector<cv::Mat> preprocessed_data;
    /// setting the blob as the input for the neural-network
    net.setInput(blob);
    /// getUnconnectedLayersName() gets the index of the output layers
    /// for a 640x640 image, it produces a 25200 x 85 - 2D array.
    /// Each row is a prediction and the values within it tell the quality
    /// of prediction. So in effect, if we leave the code here,
    /// it'll produce 25200 bounding boxes if we dont post-process this
    /// data and filter out good quality data.
    net.forward(preprocessed_data, net.getUnconnectedOutLayersNames());
    std::cout << "Preprocessed Data Dimensions: " <<
    preprocessed_data[0].size << std::endl;
    return preprocessed_data;
}

std::vector<cv::Rect> HumanObjectDetector:: postProcessAlgorithm(
std::vector<cv::Mat> &preprocessed_data,
cv::Mat& image_in,
const std::vector<std::string> &name_of_class) {
    /// the rows and columns of preprocessed data array
    int rows = preprocessed_data[0].size[1];
    int columns = preprocessed_data[0].size[2];
    std::cout << "Rows: " << rows << " Columns: " << columns << std::endl;
    /// The images are converted to 640x640 before converting to blob.
    /// To rescale the image back to it's shape
    /// we need scaling factors
    float scale_x = image_in.cols/ODConstants::WIDTH_OF_INPUT;
    float scale_y = image_in.rows/ODConstants::HEIGHT_OF_INPUT;
    std::cout << "Scale X: " << scale_x << std::endl;
    std::cout << "Scale Y: " << scale_y << std::endl;
    /// getUnconnectedOutLayersNames results in a
    /// vector of float matrix : CV_32FC1. To access this:
    /// Reference:
    /// https://stackoverflow.com/questions/34042112/opencv-mat-data-member-access
    float *preprocessed_data_values =
    reinterpret_cast<float*> (preprocessed_data[0].data);
    /// iterating over all the rows
    for (int i = 0; i < rows; ++i) {
        /// Reject data below the confidence threshold
        if (preprocessed_data_values[4] >= ODConstants::THRES_CONF) {
            /// setting the class_scores address starting from the 6th element.
            /// First five are x-center,
            /// y-center, width, height, confidence.
            float *cl_scores = preprocessed_data_values + 5;
            /// creating a matrix called scores (1 x size_of_class_names)
            /// of float type and giving it values of cl_scores
            cv::Mat scores(1, name_of_class.size(), CV_32FC1, cl_scores);
            cv::Point id;
            double cl_score_max;
            /// finds the minimum and maximum values
            /// in scores(global minima and maxima)
            cv::minMaxLoc(scores, 0, &cl_score_max, 0, &id);
            /// check if the max class score is above the score threshold
            if (cl_score_max > ODConstants::THRES_SCORE) {
                /// we store the confidence and id
                /// values of each iteration in vectors
                confidence_values.push_back(preprocessed_data_values[4]);
                ids.push_back(id.x);
                /// get the x-center,y-center, width_of_box and height_of_box
                double x_center = preprocessed_data_values[0];
                double y_center = preprocessed_data_values[1];
                double width_of_box = preprocessed_data_values[2];
                double height_of_box = preprocessed_data_values[3];
                /// obtain the position left, top,
                /// width and height of the bounding box
                int posLeft =
                static_cast<int>((x_center - 0.5 * width_of_box) * scale_x);
                int posTop =
                static_cast<int>((y_center - 0.5 * height_of_box) * scale_y);
                int width =
                static_cast<int>(width_of_box * scale_x);
                int height =
                static_cast<int>(height_of_box * scale_y);
                /// create rectangles and push them into a vector
                bounding_boxes.push_back(cv::Rect(posLeft,
                posTop, width, height));
            }
        }
        /// shifting the address to the start of next row
        preprocessed_data_values += 85;
    }
    std::cout << "Size of Vector containing all bounding boxes:"
    << bounding_boxes.size() << std::endl;
    return bounding_boxes;
}

cv::Mat HumanObjectDetector::
applyNMSAndAppendRectanglesToImage(cv::Mat &image_in,
std::vector<cv::Rect> &bounding_boxes,
const std::vector<std::string> &name_of_class) {
    std::vector<int> idx;
    /// applying NMS
    cv::dnn::NMSBoxes(bounding_boxes, confidence_values,
    ODConstants::THRES_SCORE,
    ODConstants::THRES_NMS, idx);
    std::cout<< "Number of Bounding boxes after NMS: "
    << idx.size() << std::endl;
    for (int i = 0; i < static_cast<int>(idx.size()); i++) {
        if (name_of_class[ids[idx[i]]] == "person") {
        cv::Rect bounding_box = bounding_boxes[idx[i]];
        int posLeft = bounding_box.x;
        int posTop = bounding_box.y;
        int width_of_box = bounding_box.width;
        int height_of_box = bounding_box.height;
        /// drawing bounding box
        cv::rectangle(image_in, cv::Point(posLeft, posTop),
        cv::Point(posLeft + width_of_box, posTop + height_of_box),
        ODConstants::B, 3*ODConstants::F_THICKNESS);
        std::string label_value = name_of_class[ids[idx[i]]] +
        cv::format("%.1f", confidence_values[idx[i]]);
        labelBox(image_in, label_value, posTop, posLeft);
        }
    }
    return image_in;
}
