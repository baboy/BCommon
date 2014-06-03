//
//  Api.h
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//


//用户相关
extern NSString *ApiDomain;

#define ApiRequestBatchNum      20




/********* Api Interface *************/

//检查版本更新
#define ApiQueryAppVersion          [BApi apiForKey:@"check_app_version"]
//反馈相关
#define ApiPostFeedback             [BApi apiForKey:@"feedback"]
//检索应用市场
#define ApiQueryAppList             [BApi apiForKey:@"query_appmarket"]
#define ApiStorageUpload            [BApi apiForKey:@"storage_upload"]
//获取关于
#define ApiQueryAbout               [BApi apiForKey:@"about"]

#define ApiRegister                  [BApi apiForKey:@"register"]
#define ApiLogin                     [BApi apiForKey:@"login"]
#define ApiLoginWithOpenID           [BApi apiForKey:@"login_openid"]
//获取频道列表
#define ApiQueryTVChannels          [BApi apiForKey:@"query_channels"]
//直播搜索
#define ApiTVSearch         [BApi apiForKey:@"search_epgs"]
//正在热播
#define ApiHotTVChannels    [BApi apiForKey:@"query_hot_channels"]
//播放源
#define ApiLiveSources    [BApi apiForKey:@"query_channel_source"]

//查询评论列表
#define ApiQueryComments           [BApi apiForKey:@"query_comments"]
//发送评论
#define ApiPostComment            [BApi apiForKey:@"post_comment"]

//地图
#define ApiQueryLocation            [BApi apiForKey:@"search_location"]

// weather
#define ApiWeatherQuery             [BApi apiForKey:@"query_weather"]

//news
#define ApiNewsQuery                [BApi apiForKey:@"query_news"]
#define ApiNewsType                 [BApi apiForKey:@"query_news_type"]


@interface BApi : NSObject
+ (void)setup:(NSString *)plist;
+ (NSString *)apiForKey:(NSString *)key;
@end

