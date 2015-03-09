// ************************************************
//
// generated by RHMI Editor 2.3.0 (Build: 2.3 (201407241506))
// project name: HelloWorld
//
// THIS IS GENERATED CODE, DON'T TOUCH!
//
// ************************************************

#import "FlyDroneView.h"


@interface FlyDroneView()

@property (strong, readwrite) IDButton *flyDrone;

@end



@implementation FlyDroneView

- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent
           hmiProvider:(id<IDHmiProvider>)hmiProvider
{
    if (self = [super initWithHmiState:hmiState titleModel:titleModel focusEvent:focusEvent])
    {
        _flyDrone = [[IDButton alloc] initWithWidgetId:1
                                                 model:[hmiProvider modelForId:2]
                                            imageModel:[hmiProvider modelForId:IDInvalidModelId]
                                           targetModel:[hmiProvider modelForId:IDInvalidModelId]
                                              actionId:3
                                               focusId:4];


        _flyDrone.visible = YES;
        _flyDrone.enabled = YES;
        _flyDrone.selectable = YES;
        [self addWidget:_flyDrone];

    }
    return self;
}

- (void)dealloc
{
    [self removeWidget:_flyDrone];
}


@end
