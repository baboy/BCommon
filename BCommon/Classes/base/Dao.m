//
//  Dao.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/4/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "Dao.h"

//#define dbFile			@"db.sqlite"
//#define sqlFile			@"sql.plist"

static  FMDatabase *__db__ = nil;
@implementation Dao
+ (FMDatabase*)db{  
    if (!__db__  || ![__db__ open]) {
        RELEASE(__db__);
        __db__ = [[FMDatabase databaseWithPath:getTempFilePath(@"db.sqlite")] retain] ;
        [__db__ open];
    }
	return __db__;
}
+ (BOOL) executeSql:(NSString *)sql params:(NSArray *)params{
    BOOL ret = NO;
    ret = [self.db executeUpdate:sql withArgumentsInArray:params];
    if (!ret) {
        NSString *errMsg = [self.db lastErrorMessage];
        NSLog(@"errMsg:%@",errMsg);
    }
	return ret;
}
+ (BOOL)setup{    
    NSLog(@"dbFile:%@", getTempFilePath(@"db.sqlite"));
    BOOL ret = NO;
    NSArray *arr = [NSArray arrayWithContentsOfFile:getBundleFile(@"sql.plist")];
    if (arr && [arr count]) {
        int n = [arr count];
        int i = 0;
        for ( NSString *sql in arr ) {
            //NSLog(@"sql:%@",sql);
            i += [self executeSql:sql params:nil]?1:0;
        }
        ret = i == n;
    }
    return ret;
}
+ (BOOL)close:(FMDatabase*)db{
    return YES;
}
@end
