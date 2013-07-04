//
//  NSDate+x.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FULLDATEFORMAT_ZONE  @"yyyy-MM-dd HH:mm:ss Z"
#define FULLDATEFORMAT      @"yyyy-MM-dd HH:mm:ss"

@interface NSDate(x)

- (NSString *)weekName;
- (NSString *)format:(NSString *)f;
- (NSString *)GMTFormat;
@end
