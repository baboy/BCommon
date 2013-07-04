//
//  XNSString.h
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString(x) 
- (NSString *) md5;
- (NSInteger) lastIndexOf:(NSString *)sep;
- (NSInteger) indexOf:(NSString *)sep;
- (NSArray *) split:(NSString *)sep;
- (NSString *) placeHolder:(NSString *)ph withString:(NSString *) s;
- (NSDate *)dateWithFormat:(NSString *)format;
- (int)compareToVersion:(NSString *)version;
- (BOOL)isURL;
- (NSString *)pinyin;
- (BOOL)isEmail;
- (BOOL)renameToPath:(NSString *)newPath;
- (BOOL)deleteFile;
- (long long)sizeOfFile;
- (id)json;
- (NSString *)base64SHA1HmacWithKey:(NSString *)key;
- (NSError *)removeFile;
- (int)textCount;
@end
