//
//  NetChecker.m
//  ITvie
//
//  Created by Zhang Yinghui on 11-3-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetChecker.h"
#import "Reachability.h"
@interface NetChecker()
@property (nonatomic, retain) Reachability *internetReach;
@property (nonatomic, retain) Reachability *wifiReach;
@end

@implementation NetChecker
- (void)dealloc{
    RELEASE(_internetReach);
    RELEASE(_wifiReach);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
+ (id)checker{
    static id _netChecker = nil;
    static dispatch_once_t initOnceNetChecker;
    dispatch_once(&initOnceNetChecker, ^{
        _netChecker = [[NetChecker alloc] init];
    });
    return _netChecker;
}
- (id)init{
    if (self = [super init]) {
        self.internetReach = [Reachability reachabilityForInternetConnection];
        [self.internetReach startNotifier];
        self.wifiReach = [Reachability reachabilityForLocalWiFi];
        [self.wifiReach startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return self;
}
- (void)networkChanged:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkChangedNotification
                                                        object:nil userInfo:nil];
}
+ (int) status{
	int _status = NotReachable;
    Reachability *_internetReach = [Reachability reachabilityForInternetConnection];
	[_internetReach startNotifier];
	_status |= [_internetReach currentReachabilityStatus];
	
    Reachability *_wifiReach = [Reachability reachabilityForLocalWiFi];
	[_wifiReach startNotifier];
	_status |= [_wifiReach currentReachabilityStatus];
	return _status;
}

+ (BOOL) isAvailable{
	return [self status] != NotReachable;
}
+ (BOOL) isConnectWifi{
    return ([self status] & ReachableViaWiFi) ? YES : NO;
}
+ (BOOL) isConnect3G{
    return ([self status] & ReachableViaWWAN) ? YES : NO;
}
@end
