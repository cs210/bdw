//
//  DJIRootViewController.m
//  DJISdkDemo
//
//  Created by Ares on 14-6-27.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "DJIRootViewController.h"
#import "CameraTestViewController.h"
#import "GimbalTestViewController.h"
#import "BatteryTestViewController.h"
#import "MainControllerTestViewController.h"
#import "GroundStationTestViewController.h"
#import "RangeExtenderTestViewController.h"
#import "MediaTestViewController.h"
#import "JoystickTestViewController.h"

@interface DJIRootViewController ()

@end

@implementation DJIRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
}

-(IBAction) onCameraButtonClicked:(id)sender
{
    CameraTestViewController* cameraTestViewController = [[CameraTestViewController alloc] initWithNibName:@"CameraTestViewController" bundle:nil];
    [self.navigationController presentViewController:cameraTestViewController animated:YES completion:nil];
}

-(IBAction) onManinControllerButtonClicked:(id)sender
{
    MainControllerTestViewController* mcViewController = [[MainControllerTestViewController alloc] initWithNibName:@"MainControllerTestViewController" bundle:nil];
    [self.navigationController pushViewController:mcViewController animated:YES];
}

-(IBAction) onGroundStationButtonClicked:(id)sender
{
    GroundStationTestViewController* gsViewController = [[GroundStationTestViewController alloc] initWithNibName:@"GroundStationTestViewController" bundle:nil];
    [self.navigationController pushViewController:gsViewController animated:YES];
}

-(IBAction) onJoystickButtonClicked:(id)sender
{
    JoystickTestViewController* joystickController = [[JoystickTestViewController alloc] init];
    [self.navigationController pushViewController:joystickController animated:YES];
}

-(IBAction) onGimbalButtonClicked:(id)sender
{
    GimbalTestViewController* gimbalViewController = [[GimbalTestViewController alloc] initWithNibName:@"GimbalTestViewController" bundle:nil];
    [self.navigationController pushViewController:gimbalViewController animated:YES];
}

-(IBAction) onRangeExtenderButtonClicked:(id)sender
{
    RangeExtenderTestViewController* reViewController = [[RangeExtenderTestViewController alloc] initWithNibName:@"RangeExtenderTestViewController" bundle:nil];
    [self.navigationController pushViewController:reViewController animated:YES];
}

-(IBAction) onBatteryButtonClicked:(id)sender
{
    BatteryTestViewController* batteryViewController = [[BatteryTestViewController alloc] initWithNibName:@"BatteryTestViewController" bundle:nil];
    [self.navigationController pushViewController:batteryViewController animated:YES];
}

-(IBAction) onMediaButtonClicked:(id)sender
{
    MediaTestViewController* mediaViewController = [[MediaTestViewController alloc] initWithNibName:@"MediaTestViewController" bundle:Nil];
    [self.navigationController pushViewController:mediaViewController animated:YES];
}

@end
