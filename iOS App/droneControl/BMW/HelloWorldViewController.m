//
//  HelloWorldViewController.m
//  droneControl
//
//  Created by BDW on 2015-03-11.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "HelloWorldViewController.h"
#import "HelloWorldDataSource.h"


/* THIS CLASS INTERACTS WITH THE BMW UI. Even though it is a view controller class, it does not have any
 UI as far as iOS is concerned. */
@implementation HelloWorldViewController
- (id)initWithView:(IDView *)view
{
    if (self = [super init])
    {
        _view = (HelloWorldView *)view;
        /*_view.sayHello.text = @"Click Me!";
        [_view.sayHello setTarget:self selector:@selector(clickMeSelected:) forActionEvent:IDActionEventSelect];*/
        [[HelloWorldDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        [[HelloWorldDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceMostRecentWordKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[HelloWorldDataSource sharedDataSource] removeObserver:self forKeyPath:DataSourceClickCountKey];
    [[HelloWorldDataSource sharedDataSource] removeObserver:self forKeyPath:DataSourceMostRecentWordKey];
    
}

#pragma mark - IDButton callbacks

- (void)clickMeSelected:(IDButton *)button
{
    HelloWorldDataSource *dataSource = [HelloWorldDataSource sharedDataSource];
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
        else   if ([mostRecentWord isEqualToString:@"FIND PARKING"]){
            self.view.status.waitingAnimation = true;
            self.view.status.text = @"Drone is finding a parking spot...";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC),dispatch_get_main_queue(), ^{
                self.view.status.waitingAnimation = false;
                self.view.status.text = @"Parking spots found!";
                UIImage *img = [UIImage imageNamed:@"parking_spots_found"];
                NSData *data = UIImagePNGRepresentation(img);
                IDImageData *imgData = [IDImageData imageDataWithData:data];
                self.view.navigationImage.imageData = imgData;
            });
        }
       /* }
        else {
            self.view.speechText.text = [NSString stringWithFormat:@"You said %@!", mostRecentWord];
        }*/
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