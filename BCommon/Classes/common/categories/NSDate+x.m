//
//  NSDate+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSDate+x.h"

@implementation NSDate(x)
- (NSString *)weekName{
    NSDateFormatter *df = AUTORELEASE([[NSDateFormatter alloc] init]);
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setTimeStyle:NSDateFormatterLongStyle];
    [df setDateFormat:@"ccc"];
    return [df stringFromDate:self];
}
- (NSString *)format:(NSString *)f{
	NSDateFormatter *df = AUTORELEASE([[NSDateFormatter alloc] init]);
	NSLocale *loc = [NSLocale currentLocale];
	[df setLocale:loc];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterLongStyle];
	[df setDateFormat:f];
	
	NSString *s = [df stringFromDate:self];
	return s;
}
- (NSString *)GMTFormat{
    NSDateFormatter *gmtFormatter = AUTORELEASE([[NSDateFormatter alloc] init]);
    [gmtFormatter setLocale:AUTORELEASE([[NSLocale alloc] initWithLocaleIdentifier:@"en_US"])];
    [gmtFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [gmtFormatter setTimeZone:tz];
    return [gmtFormatter stringFromDate:self];
}
@end
