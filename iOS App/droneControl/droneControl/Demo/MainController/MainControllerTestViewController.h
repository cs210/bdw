//
//  MainControllerTestViewController.h
//  DJIVisionSDK
//
//  Created by Ares on 14-7-16.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <DJISDK/DJISDK.h>

@interface MainControllerTestViewController : UIViewController<DJIDroneDelegate, DJIMainControllerDelegate, CLLocationManagerDelegate>
{
    DJIDrone* _drone;
    UILabel* _connectionStatusLabel;
    
    DJIMCSystemState* mLastSystemState;
    UIAlertView* _goHomeAlertView;
}

@property(nonatomic, strong) IBOutlet UILabel* errorLabel;
@property(nonatomic, strong) IBOutlet UITextView* statusTextView;
@end
