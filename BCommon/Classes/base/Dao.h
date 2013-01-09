//
//  Dao.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/4/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface Dao : NSObject
+ (FMDatabase*)db;
+ (BOOL)setup;
+ (BOOL)executeSql:(NSString *)sql params:(NSArray *)params;
+ (BOOL)close:(FMDatabase*)db;
@end
