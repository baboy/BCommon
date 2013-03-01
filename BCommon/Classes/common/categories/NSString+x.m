//
//  XNSString.m
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import "NSString+x.h"
#import "pinyin.h"
#import "RegexKitLite.h"
#import "G.h"


@implementation NSString(x)
- (NSString *) md5{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];  
}


- (NSInteger) lastIndexOf:(NSString *)sep{
	NSRange r = [self rangeOfString:sep options:NSBackwardsSearch];
	return r.length>0?r.location:-1;
}
- (NSInteger) indexOf:(NSString *)sep{
	NSRange r = [self rangeOfString:sep];
	return r.length>0?r.location:-1;
}
- (NSArray *)split:(NSString *)sep{
	return [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:sep]];
}
- (NSString *) placeHolder:(NSString *)ph withString:(NSString *) s{
	return [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}",ph] withString:s];
}
- (NSDate *)dateWithFormat:(NSString *)format{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:format];
    NSDate *d =[df dateFromString:self ];
    return d;
}

- (int)compareToVersion:(NSString *)version{
    NSMutableArray *a1 = [NSMutableArray arrayWithArray:[self split:@"."]];
    NSMutableArray *a2 = [NSMutableArray arrayWithArray:[version split:@"."] ];
    NSMutableArray *a = [a2 count]>[a1 count]?a1:a2;
    for (int i = 0; i<abs([a2 count]-[a1 count]); i++) {
        [a addObject:[NSNumber numberWithInt:0]];
    }
    int n = [a1 count];
    for (int i=0; i<n; i++) {
        if([[a1 objectAtIndex:i] intValue]>[[a2 objectAtIndex:i] intValue]){
            return 1;
        }else  if([[a1 objectAtIndex:i] intValue]<[[a2 objectAtIndex:i] intValue]){
            return -1;
        }
    }
    return 0;

}
- (BOOL)isURL{
    if(self && [self hasPrefix:@"http://"])
        return YES;
    return NO;
}
- (NSString *)pinyin{
    int n = [self length];
    NSMutableString *s = [NSMutableString string];
    for (int i=0; i<n; i++) {
        [s appendFormat:@"%c", pinyin([self characterAtIndex:i])];
    }
    DLOG(@"pinyin:%@",s);
    return [s description];
}
- (BOOL)isEmail{
    return [self isMatchedByRegex:@"^[-_A-Za-z0-9]+[-A-Za-z0-9_\\.]*@[-_A-Za-z0-9]+\\.[-_A-Za-z0-9\\.]+$"];
}
- (BOOL)renameToPath:(NSString *)newPath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager moveItemAtPath:self toPath:newPath error:nil];
}
- (long long)sizeOfFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath:self error: NULL];
    return [attrs fileSize];
}
- (id)json{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"[NSString] jsonObject error:%@",err);
    }
    return json;
}
@end
