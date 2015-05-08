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

//@property (weak, nonatomic) IBOutlet UIButton *findParkingButton;
@property (weak, nonatomic) UIButton *findParkingButton;

@end

@implementation IntroPageViewController : UIViewController

-(void) addTitle{
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 200, self.view.center.y / 5, 400,100)];
    label.text = @"ConnectedDrone";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:36];
    [self.view addSubview:label];
    
}

-(void) addParkingButton{
    UIButton *findParkingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [findParkingButton addTarget:self
                           action:@selector(findParkingClicked)
                 forControlEvents:UIControlEventTouchUpInside];
    [findParkingButton setTitle:@"Find Parking Spot" forState:UIControlStateNormal];
    float width = 400.0;
    float height = 100.0;
    findParkingButton.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - 150, width,height);
     findParkingButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [findParkingButton titleLabel].textColor = [UIColor blackColor];
    [[findParkingButton titleLabel] setFont:[UIFont systemFontOfSize:36]];
    [findParkingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    findParkingButton.layer.cornerRadius = 10.0f;
    [self.view addSubview:findParkingButton];
}

-(void) addDronePicture{
    UIImageView *droneImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"drone_white.png"]];
    [droneImgView setFrame:CGRectMake(self.view.center.x - 150, self.view.center.y * 1.1, 300, 300)];
    [self.view addSubview:droneImgView];

}

- (void)viewDidLoad {
    //self.view.backgroundColor = [UIColor clearColor];
    [self addTitle];
    [self addParkingButton];
    [self addDronePicture];
}

-(void) findParkingClicked{
    
}

@end