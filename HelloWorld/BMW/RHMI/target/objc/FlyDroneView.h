// ************************************************
//
// generated by RHMI Editor 2.3.0 (Build: 2.3 (201407241506))
// project name: HelloWorld
//
// THIS IS GENERATED CODE, DON'T TOUCH!
//
// ************************************************

#import <Foundation/Foundation.h>

#import <BMWAppKit/BMWAppKit.h>

@interface FlyDroneView : IDView

- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent
           hmiProvider:(id<IDHmiProvider>)hmiProvider;

@property (strong, readonly) IDButton *flyDroneButton;

@end
