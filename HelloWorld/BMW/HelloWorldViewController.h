#import "HelloWorldView.h"
#import "LastUserModeDelegate.h"
#import "SpeechController.h"

@interface HelloWorldViewController : NSObject

- (id)initWithView:(IDView *)theView;

@property (strong) HelloWorldView *view;
@property (weak, readwrite) id<LastUserModeDelegate> lumDelegate;

@end
