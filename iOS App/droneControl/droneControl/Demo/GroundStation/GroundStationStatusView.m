//
//  GroundStationStatusView.m
//  DJIVisionSDK
//
//  Created by Ares on 15/2/5.
//  Copyright (c) 2015年 DJI. All rights reserved.
//

#import "GroundStationStatusView.h"

@implementation GroundStationStatusView

-(id) initWithNib
{
    NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"GroundStationStatusView" owner:self options:nil];
    UIView* mainView = [objs objectAtIndex:0];
    self = [super initWithFrame:mainView.bounds];
    if (self) {
        [self addSubview:mainView];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(IBAction) onCloseButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}

-(void) updateStatus:(NSString*)status
{
    self.contentLabel.text = status;
}

@end
