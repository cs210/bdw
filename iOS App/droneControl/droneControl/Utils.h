#ifndef UTILS_H
#define UTILS_H

#include "stdafx.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

template <typename T,unsigned S>
inline unsigned arraysize(const T (&v)[S]) { return S; }

/**
 * Replacement for Matlab's bwareaopen()
 * Input image must be 8 bits, 1 channel, black and white (objects)
 * with values 0 and 255 respectively
 */
void removeSmallBlobs(Mat& im, double size);

/**
 * Given a color image and a threshold for differentiating black and
 * white, converts the image to a binary and returns it.
 */
Mat rgb2Binary(const Mat& img, int threshold);

/**
 * Performs some basic preprocessing and cleaning of a given image and
 * returns a new copy.
 */
Mat preprocess(const Mat& img);

/**
 * Computes the euclidean distance between two points.
 */
double dist(const cv::Point& p1, const cv::Point& p2);

#endif