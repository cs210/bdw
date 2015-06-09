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
#import "SpeechController.h"
#import "DJICameraViewController.h"
#import "TransparentTouchView.h"
#import "AerialViewController.h"
typedef enum
{
    kListening,
    kNotListening
} listeningStates;



@interface IntroPageViewController () <SpeechDelegate>{
    SpeechController * speechController;
    listeningStates _currentState;
}

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
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 200, self.view.center.y * 4 / 5, 400,100)];
    label.text = @"Or say \"Find Parking\".";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:label];
}


-(void) addDronePicture{
    UIImageView *droneImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"drone_white.png"]];
    [droneImgView setFrame:CGRectMake(self.view.center.x - 150, self.view.center.y * 1.1, 300, 300)];
    [self.view addSubview:droneImgView];
}


- (void)viewDidLoad {
    [self addTitle];
    [self addParkingButton];
    [self addDronePicture];
    [super viewDidLoad];
    speechController = [[SpeechController alloc] initWithDelegate:self];
    [speechController setupSpeechHandler];
    [speechController startListening];
    _currentState = kListening;
    
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) findParkingClicked{
    [speechController stopListening];

    // Create a new view controller for the aerial view controller
    AerialViewController * mapController = [[AerialViewController alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];

}


// SpeechDelegate stuff
-(NSArray * ) listOfWordsToDetect
{
    return @[ @"FIND PARKING", @"YES", @"CANCEL"];
}


-(void) didReceiveWord: (NSString *) word
{
    
    NSLog(@"Word heard:%@", word);
    if ([word containsString:@"FIND PARKING"]){
        [self findParkingClicked];
    }
    
}

@end