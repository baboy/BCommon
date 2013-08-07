//
//  QDao.m
//  BackgroundTracker
//
//  Created by Zhang Yinghui on 12-5-3.
//  Copyright (c) 2012年 Wakefield School. All rights reserved.
//

#import "BQueue.h"

@implementation BQueueItem

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setDomain:[dict valueForKey:@"domain"]];
        
        [self setQid:[dict valueForKey:@"qid"]];
        [self setKey:[dict valueForKey:@"key"]];
        [self setID:[[dict valueForKey:@"id"] intValue]];
        [self setData:nullToNil([dict valueForKey:@"data"])];
        [self setData2:nullToNil([dict valueForKey:@"data2"])];
        [self setData3:nullToNil([dict valueForKey:@"data3"])];
        [self setData4:nullToNil([dict valueForKey:@"data4"])];
        [self setData5:nullToNil([dict valueForKey:@"data5"])];
        [self setData6:nullToNil([dict valueForKey:@"data6"])];
        [self setStatus:[nullToNil([dict valueForKey:@"status"]) intValue]];
    }
    return self;
}
- (void)dealloc{
    RELEASE(_domain);
    RELEASE(_key);
    RELEASE(_qid);
    RELEASE(_data);
    RELEASE(_data2);
    RELEASE(_data3);
    RELEASE(_data4);
    RELEASE(_data5);
    RELEASE(_data6);
    [super dealloc];
}


@end

@implementation BQueueItem(BQueueItemDeprecated)

- (int)tabId{
}
- (void) setTabId:(int)tabId{
    [self setID:tabId];
}
- (NSDictionary *)jsonData{
    return [self.data json];
}
- (NSDictionary *)jsonData2{
    return [self.data2 json];
}
- (NSDictionary *)jsonData3{
    return [self.data3 json];
}
@end

@implementation BQueue

+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withDatas:(NSString *)data, ...{
    if (!data || !qid) {
        return NO;
    }
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:5];
    va_list args;
    va_start(args, data);
    id arg;
    
    while ( (arg = va_arg(args, NSString*) ) != nil) {
        [datas addObject:arg];
        if ([datas count]>=5) {
            break;
        }
    }
    va_end(args);
    for (int i=[datas count]; i<5; i++) {
        [datas addObject:[NSNull null]];
    }
    FMDatabase *db = [self db];
	BOOL ret =[db executeUpdate:@"INSERT INTO queue (qid, key, data, data2, data3, data4, data5, data6) VALUES (?,?,?,?,?,?,?,?)",qid, key?:[NSNull null], data, [datas objectAtIndex:0], [datas objectAtIndex:1], [datas objectAtIndex:2], [datas objectAtIndex:3], [datas objectAtIndex:4]];
    DLOG(@"[BQueue] add queue<%@,%@> state<%d>", qid, key, ret);
	[self close:db];
	return ret;
}
+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withData:(NSString *)data{
    return [self addForQueue:qid withKey:key withDatas:data, nil];
}
+ (BOOL) addForQueue:(NSString *)qid withData:(NSString *)data{
    return [self addForQueue:qid withKey:nil withDatas:data, nil];
}

+ (BQueueItem *) getOneItemByQueue:(NSString *)qid{
    BQueueItem *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE qid=? LIMIT 0,1",qid];
    if ([rs next]) {
        ret = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
    }
    [self close:db];
	return ret;
}
+ (NSArray *) getAllItemsByQueue:(NSString *)qid{
    NSMutableArray *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE qid=? ORDER BY id ASC", qid];
    ret = [NSMutableArray array];
    while ([rs next]) {
        BQueueItem *qData = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
        [ret addObject:qData];
    }
	[self close:db];
	return ret;
}
+ (BOOL) removeById:(int) ID{
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    ret = [db executeUpdate:@"DELETE FROM queue WHERE id=?",[NSNumber numberWithInt:ID]];
	[self close:db];
	return ret;
}
+ (BOOL) removeByQueue:(NSString *)qid{
    
    return [self removeByField:DBQFieldQID value:qid];
}
+ (BOOL) removeByField:(NSString *)field value:(NSString *)val{
    
    BOOL ret = NO;
    FMDatabase *db = [self db];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM queue WHERE %@=?",field];
    ret = [db executeUpdate:sql,val];
	[self close:db];
	return ret;
}
+ (BOOL) updateField:(NSString *)field value:(NSString *)val forField:(NSString*)field2 value:(id)val2{
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    NSString *sql = @"UPDATE queue set %@=? WHERE %@=? ";
    sql = [NSString stringWithFormat:sql,field,field2];
    ret = [db executeUpdate:sql,val,val2];
	[self close:db];
	return ret;
}
+ (BOOL) updateField:(NSString *)field value:(NSString *)val forId:(int)ID{
    return [self updateField:field value:val forField:DBQFieldID value:[NSNumber numberWithInt:ID]];
}

@end

@implementation BQueue(BQueueDeprecated)


+ (BOOL) addDomain:(NSString *)domain queue:(NSString *)qid datas:(NSString *)data, ...{
    if (!data) {
        return NO;
    }
    domain = domain?domain:@"G";
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:5];
    va_list args;
    va_start(args, data);
    id arg;
    
    while ( (arg = va_arg(args, NSString*) ) != nil) {
        [datas addObject:arg];
        if ([datas count]>=5) {
            break;
        }
    }
    va_end(args);
    for (int i=[datas count]; i<5; i++) {
        [datas addObject:[NSNull null]];
    }
    FMDatabase *db = [self db];
	BOOL ret =[db executeUpdate:@"INSERT INTO queue (domain,qid,data,data2,data3,data4,data5,data6) VALUES (?,?,?,?,?,?,?,?)",domain,qid,data,[datas objectAtIndex:0],[datas objectAtIndex:1],[datas objectAtIndex:2],[datas objectAtIndex:3],[datas objectAtIndex:4]];
    DLOG(@"add queue state:%d",ret);
	[self close:db];
	return ret;
}
+ (BOOL) addDomain:(NSString *)domain queue:(NSString *)qid data:(NSString *)data{
    return [self addDomain:domain queue:qid datas:data,nil];
}
+ (BOOL) addQueue:(NSString *)qid data:(NSString *)data{
    return [self addDomain:@"G" queue:qid datas:data,nil];
}
+ (BQueueItem *) getOneItemByDomain:(NSString *)domain{
    BQueueItem *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE domain=? LIMIT 0,1",domain];
    if ([rs next]) {
        ret = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
    }
    [self close:db];
	return ret;
}
+ (BQueueItem *) getOneItemByDomain:(NSString *)domain queue:(NSString *)qid{
    BQueueItem *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE domain=? AND qid=? LIMIT 0,1",domain, qid];
    if ([rs next]) {
        ret = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
    }
    [self close:db];
	return ret;
}
+ (NSArray *) getAllItemsByDomain:(NSString *)domain queue:(NSString *)qid{
    if (!qid) {
        return [self getAllItemsByDomain:domain];
    }
    NSMutableArray *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE domain=? AND qid=? ORDER BY id ASC",domain,qid];
    ret = [NSMutableArray array];
    while ([rs next]) {
        BQueueItem *qData = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
        [ret addObject:qData];
    }
	[self close:db];
	return ret;
}
+ (NSArray *) getAllItemsByDomain:(NSString *)domain{
    NSMutableArray *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE domain=?",domain];
    ret = [NSMutableArray array];
    while ([rs next]) {
        BQueueItem *qData = [[[BQueueItem alloc] initWithDictionary:[rs resultDict]] autorelease];
        [ret addObject:qData];
    }
	[self close:db];
	return ret;
}

+ (NSArray *) getAllItemsByQueue:(NSString *)qid{
	return [self getAllItemsByDomain:@"G" queue:qid];
}
+ (BOOL) removeByDomain:(NSString *)domain{
    BOOL ret = NO;
    FMDatabase *db = [self db];
    ret = [db executeUpdate:@"DELETE FROM queue WHERE domain=?",domain];
	
	[self close:db];
	return ret;
}
+ (BOOL) removeByDomain:(NSString *)domain queue:(NSString *)qid{
    BOOL ret = NO;
    FMDatabase *db = [self db];
    ret = [db executeUpdate:@"DELETE FROM queue WHERE domain=? AND qid=?",domain,qid];
	
	[self close:db];
	return ret;
}
+ (BOOL) removeByQueue:(NSString *)qid{
    return [self removeByDomain:@"G" queue:qid];
}
+ (BOOL) setField:(NSString *)field value:(NSString *)val forField:(NSString*)field2 value:(id)val2{
    
    [self updateField:field value:val forField:field2 value:val2];
}
@end
