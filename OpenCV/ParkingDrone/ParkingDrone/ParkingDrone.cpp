// ParkingDrone.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "Utils.h"
#include "SpaceHighlighter.h"
#include "ParkingDetector.h"

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

  // Resizes the image to have 720 rows
	Mat resized(720, 720 * orig.cols / orig.rows, CV_8UC3);
	resize(orig, resized, resized.size());

  Mat img = resized;

  namedWindow("MyWindow", CV_WINDOW_AUTOSIZE); //create a window with the name "MyWindow"

  //------------------- SpaceHighlighter Code -------------------//
  
  Mat binary = preprocess(img);
  for (int r = 0; r < img.rows; r += 50) {
    for (int c = 0; c < img.cols; c += 50) {
      //Mat copy = img.clone();
      if (highlightSpace(img, binary, r, c)) {
        circle(img, Point(c, r), 5, Scalar(0, 255, 0));
      } else {
        circle(img, Point(c, r), 5, Scalar(0, 0, 255));
      }
    }
  }

  /*int r = 100;
  int c = 700;
  Mat binary = preprocess(img);
  bool success = highlightSpace(img, binary, r, c);
  circle(img, Point(c, r), 5, Scalar(0, 255, 0));
  if (!success) {
    cerr << "No available parking space was found around the chosen point." << endl;
  }*/

  imshow("MyWindow", img); //display the image which is stored in the 'img' in the "MyWindow" window
  waitKey(0); //wait infinite time for a keypress
  destroyWindow("MyWindow"); //destroy the window with the name, "MyWindow"

  //-------------------------------------------------------------//


  //-------------------- ParkingDetector Code -------------------//

  /*
  Mat img = orig;

  //img = 255 * preprocess(img);

  //thinning(img);

  imshow("MyWindow", img); //display the image which is stored in the 'img' in the "MyWindow" window

  waitKey(0); //wait infinite time for a keypress
  destroyWindow("MyWindow"); //destroy the window with the name, "MyWindow"
  */

  //-------------------------------------------------------------//

  return 0;
}