//
//  ParkingSpotHighlightBridge.m
//  droneControl
//
//  Created by Michael Weingert on 2015-06-02.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "ParkingSpotHighlightBridge.h"

#include "SpaceHighlighter.h"
#include "Utils.h"

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@implementation ParkingSpotHighlightBridge

using namespace cv;
using namespace std;

-(void) initWithJPG: (NSString *) pathToJPG
{
    Mat orig = imread("Parking.JPG", CV_LOAD_IMAGE_UNCHANGED);

    if (orig.empty())
    {
        cout << "Error : Image cannot be loaded..!!" << endl;
        assert(0);
    }
    
    // Resizes the image to have 720 rows
    Mat resized(720, 720 * orig.cols / orig.rows, CV_8UC3);
    resize(orig, resized, resized.size());
    
    Mat img = resized;
    
    namedWindow("MyWindow", CV_WINDOW_AUTOSIZE); //create a window with the name "MyWindow"
    
    //------------------- SpaceHighlighter Code -------------------//
    
    int r = 550;
    int c = 600;
    bool success = highlightSpace(img, r, c);
    circle(img, cv::Point(c, r), 3, Scalar(0, 0, 255));
}

@end
