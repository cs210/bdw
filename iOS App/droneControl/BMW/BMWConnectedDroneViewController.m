//
//  BMWConnectedDroneViewController.h
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "BMWConnectedDroneViewController.h"
#import "BMWConnectedDroneDataSource.h"

@interface BMWConnectedDroneViewController ()
@property bool needConfirmation; // true if the user said FIND PARKING and we want to hear YES. false otherwise

@end


/* THIS CLASS INTERACTS WITH THE BMW UI. Even though it is a view controller class, it does not have any
 UI as far as iOS is concerned. */
@implementation BMWConnectedDroneViewController
- (id)initWithView:(IDView *)view
{
    if (self = [super init])
    {
        _view = (BMWFindParkingView *)view;
        /*_view.sayHello.text = @"Click Me!";
         [_view.sayHello setTarget:self selector:@selector(clickMeSelected:) forActionEvent:IDActionEventSelect];*/
        [[BMWConnectedDroneDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        [[BMWConnectedDroneDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceMostRecentWordKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[BMWConnectedDroneDataSource sharedDataSource] removeObserver:self forKeyPath:DataSourceClickCountKey];
    [[BMWConnectedDroneDataSource sharedDataSource] removeObserver:self forKeyPath:DataSourceMostRecentWordKey];
    
}

#pragma mark - IDButton callbacks

- (void)clickMeSelected:(IDButton *)button
{
    BMWConnectedDroneDataSource *dataSource = [BMWConnectedDroneDataSource sharedDataSource];
    [dataSource increaseClickCount];
}

- (void)updateClickCount:(NSNumber *)clickCount
{
    if ([clickCount compare:@0] == NSOrderedDescending) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.view.sayHello.text = [NSString stringWithFormat:@"Clicked %@ %@!", clickCount, [clickCount compare:@1] == NSOrderedSame ? @"time" : @"times"];
        });
    }
}

- (void)updateMostRecentWord:(NSString *)mostRecentWord
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (mostRecentWord == (NSString *)[NSNull null]){
            self.view.status.text =  @"Say FIND PARKING to fly the drone.";
        }
        else if ([mostRecentWord isEqualToString:@"FIND PARKING"]){
            self.view.status.text =  @"Say YES to confirm and find parking.";
            _needConfirmation = YES;
        } else if ([mostRecentWord isEqualToString:@"NO"]){
            self.view.status.text =  @"Say FIND PARKING to fly the drone.";
            _needConfirmation = NO;
        } else  if ([mostRecentWord isEqualToString:@"YES"]){
            _needConfirmation = NO;
            self.view.status.text =  @"Say FIND PARKING to fly the drone.";
            self.view.status.waitingAnimation = true;
            self.view.status.text = @"Drone is finding a parking spot...";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC),dispatch_get_main_queue(), ^{
                self.view.status.waitingAnimation = false;
                self.view.status.text = @"Parking spots found!";
                UIImage *img = [UIImage imageNamed:@"parking_spots_found_bigger"];
                NSData *data = UIImagePNGRepresentation(img);
                IDImageData *imgData = [IDImageData imageDataWithData:data];
                self.view.navigationImage.imageData = imgData;
            });
        }
    });
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:DataSourceClickCountKey])
    {
        [self updateClickCount:[change valueForKey:NSKeyValueChangeNewKey]];
    }
    else if ([keyPath isEqualToString:DataSourceMostRecentWordKey]){
        [self updateMostRecentWord:[change valueForKey:NSKeyValueChangeNewKey]];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end