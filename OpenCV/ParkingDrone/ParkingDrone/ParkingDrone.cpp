// ParkingDrone.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "Utils.h"
#include "SpaceHighlighter.h"

using namespace std;
using namespace cv;

int main(int argc, char* argv[])
{
  Mat orig = imread("Parking.JPG", CV_LOAD_IMAGE_UNCHANGED);
  if (orig.empty())
  {
      cout << "Error : Image cannot be loaded..!!" << endl;
      return -1;
  }

  //Mat img = preprocess(orig);

  namedWindow("MyWindow", CV_WINDOW_AUTOSIZE); //create a window with the name "MyWindow"

  //------------------- SpaceHighlighter Code -------------------//

  /*
  int r = 325;
  int c = 450;
  highlightSpace(img, r, c);

  imshow("MyWindow", img); //display the image which is stored in the 'img' in the "MyWindow" window
  waitKey(0); //wait infinite time for a keypress
  destroyWindow("MyWindow"); //destroy the window with the name, "MyWindow"
  */

  //-------------------------------------------------------------//


  //-------------------- ParkingDetector Code -------------------//

  Mat img = orig;

  Mat resized(720, 720 * img.cols / img.rows, CV_8UC3);
	resize(img, resized, resized.size());
  img = resized;
  cvtColor(img, img, CV_RGB2GRAY);

  cv::threshold(img, img, 127, 255, cv::THRESH_BINARY);
  cv::Mat skel(img.size(), CV_8UC1, cv::Scalar(0));
  cv::Mat temp;
  cv::Mat eroded;
 
  cv::Mat element = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3, 3));
 
  bool done;		
  do
  {
    cv::erode(img, eroded, element);
    cv::dilate(eroded, temp, element); // temp = open(img)
    cv::subtract(img, temp, temp);
    cv::bitwise_or(skel, temp, skel);
    eroded.copyTo(img);
 
    done = (cv::countNonZero(img) == 0);
  } while (!done);

  imshow("MyWindow", img); //display the image which is stored in the 'img' in the "MyWindow" window

  waitKey(0); //wait infinite time for a keypress
  destroyWindow("MyWindow"); //destroy the window with the name, "MyWindow"

  //-------------------------------------------------------------//

  return 0;
}