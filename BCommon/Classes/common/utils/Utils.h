//
//  Utils.h
//  iLook
//
//  Created by Zhang Yinghui on 5/25/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define URLParseKeyString	@"URLParseKeyString"
#define	URLParseKeyPath		@"URLParseKeyPath"
#define URLParseKeyPage		@"URLParseKeyPage"
#define URLParseKeyParam	@"URLParseKeyParam"
#define URLParseKeyUrl		@"URLParseKeyUrl"



extern NSString * getImageCacheDir();
extern NSString * getFilePath(NSString *fn, NSString *ext, NSString *dir);
extern NSString * getBundleFile(NSString *fn);
extern NSString * getBundleFileFromBundle(NSString *fn, NSString *fileType, NSString *bundleName, NSString *inDir);
extern NSString * getTempFilePath(NSString *fn);
extern id nullToNil(id obj);
extern id nilToNull(id obj);
extern BOOL strIsNil(NSString *s);
extern BOOL isURL(NSString *s);
extern NSString * getChineseCalendar(NSDate * date);

@interface Utils : NSObject {

};
+ (NSString *)	getBundleFile:(NSString *)fn;
+ (UIImage *)	getViewShot:(UIView *)view;

+ (NSString *)getFilePath:(NSString *)fn;
+ (NSString *)getFilePath:(NSString *)fn inDir:(NSString *)dir;
+ (NSString *)	getFilePath:(NSString *)fn ext:(NSString *)ext inDir:(NSString *)dir;

+ (BOOL) moveFile:(NSString *)srcPath toFile:(NSString *)dstPath;
+ (BOOL)			createNewFileAtPath:(NSString *)fn;
+ (BOOL)			createFileIfNotExist:(NSString *)fn;
+ (long long)	sizeOfFile:(NSString *)fn;
+ (NSString *)	format:(NSString *)f time:(long long )t;
+ (NSString *) formatSize:(long long)size;
+ (NSString *)	formatToTime:(NSInteger)t;
+ (NSData *)	getWebCache:(NSString *)key;
+ (NSString *)	getCacheFile:(NSString *)key;
+ (NSString *)	saveWebCache:(NSString *)key data:(NSData *)cacheData;
+ (NSString *)	removeHTMLTag:(NSString *)html;
+ (NSString *)	serializeNetParams:(NSDictionary *)dict;
+ (NSString *)	serializeURL:(NSString *)url params:(NSDictionary *)dict;
+ (NSString *)	getChineseWeek:(int)n;
+ (NSInteger)	getStartTimestampOfDay:(long long)time;
+ (NSInteger)	getEndTimestampOfDay:(long long)time;
+ (NSInteger)	getEndTimestampOfHour:(long long)time;
+ (NSDictionary *) parseURL:(NSString *)url withParam:(NSDictionary *)param;
+ (NSString *)	url:(NSString *)url withParam:(NSDictionary *)param;
+ (NSArray *)	parsePlaceholders:(NSString *)url;
+ (NSString *)	url:(NSString *)url replaceholders:(NSDictionary *)param;
@end