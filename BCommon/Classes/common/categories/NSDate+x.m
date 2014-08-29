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
- (NSString *)formatToHumanLang{
    int t = (int)[[NSDate date] timeIntervalSinceDate:self];
    t = MAX(t, 0);
    if (t < 10) {
        return NSLocalizedString(@"刚刚", nil);
    }
    if (t < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d秒前", nil), t];
    }
    if (t < HourSec) {
        t = t/60;
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", nil), t];
    }
    if (t < DaySec) {
        t = t/HourSec;
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", nil), t];
    }
    if (t < (DaySec * 7)) {
        t = t/DaySec;
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", nil), t];
    }
    if ([[self format:@"yyyy"] isEqualToString:[[NSDate date] format:@"yyyy"]]) {
        return [self format:NSLocalizedString(@"MM-dd HH:mm", nil)];
    }
    return [self format:NSLocalizedString(@"yyyy-MM-dd HH:mm", nil)];
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
