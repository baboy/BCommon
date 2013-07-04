//
//  Utils.m
//  iLook
//
//  Created by Zhang Yinghui on 5/25/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "Utils.h"

#define WEB_CACHE_DIR		@"web_cache"
#define WEB_TMP_DIR		@"web_tmp"
#define DOMAIN_DIRS		NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
#define DAYSEC			24*60*60
#define PH_REGEXP		@"\\{([^\\{\\}]+)\\}"

NSString * getImageCacheDir(){
    NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:gImageCacheDir];
	if(![fileManager fileExistsAtPath:dir]){
		if(![fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil]){
			return nil;
		}
	}
    return dir;
}
NSString * getBundleFile(NSString *fn){
	NSString *fp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fn];
	return [[NSFileManager defaultManager] fileExistsAtPath:fp]?fp:nil;
}
NSString * getBundleFileFromBundle(NSString *fn, NSString *fileType,NSString *bundleName, NSString *inDir){
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
	NSString *fp = [bundle pathForResource:fn ofType:fileType inDirectory:inDir];
	return fp;//[[NSFileManager defaultManager] fileExistsAtPath:fp]?fp:nil;
}

NSString * getFilePath(NSString *fn, NSString *ext, NSString *dir){
    NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSString *d = dir?[documentsDirectory stringByAppendingPathComponent:dir]:documentsDirectory;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:d]){
		if(![fileManager createDirectoryAtPath:d withIntermediateDirectories:NO attributes:nil error:nil]){
			return nil;
		}
	}
	
	NSString *fp = [d stringByAppendingPathComponent:fn];
	if (ext && ![ext isEqualToString:@""]) {
		fp = [fp stringByAppendingPathExtension:ext];
	}
	return fp;
}
NSString * getTempFilePath(NSString *fn){
    NSString *fp = fn;
    if ([fn rangeOfString:@"/"].length == 0) {
        fp = getFilePath(fn, @"tmp", nil);
    }else{
        fp = [fn stringByAppendingPathExtension:@"tmp"];
    }
    return fp;
}
id nullToNil(id obj){
	return (NSNull *)obj == [NSNull null]?nil:obj;
}
id nilToNull(id obj){
	return obj == nil?[NSNull null]:obj;
}
BOOL strIsNil(NSString *s){
	NSString *_s = nullToNil(s);
	return (!_s || [_s isEqual:@""])?YES:NO;
}

BOOL isURL(NSString *s){
	if (s && [[s lowercaseString] hasPrefix:@"http://"]) {
		return YES;
	}
	return NO;
}
NSString * getChineseCalendar(NSDate * date){      
    if(!date)return nil;
    NSArray *chineseYears = [NSArray arrayWithObjects:  
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",  
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",  
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",  
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",  
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",  
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];  
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:  
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",   
                            @"九月", @"十月", @"冬月", @"腊月", nil];  
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:  
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",   
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",  
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];  
    
    
    NSCalendar *localCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];  
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;  
    
    NSDateComponents *localeComp = [localCal components:unitFlags fromDate:date];  
     
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];  
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];  
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];  
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年 %@%@",y_str,m_str,d_str];  
    
    [localCal release];  
    
    return chineseCal_str;  
}  
@implementation Utils
+ (NSString *)getFilePath:(NSString *)fn{
	NSString *documentDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSString *fp = [documentDirectory stringByAppendingPathComponent:fn];
	return fp;
}
+ (NSString *)getFilePath:(NSString *)fn inDir:(NSString *)dir{
	return [Utils getFilePath:fn ext:nil inDir:dir];
}
+ (NSString *)	getFilePath:(NSString *)fn ext:(NSString *)ext inDir:(NSString *)dir{
	NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSString *d = [documentsDirectory stringByAppendingPathComponent:dir];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:d]){
		if(![fileManager createDirectoryAtPath:d withIntermediateDirectories:NO attributes:nil error:nil]){
			return nil;
		}
	}
	
	NSString *fp = [d stringByAppendingPathComponent:fn];
	if (ext) {
		fp = [fp stringByAppendingPathExtension:ext];
	}
	return fp;
}
+ (BOOL) createNewFileAtPath:(NSString *)fn{	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:fn]) {
		if ([fileManager removeItemAtPath:fn error:nil]) {
			return NO;
		};
	}
	return [fileManager createFileAtPath:fn contents:nil attributes:nil];
}
+ (BOOL) createFileIfNotExist:(NSString *)fn{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:fn]) {
		return [fileManager createFileAtPath:fn contents:nil attributes:nil];
	}
	return YES;
}
+ (long long) sizeOfFile:(NSString *)fn{
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSDictionary *attrs = [fileManager attributesOfItemAtPath:fn error: NULL]; 
	return [attrs fileSize]; 
}
+ (BOOL) moveFile:(NSString *)srcPath toFile:(NSString *)dstPath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager moveItemAtPath:srcPath toPath:dstPath error:nil];
}
+ (NSString *)format:(NSString *)f time:(long long )t{
	if ( [[NSString stringWithFormat:@"%qi",t] length] > 10 ) {
		t /= 1000;
	}
    if (t<99999999) {
        NSTimeInterval tmp = [[NSDate date] timeIntervalSince1970];
        t += [Utils getStartTimestampOfDay:tmp];
    }
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	NSLocale *loc = [NSLocale currentLocale];
	[df setLocale:loc];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterLongStyle];
	[df setDateFormat:f];
	
	NSString *s = [df stringFromDate:date];
	[df release];
	return s;
}
+ (NSString *) formatSize:(long long)size{
	
	NSMutableString *s = [NSMutableString stringWithCapacity:5];
	long long g = 1024*1024*1024,m = 1024*1024,k = 1024,sg;
	float sm;
	if (size>g) {
		sg = size/g;
		size -= sg*g;
		[s appendFormat:@"%lldG",sg];
	}
	if (size>=m*0.1) {
		sm = (float)size/m;
		[s appendFormat:@"%@ %.2fM",s,sm];
	}
	if ([s length]==0 && size>=k) {
		[s appendFormat:@"%.2fK",((float)size/k)];
	}
	if ([s length]==0) {		
		[s appendFormat:@"%lldB",size];
	}
	return [s description] ;
}
+ (NSString *)formatToTime:(NSInteger)t{
	int d = t/3600/24;
	t -= d*3600*24;
	int h = t/3600;
	t -= h*3600;
	int m = t/60;
	t -= m*60;
	int s = t;
	NSMutableString *str = [NSMutableString stringWithCapacity:5];
	if (d) [str appendFormat:@"%d天",d];
	if (h) [str appendFormat:@"%d时",h];
	if (m) [str appendFormat:@"%d分",m];
	if (s) [str appendFormat:@"%d秒",s];
	return str;
}
+ (NSData *) getWebCache:(NSString *)key{	
	NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:WEB_CACHE_DIR];
	NSString *file = [dir stringByAppendingPathComponent:key];
	if ([fileManager fileExistsAtPath:file]) {
		NSData *cahcheData = [fileManager contentsAtPath:file];
		return cahcheData;
	}
	return nil;
}
+ (NSString *) getCacheFile:(NSString *)key{
	//NSLog(@"util getCacheFile:%@",key);
	NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:WEB_CACHE_DIR];
	NSString *file = [dir stringByAppendingPathComponent:key];
	if ([fileManager fileExistsAtPath:file]) {
		return file;
	}
	return nil;
}
+ (BOOL) removeCacheFile:(NSString *)key{
	//NSLog(@"util getCacheFile:%@",key);	
	NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:WEB_CACHE_DIR];
	NSString *file = [dir stringByAppendingPathComponent:key];
	if ([fileManager fileExistsAtPath:file]) {
		return [fileManager removeItemAtPath:nil error:nil];
	}
	return NO;
}
+ (NSString *) saveWebCache:(NSString *)key data:(NSData *)cacheData{	
	NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:WEB_CACHE_DIR];
	if(![fileManager fileExistsAtPath:dir]){
		if(![fileManager createDirectoryAtPath:dir attributes:nil]){
			return nil;
		}
	}
	NSString *file = [dir stringByAppendingPathComponent:key];
	if([fileManager fileExistsAtPath:file]){
		NSError *err;
		if (![fileManager removeItemAtPath:file error:&err]) {
			return nil;
		}
	}
	return [fileManager createFileAtPath:file contents:cacheData attributes:nil]?file:nil;
}
+ (NSString *) removeHTMLTag:(NSString *)html{
	NSString *s = [html stringByReplacingOccurrencesOfRegex:@"<[^>]+>" withString:@""];
	s = [s stringByReplacingOccurrencesOfRegex:@"&nbsp;?" withString:@""];
	s = [s stringByReplacingOccurrencesOfRegex:@"[\n\r]+[\t\r \n]*" withString:@"\n"];
	return s;
}

+ (NSString *)	serializeNetParams:(NSDictionary *)dict{
	if (!dict) {
		return nil;
	}
	NSMutableString *s = [NSMutableString stringWithCapacity:10];
	NSArray *keys = [dict allKeys];
	int n = [keys count];
	NSString *sep = @"&";
	for (int i=0; i<n; i++) {
		NSString *k = [keys objectAtIndex:i];
		id v = [dict valueForKey:k];
		if (i>0)
			[s appendString:sep];
		if ([v isKindOfClass:[NSArray class]]) {
			int n2 = [v count];
			for (int j=0; j<n2; j++) {				
				if (j>0)
					[s appendString:sep];
				if ((NSNull *)v != [NSNull null]) {
					[s appendFormat:@"%@=%@",k,[[v objectAtIndex:j] description]];
				}else {
					[s appendString:k];
				}
			}
		}else {
			if ((NSNull *)v != [NSNull null]) {
				[s appendFormat:@"%@=%@",k,[v description]];
			}else {
				[s appendString:k];
			}

		}		
	}
	return s;	
}

+ (NSString *)	serializeURL:(NSString *)url params:(NSDictionary *)param{
	if (param) {
		NSString *p = [Utils serializeNetParams:param];
		if (p && [p length]>0) {
			url = [NSString stringWithFormat:([url indexOf:@"?"]>=0?@"%@&%@":@"%@?%@"),url,p];
			//url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
	}
	return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)	getChineseWeek:(int)n{
	if ( n>7 || n<0 ) {
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setLocale:[NSLocale currentLocale]];
		[df setDateStyle:NSDateFormatterLongStyle];
		[df setTimeStyle:NSDateFormatterLongStyle];
		[df setDateFormat:@"ccc"];
		
		return [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:n]];
	}
	
	NSString *s = nil;
	switch (n) {
		case 1:
			s = @"星期一";
			break;
		case 2:
			s = @"星期二";
			break;
		case 3:
			s = @"星期三";
			break;
		case 4:
			s = @"星期四";
			break;
		case 5:
			s = @"星期五";
			break;
		case 6:
			s = @"星期六";
			break;
		case 0:
		case 7:
			s = @"星期日";
			break;
		default:
			s = [NSString stringWithFormat:@"%d",n];
			break;
	}
	return s;
}
+ (NSInteger)getStartTimestampOfDay:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	[comp setHour:0];
	[comp setMinute:0];
	[comp setSecond:0];
	NSDate *date = [cal dateFromComponents:comp];  
	[cal release];
	return [date timeIntervalSince1970];
}
+ (NSInteger)getEndTimestampOfDay:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	[comp setHour:23];
	[comp setMinute:59];
	[comp setSecond:59];
	NSDate *date = [cal dateFromComponents:comp];  
	[cal release];
	return [date timeIntervalSince1970];
}
+ (NSInteger)	getEndTimestampOfHour:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	int h = [comp hour];
	[comp setHour:h+1];
	[comp setMinute:0];
	[comp setSecond:0];
	NSDate *date = [cal dateFromComponents:comp];  
	[cal release];
	return [date timeIntervalSince1970];
}
+ (NSDictionary *) parseURL:(NSString *)url withParam:(NSDictionary *)param{
	NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:3];
	[ret setValue:url forKey:URLParseKeyString];
	NSString *path = url;
	
	int i = [url indexOf:@"?"];
	if ( i>0 && i<[url length] ) {
		path = [url substringToIndex:i];
		NSMutableDictionary *params = [NSMutableDictionary dictionary];
		NSString *query = [url substringFromIndex:(i+1)];
		int k = [query indexOf:@"#"];
		//NSLog(@"k:%@,%d",query,k);
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
		path = [path substringToIndex:i];
	}
	[ret setValue:page forKey:URLParseKeyPage];
	[ret setValue:path forKey:URLParseKeyPath];
	[ret setValue:[NSString stringWithFormat:@"%@/%@",path,page] forKey:URLParseKeyUrl];
	return ret;
	
}
+ (NSString *)	url:(NSString *)url withParam:(NSDictionary *)param{
	NSMutableDictionary *phParam = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *newUrl = url;
	if (param) {
		NSArray *arr = [Utils parsePlaceholders:url];
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
	
	NSDictionary *d = [Utils parseURL:newUrl withParam:nil];
	NSString *path = [d valueForKey:URLParseKeyPath];
	NSString *page = [d valueForKey:URLParseKeyPage];
	newUrl = [page length]>0?[NSString stringWithFormat:@"%@/%@",path,page]:path;
	NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:[d valueForKey:URLParseKeyParam]];
	for (NSString *k in [phParam allKeys]) {
		[p setValue:[phParam valueForKey:k] forKey:k];
	}
	return [Utils serializeURL:newUrl params:p];
}
+ (NSArray *)	parsePlaceholders:(NSString *)url{
	NSArray *_arr = [url arrayOfCaptureComponentsMatchedByRegex:PH_REGEXP];
	NSMutableArray *_list = nil;
	if ([_arr count]>0) {
		_list = [NSMutableArray arrayWithCapacity:[_arr count]];
		for (NSArray *_a in _arr) {
			if ([_a  count] == 2) {
				[_list addObject:[_a objectAtIndex:1]];
			}
		}
	}
	return _list;
}
+ (NSString *) url:(NSString *)url replaceholders:(NSDictionary *)param{
	NSString *_newURL = url;
	NSArray *_arr = [Utils parsePlaceholders:url];
	for (NSString *ph in _arr) {
		NSString *v = nullToNil( [param valueForKey:ph] );
		_newURL = [_newURL stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%@}",ph] withString:(v?[v description]:@"")];
	}
	return _newURL;
}

@end
