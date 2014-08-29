//
//  Api.h
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//


//用户相关
extern NSString                            *ApiDomain;

#define ApiRequestBatchNum                 20




/********* Api Interface *************/
#define ApiSplash                     getApi(@"api_splash",nil)
#define ApiConf                     getApi(@"app_conf",nil)
//检查版本更新
#define ApiQueryAppVersion          getApi(@"check_app_version",nil)


#define ApiRegisterDeviceToken     getApi(@"register_device_token",nil)

//反馈相关
#define ApiPostFeedback             getApi(@"feedback",nil)
//检索应用市场
#define ApiQueryAppList             getApi(@"query_appmarket",nil)
#define ApiStorageUpload(param)     getApi(@"storage_upload", param)
//获取关于
#define ApiQueryAbout               getApi(@"about",nil)

#define ApiRegister                  getApi(@"register",nil)
#define ApiLogin                     getApi(@"login",nil)
#define ApiLoginWithOpenID           getApi(@"login_openid",nil)

#define ApiUpdateUserProfile         getApi(@"user_update_profile",nil)
//获取频道列表
#define ApiQueryTVChannels          getApi(@"query_channels",nil)
//直播搜索
#define ApiTVSearch         getApi(@"search_epgs",nil)
//正在热播
#define ApiHotTVChannels    getApi(@"query_hot_channels",nil)
//播放源
#define ApiLiveSources    getApi(@"query_channel_source",nil)

//查询评论列表
#define ApiQueryComments           getApi(@"query_comments",nil)
//发送评论
#define ApiPostComment            getApi(@"post_comment",nil)

//地图
#define ApiQueryLocation            getApi(@"search_location",nil)

// weather
#define ApiWeatherQuery             getApi(@"query_weather",nil)

//news
#define ApiNewsQuery getApi(@"query_news",nil)
#define ApiNewsType getApi(@"query_news_type",nil)


@interface BApi :                          NSObject
+ (void)setup:(NSString                    *)plist;
+ (NSString *)apiForKey:(NSString          *)key;
+ (NSString *)apiForKey:(NSString          *)key withParam:(NSDictionary *)param;
@end
extern NSString * getApi(NSString *key, NSDictionary *param);
