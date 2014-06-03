//
//  XNSString.m
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import "NSString+x.h"
#import "pinyin.h"
#import <CommonCrypto/CommonHMAC.h>


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
    if(self && ([[self lowercaseString] hasPrefix:@"http://"] || [[self lowercaseString] hasPrefix:@"https://"]))
        return YES;
    return NO;
}
- (NSString *)shortPinyin{
    int n = [self length];
    NSMutableString *s = [NSMutableString string];
    for (int i=0; i<n; i++) {
        [s appendFormat:@"%c", pinyin([self characterAtIndex:i])];
    }
    DLOG(@"pinyin:%@",s);
    return [s description];
}
- (BOOL)isEmail{
    return [self isMatchedByRegex:@"^[-_A-Za-z0-9]+[-_A-Za-z0-9_\\.]*@[-_A-Za-z0-9]+\\.[-_A-Za-z0-9\\.]+$"];
}
- (BOOL)testRegex:(NSString *)re{
    return [self isMatchedByRegex:re];
}
- (BOOL)renameToPath:(NSString *)newPath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
	BOOL flag = [fileManager moveItemAtPath:self toPath:newPath error:&err];
    if (!flag || err) {
        DLOG(@"error:%@",err);
    }
    return flag;
}
- (BOOL)copyToPath:(NSString *)newPath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
	BOOL flag = [fileManager copyItemAtPath:self toPath:newPath error:&err];
    if (!flag || err) {
        DLOG(@"error:%@",err);
    }
    return flag;
}
- (BOOL)deleteFile{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
	BOOL flag = [fileManager removeItemAtPath:self error:&err];
    if (err) {
        //DLOG(@"[NSString] deleteFile error:%@",err);
    }
    return flag;
}
- (long long)sizeOfFile{
    if (![self fileExists]) {
        return 0;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath:self error: NULL];
    return [attrs fileSize];
}
- (id)json{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&err];
    if (err) {
        DLOG(@"[NSString] jsonObject error:%@",err);
    }
    return json;
}
- (NSString *)base64SHA1HmacWithKey:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cMessage = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cMessage, strlen(cMessage), result);
    NSData *data = [Base64 encodeBytes:result length:CC_SHA1_DIGEST_LENGTH];
    return ([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (NSError *)removeFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:self error:&error];
        if (!success)
            return error;
    }
    return nil;
}
- (int)textCount{
    float number = 0.0;
    for (int index = 0; index<[self length]; index++)
    {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number +0.5;
        }
    }
    return  ceil(number);
}
- (BOOL)fileExists{
    return [[NSFileManager defaultManager] fileExistsAtPath:self];
}
- (NSString *)pinyin{
    NSMutableString *newStr = [NSMutableString stringWithString:self];
    CFRange range = CFRangeMake(0, newStr.length);
    CFStringTransform((CFMutableStringRef)newStr, &range, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)newStr, &range, kCFStringTransformStripCombiningMarks, NO);
    return newStr;//获取中文拼音
}
- (NSArray *) placeholders{
	NSArray *arr = [self arrayOfCaptureComponentsMatchedByRegex:@"\\{([^\\{\\}]+)\\}"];
	NSMutableArray *list = nil;
	if ([arr count]>0) {
		list = [NSMutableArray arrayWithCapacity:[arr count]];
		for (NSArray *a in arr) {
			if ([a  count] == 2) {
				[list addObject:[a objectAtIndex:1]];
			}
		}
	}
	return list;
}
- (NSString *) replaceholders:(NSDictionary *)param{
	NSArray *arr = [self placeholders];
    NSString *s = [NSString stringWithString:self];
	for (NSString *ph in arr) {
		NSString *v = nullToNil( [param valueForKey:ph] );
		s = [s stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}",ph] withString:(v?[v description]:@"")];
	}
	return s;
}
- (NSDictionary *) parseURLStringWithParam:(NSDictionary *)param{
    NSString *url = [NSString stringWithString:self];
	NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:3];
	[ret setValue:url forKey:URLParseKeyString];
	NSString *path = url;
	
	int i = [url indexOf:@"?"];
	if ( i>0 && i<[url length] ) {
		path = [url substringToIndex:i];
		NSMutableDictionary *params = [NSMutableDictionary dictionary];
		NSString *query = [url substringFromIndex:(i+1)];
		int k = [query indexOf:@"#"];
		if (k>=0) {
			query = [query substringToIndex:k];
		}
		
		NSArray *arr = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
		int n = [arr count];
		for (int j = 0; j<n; j++) {
			NSString *q = (NSString *)[arr objectAtIndex:j];
			NSArray *_a = [q split:@"="];
			if ([_a count]) {
				NSString *_k = [_a objectAtIndex:0];
				NSString *_v = [_a count]>1?[_a objectAtIndex:1]:@"";
				if (param && [_v length]>0) {
					NSArray *_arr = [_v arrayOfCaptureComponentsMatchedByRegex:PH_REGEXP];
					if (_arr && [_arr count]>0 && [[_arr objectAtIndex:0] count]==2) {
						NSString *_k2 = [[_arr objectAtIndex:0] objectAtIndex:1];
						if ([param valueForKey:_k2]) {
							_v = [param valueForKey:_k2];
						}
					}
				}
				[params setValue:_v forKey:_k];
			}
		}
		[ret setValue:params forKey:URLParseKeyParam];
	}
	i = [path indexOf:@"#"];
	if(i>=0 && i<[path length]){
		path = [path substringToIndex:i];
	}
	
	i = [path lastIndexOf:@"/"];
	NSString *page = @"";
	if ( i>6 && i<[path length] ) {
		page = [path substringFromIndex:(i+1)];
        if (page.length>0) {
            path = [path substringToIndex:i];
        }
	}
	[ret setValue:page forKey:URLParseKeyPage];
	[ret setValue:path forKey:URLParseKeyPath];
	[ret setValue:[NSString stringWithFormat:@"%@/%@",path,page] forKey:URLParseKeyUrl];
	return ret;
}
- (NSString *)	URLStringWithParam:(NSDictionary *)param{
    NSString *url = [NSString stringWithString:self];
	NSMutableDictionary *phParam = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *newUrl = url;
	if (param) {
		NSArray *arr = [url placeholders];
		if (arr) {
			for (NSString *k in arr) {
				NSString *v = [[phParam valueForKey:k] description];
				if (v) {
					[phParam removeObjectForKey:k];
				}else {
					v = @"";
				}
				newUrl = [newUrl stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}",k] withString:v];
			}
		}
	}//end if(param);
	
	NSDictionary *d = [newUrl parseURLStringWithParam:nil];
	NSString *path = [d valueForKey:URLParseKeyPath];
	NSString *page = [d valueForKey:URLParseKeyPage];
	newUrl = [page length]>0?[NSString stringWithFormat:@"%@/%@",path,page]:path;
	NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:[d valueForKey:URLParseKeyParam]];
	for (NSString *k in [phParam allKeys]) {
		[p setValue:[phParam valueForKey:k] forKey:k];
	}
    
	if (p) {
		NSString *requestString = [p serialize];
		if (requestString && [requestString length]>0) {
			newUrl = [NSString stringWithFormat:([newUrl indexOf:@"?"]>=0?@"%@&%@":@"%@?%@"),newUrl,requestString];
		}
	}
	return [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
