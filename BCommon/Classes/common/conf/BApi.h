//
//  Api.h
//  iLookForiPhone
//
//  Created by hz on 12-10-18.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//


//用户相关
extern NSString *ApiDomain;

#define ApiClient               @"http://m.tvie.com.cn/mcms/api2/client.php"
#define ApiRequestBatchNum      20
/*
 #define ApiPathConf             @"/mcms/api2/config.php"
 //反馈相关
 #define ApiPathFeedback          @"/mcms/api2/mod/comment/?"
 //直播
 #define ApiPathLiveChannel       "/mcms/api2/mod/live/"
 */
#define ApiConf                 [NSString stringWithFormat:@"%@/config.origin.php", ApiDomain]
#define ApiMemberLogin          [NSString stringWithFormat:@"%@/mod/member/login.php", ApiDomain]
#define ApiMemberRegister       [NSString stringWithFormat:@"%@/mod/member/register.php", ApiDomain]
//直播
#define ApiLiveChannel          [NSString stringWithFormat:@"%@/mod/live/", ApiDomain]
//评论相关
#define ApiCommentPost          [NSString stringWithFormat:@"%@/mod/comment/", ApiDomain]
#define ApiCommentQuery         [NSString stringWithFormat:@"%@/mod/comment/", ApiDomain]

//微博相关
#define ApiWeiboFeeds           [NSString stringWithFormat:@"%@/mod/sns/feeds.php", ApiDomain]
#define ApiWeiboFriends         [NSString stringWithFormat:@"%@/mod/sns/friends.php", ApiDomain]
#define ApiWeiboStatus          [NSString stringWithFormat:@"%@/mod/sns/status.php", ApiDomain]
#define ApiWeiboComments        [NSString stringWithFormat:@"%@/mod/sns/comments.php", ApiDomain]

//反馈相关
#define ApiFeedback             [NSString stringWithFormat:@"%@/mod/comment/?", ApiDomain]
//关于
#define ApiAbout                [NSString stringWithFormat:@"%@/mod/about/?", ApiDomain]

//天气
#define ApiWeatherQuery         [NSString stringWithFormat:@"%@/mod/weather/", ApiDomain]

//爆料
#define ApiReportImageUploadBlock   [NSString stringWithFormat:@"%@/mod/ugc/block.php", ApiDomain]
#define ApiReportVideoUploadBlock   [NSString stringWithFormat:@"%@/mod/ugc/block.php", ApiDomain]
#define ApiReportQuery              [NSString stringWithFormat:@"%@/mod/ugc/?mod=report", ApiDomain]
#define ApiReportCategory           [NSString stringWithFormat:@"%@/mod/ugc/category.php?mod=report", ApiDomain]
#define ApiReportAddRecord          [NSString stringWithFormat:@"%@/mod/ugc/?mod=report", ApiDomain]
#define ApiReportStatis             [NSString stringWithFormat:@"%@/mod/ugc/statis.php", ApiDomain]

//点播相关
#define ApiVodCategory              [NSString stringWithFormat:@"%@/mod/vod/category.php", ApiDomain]
#define ApiVodType                  [NSString stringWithFormat:@"%@/mod/vod/category.php?type", ApiDomain]
#define ApiVodQuery                 [NSString stringWithFormat:@"%@/mod/vod/query.php", ApiDomain]
#define ApiVodQueryHot              [NSString stringWithFormat:@"%@/mod/vod/query.php?q=hot", ApiDomain]
#define ApiVodQueryRecommend        [NSString stringWithFormat:@"%@/mod/vod/query.php?q=recommend", ApiDomain]
#define ApiVodQueryRank             [NSString stringWithFormat:@"%@/mod/vod/query.php?q=rank", ApiDomain]

//新闻相关
#define ApiNewsType                 [NSString stringWithFormat:@"%@/mod/news/category.php?type", ApiDomain]
#define ApiNewsQuery                [NSString stringWithFormat:@"%@/mod/news/query.php", ApiDomain]

//地图
#define ApiQueryLocation            [NSString stringWithFormat:@"%@/mod/map/geo.php", ApiDomain]

//登记设备
#define ApiAddDevice                [NSString stringWithFormat:@"%@/mod/device/ios.php", @"http://m.tvie.com.cn/mcms/api2"]



