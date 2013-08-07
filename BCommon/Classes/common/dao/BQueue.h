//
//  QDao.h
//  BackgroundTracker
//
//  Created by Zhang Yinghui on 12-5-3.
//  Copyright (c) 2012年 Wakefield School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dao.h"

#define DBQFieldID          @"id"
#define DBQFieldDomain      @"domain"
#define DBQFieldQID         @"qid"
#define DBQFieldData        @"data"
#define DBQFieldData2       @"data2"
#define DBQFieldData3       @"data3"
#define DBQFieldData4       @"data4"
#define DBQFieldData5       @"data5"
#define DBQFieldData6       @"data6"
#define DBQFieldStatus      @"status"
#define DBQFieldUpTime      @"updatetime"

@interface BQueueItem : NSObject
- (id) initWithDictionary:(NSDictionary *)dict;
@property (nonatomic, assign) int ID;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *qid;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *data2;
@property (nonatomic, retain) NSString *data3;
@property (nonatomic, retain) NSString *data4;
@property (nonatomic, retain) NSString *data5;
@property (nonatomic, retain) NSString *data6;
@property (nonatomic, assign) int status;
@end

@interface BQueue : Dao

/**
 *insert
 */
+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withDatas:(NSString *)data, ...;
+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withData:(NSString *)data;
+ (BOOL) addForQueue:(NSString *)qid withData:(NSString *)data;

+ (BQueueItem *) getOneItemByQueue:(NSString *)qid;
+ (NSArray *) getAllItemsByQueue:(NSString *)qid;
+ (BOOL) removeById:(int) ID;
+ (BOOL) removeByQueue:(NSString *)qid;
+ (BOOL) removeByField:(NSString *)field value:(NSString *)val;
+ (BOOL) setField:(NSString *)field value:(NSString *)val forField:(NSString*)field2 value:(id)val2;
@end

@interface BQueueItem(BQueueItemDeprecated)
- (int)tabId;
- (void) setTabId:(int)tabId;
- (NSDictionary *)jsonData;
- (NSDictionary *)jsonData2;
- (NSDictionary *)jsonData3;
@end

@interface BQueue (BQueueDeprecated)

+ (BOOL) addDomain:(NSString *)domain queue:(NSString *)qid datas:(NSString *)data, ...;
+ (BOOL) addDomain:(NSString *)domain queue:(NSString *)qid data:(NSString *)data;
+ (BOOL) addQueue:(NSString *)qid data:(NSString *)data;
+ (BQueueItem *) getOneItemByDomain:(NSString *)domain;
+ (BQueueItem *) getOneItemByDomain:(NSString *)domain queue:(NSString *)qid;
+ (NSArray *) getAllItemsByDomain:(NSString *)domain;
+ (NSArray *) getAllItemsByDomain:(NSString *)domain queue:(NSString *)qid;
+ (NSArray *) getAllItemsByQueue:(NSString *)qid;
+ (BOOL) removeByDomain:(NSString *)domain;
+ (BOOL) removeByDomain:(NSString *)domain queue:(NSString *)qid;
+ (BOOL) removeByQueue:(NSString *)qid;
+ (BOOL) setField:(NSString *)field value:(NSString *)val forField:(NSString*)field2 value:(id)val2;
@end
