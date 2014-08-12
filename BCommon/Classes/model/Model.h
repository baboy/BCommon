//
//  Model.h
//  XChannel
//
//  Created by baboy on 8/5/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
- (id) initWithDictionary:(NSDictionary *)dict;
- (void)build:(NSDictionary *)data;
- (void)setValuesWithDictionary:(NSDictionary*)dict forKeys:(NSArray *)keys;
- (NSMutableDictionary *)dictForFields:(NSArray *)fields;
@end
