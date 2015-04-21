//
//  DJICamerViewController.h
//  TestApp
//
//  Created by Ares on 14-9-11.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJIDrone.h>
#import <DJISDK/DJICamera.h>
#import <DJISDK/DJIGimbal.h>
#import <DJISDK/DJISDK.h> //DJIDroneDelegate,

//@class MediaLoadingManager;

@interface DJICamerViewController : UIViewController<DJICameraDelegate,  DJIGimbalDelegate>
{
    DJIDrone* _drone;
    DJICamera* _camera;
    
    //media
//    DJIMediaManager* _mediaManager;
//    MediaLoadingManager* _loadingManager;
    DJIMedia* _media;
    NSArray* _mediasList;
    BOOL _fetchingMedias;
}

@property(nonatomic, retain) IBOutlet UIView* videoPreviewView;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
//@property(nonatomic, retain) DJIMedia* media;
//@property(nonatomic, strong) DJIDrone* _drone;

-(IBAction) onTakePhotoButtonClicked:(id)sender;

-(IBAction) onGimbalScroollDownTouchDown:(id)sender;

-(IBAction) onGimbalScroollDownTouchUp:(id)sender;

@end


//
//typedef void (^MediaLoadingManagerTaskBlock)();
//
//@interface MediaLoadingManager : NSObject {
//    NSArray *_operationQueues;
//    NSArray *_taskQueues;
//    NSUInteger _imageThreads;
//    NSUInteger _videoThreads;
//    NSUInteger _mediaIndex;
//}
//
//- (id)initWithThreadsForImage:(NSUInteger)imageThreads threadsForVideo:(NSUInteger)videoThreads;
//
//- (void)addTaskForMedia:(DJIMedia *)media withBlock:(MediaLoadingManagerTaskBlock)block;
//
//- (void)cancelAllTasks;
//
//@end