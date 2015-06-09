#ifndef UTILS_H
#define UTILS_H

#include "stdafx.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

template <typename T,unsigned S>
inline unsigned arraysize(const T (&v)[S]) { return S; }


/*!
 @abstract Computer vision utilities
 */


/**
 * @discussion Replacement for Matlab's bwareaopen()
 * @param image must be 8 bits, 1 channel, black and white (objects)
 * @param values between 0 and 255
 */
void removeSmallBlobs(Mat& im, double size);

/**
 * @discussion Given a color image and a threshold for differentiating black and
 * white, converts the image to a binary and returns it.
 * @param color image
 * @param threshold for differentiating black and white
 * @return the binary (black and white) image
 */
Mat rgb2Binary(const Mat& img, int threshold);

/**
 * @discussion Performs some basic preprocessing and cleaning of a given image and
 * returns a new copy.
 * @param an image
 * @return preprocessed image
 */
Mat preprocess(const Mat& img);

/**
 * @discussion Computes the euclidean distance between two points.
 * @return the euclidean distance between 2 points. 
 * @param first point
 * @param second point
 */
double dist(const cv::Point& p1, const cv::Point& p2);

#endif