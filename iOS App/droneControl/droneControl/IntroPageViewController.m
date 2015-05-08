//
//  IntroPageViewController.m
//  droneControl
//
//  Created by Ellen Sebastian on 5/7/15.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "introPageViewController.h"
@interface IntroPageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *findParkingButton;

@end

@implementation IntroPageViewController : UIViewController

- (void)viewDidLoad {
    _findParkingButton.layer.cornerRadius = 10.0f;
}


@end