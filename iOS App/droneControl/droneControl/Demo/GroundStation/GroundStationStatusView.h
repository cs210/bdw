//
//  GroundStationStatusView.h
//  DJIVisionSDK
//
//  Created by Ares on 15/2/5.
//  Copyright (c) 2015年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroundStationStatusView : UIView

@property(nonatomic, strong) IBOutlet UILabel* contentLabel;

-(id) initWithNib;

-(void) updateStatus:(NSString*)status;

@end
