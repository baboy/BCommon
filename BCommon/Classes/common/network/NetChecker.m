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
+ (NSString *)access{
    return [self isConnectWifi] ? @"WIFI" :@"3G";
}
@end


#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation MacAddress

+(NSString *)currentAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}

@end
