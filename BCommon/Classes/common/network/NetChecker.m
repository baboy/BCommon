//
//  NetChecker.m
//  ITvie
//
//  Created by Zhang Yinghui on 11-3-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetChecker.h"
#import "Reachability.h"

@implementation NetChecker
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
@end
