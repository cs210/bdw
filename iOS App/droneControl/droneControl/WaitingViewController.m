//
//  SimulatedNavigationViewController.m
//  droneControl
//
//  Created by Michael Weingert on 2015-03-16.
//  Copyright (c) 2015 bdw. All rights reserved.
//

/*This is going to be a map interface*/
#import "WaitingViewController.h"

@interface WaitingViewController () {}

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *waitingLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,100,100,100)];
    waitingLabel.text = @"Drone is flying and finding a parking space...";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
