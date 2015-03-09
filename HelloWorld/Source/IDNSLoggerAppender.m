#import "IDNSLoggerAppender.h"
#import "LoggerClient.h"

static NSString *const bonjourHostNameKeyPath = @"bonjourHostName";

@implementation IDNSLoggerAppender
{
    Logger *_nsLogger;
}

- (id)init
{
    return [self initWithBonjourHostName:nil];
}

- (id)initWithBonjourHostName:(NSString *)bonjourHostName
{
    self = [super init];

    if (self)
    {
        _maximumLogLevel = IDLogLevelAll;
        _bonjourHostName = [bonjourHostName copy];

        _nsLogger = LoggerInit();

        LoggerSetOptions(_nsLogger, kLoggerOption_BufferLogsUntilConnection | kLoggerOption_UseSSL | kLoggerOption_BrowseBonjour );

        NSString *bufferPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"LoggerBuffer.rawnsloggerdata"];
        LoggerSetBufferFile(_nsLogger, (__bridge CFStringRef)bufferPath);

        if (_bonjourHostName && [_bonjourHostName length] > 0)
        {
            LoggerSetupBonjour(_nsLogger, NULL, (__bridge CFStringRef )_bonjourHostName);
        }

        LoggerStart(_nsLogger);

        [self addObserver:self forKeyPath:bonjourHostNameKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }

    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:bonjourHostNameKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:bonjourHostNameKeyPath] && [object isEqual:self])
    {
        id oldName = [change valueForKey:NSKeyValueChangeOldKey];
        id newName = [change valueForKey:NSKeyValueChangeNewKey];

        if ([oldName isKindOfClass:[NSString class]] && [newName isKindOfClass:[NSString class]])
        {
            if (![oldName isEqualToString:newName])
            {
                [self updateLoggerBonjourSetup];
            }
        } else if (oldName != newName)
        {
            [self updateLoggerBonjourSetup];
        }
    }
}

- (void)updateLoggerBonjourSetup
{
    LoggerStop(_nsLogger);
    if (self.bonjourHostName && [self.bonjourHostName length] > 0)
    {
        LoggerSetupBonjour(_nsLogger, NULL, (__bridge CFStringRef )self.bonjourHostName);
    }
    else
    {
        LoggerSetupBonjour(_nsLogger, NULL, NULL);
    }

    LoggerStart(_nsLogger);
}

- (void)appendLoggerEvent:(IDLoggerEvent *)event
{
    if (event.level > self.maximumLogLevel) { return; }

    int logLevel = 5;
    switch (event.level) {
        case IDLogLevelError:
            logLevel = 0;
            break;
        case IDLogLevelWarn:
            logLevel = 1;
            break;
        case IDLogLevelInfo:
            logLevel = 2;
            break;
        case IDLogLevelDebug:
            logLevel = 3;
            break;
        case IDLogLevelTrace:
            logLevel = 4;
            break;
        case IDLogLevelNone:
            return;
        default:
            logLevel = 5;
            break;
    }

    LogMessageTo(_nsLogger, event.tag, logLevel, @"%@", event.message);
}

@end
