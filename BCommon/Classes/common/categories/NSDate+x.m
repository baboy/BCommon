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
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setTimeStyle:NSDateFormatterLongStyle];
    [df setDateFormat:@"ccc"];
    return [df stringFromDate:self];
}
- (NSString *)format:(NSString *)f{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	NSLocale *loc = [NSLocale currentLocale];
	[df setLocale:loc];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterLongStyle];
	[df setDateFormat:f];
	
	NSString *s = [df stringFromDate:self];
	[df release];
	return s;
}
@end
