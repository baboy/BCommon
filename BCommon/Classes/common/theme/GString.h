//
//  GString.h
//  iLookForiPhone
//
//  Created by hz on 12-11-1.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ConnectionFailedMsg    NSLocalizedString(@"Network connection failed!",nil)
#define ShareVodContentFormat    [GString stringForKey:@"share-vod-content-format"]
#define ShareLiveContentFormat   [GString stringForKey:@"share-live-content-format"]
#define ShareRadioContentFormat  [GString stringForKey:@"share-radio-content-format"]

@interface GString : NSString
+ (void)setup:(NSString *)string;
+ (NSString *)stringForKey:(id) key;
@end
