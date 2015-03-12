#import "HelloWorldViewController.h"
#import "HelloWorldDataSource.h"

@implementation HelloWorldViewController

- (id)initWithView:(IDView *)view
{
    if (self = [super init])
    {
        _view = (HelloWorldView *)view;
        _view.sayHello.text = @"Click Me!";
        [_view.sayHello setTarget:self selector:@selector(clickMeSelected:) forActionEvent:IDActionEventSelect];
        [[HelloWorldDataSource sharedDataSource] addObserver:self forKeyPath:DataSourceClickCountKey options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

- (void)dealloc
{
    [[HelloWorldDataSource sharedDataSource] removeObserver:self forKeyPath:DataSourceClickCountKey];
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
            self.view.sayHello.text = [NSString stringWithFormat:@"Clicked %@ %@!", clickCount, [clickCount compare:@1] == NSOrderedSame ? @"time" : @"times"];
        });
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:DataSourceClickCountKey])
    {
        [self updateClickCount:[change valueForKey:NSKeyValueChangeNewKey]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
