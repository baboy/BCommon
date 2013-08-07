//
//  NSArray+x.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//



@interface NSArray(x)
- (NSArray *)reverse ;
- (NSData *)jsonData;
- (NSString *)jsonString;
- (BOOL)containsStringIgnoreCase:(NSString *)string;
- (BOOL)containsStringIgnoreCase:(NSString *)string forObjectKey:(NSString *)key;
- (NSString *)join:(NSString *)sep;
- (id)json;
@end
