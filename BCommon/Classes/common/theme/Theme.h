//
//  Theme.h
//  BCommon
//
//  Created by baboy on 13-8-16.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*******table view****/
#define gTableViewBgColor [UIColor colorWithWhite:1.0 alpha:1]
#define gTableViewSelectedBgColor [UIColor colorWithWhite:0.8 alpha:1]
#define gLineTopColor [UIColor colorWithWhite:0.8 alpha:1]
#define gLineBottomColor [UIColor colorWithWhite:1.0 alpha:1]

/*section*/
#define gTableSectionTitleFont  [UIFont systemFontOfSize:14]
#define gTableSectionTitleColor [UIColor colorWithWhite:0 alpha:1]
#define gTableSectionBgColor    [UIColor colorWithWhite:0.75 alpha:1]

// in theme config file
//导航栏
#define gNavBarTitleColor          [Theme colorForKey:@"navigationbar-title-color"]
#define gNavBarTitleFont           [Theme fontForKey:@"navigationbar-title-font"]
#define gNavBarTitleShadowColor          [Theme colorForKey:@"navigationbar-title-shadow-color"]
#define gNavBarBackgroundImage  [Theme imageForKey:@"navigationbar-background"]
#define ThemeViewBackgroundColor    [Theme colorForKey:@"view-background-color"]

// table
#define gTableCellTitleFont     [Theme fontForKey:@"table-cell-title-font"]
#define gTableCellTitleColor    [Theme colorForKey:@"table-cell-title-color"]

#define gTableCellDescFont     [Theme fontForKey:@"table-cell-desc-font"]
#define gTableCellDescColor    [Theme colorForKey:@"table-cell-desc-color"]


#define gTableCellContentFont     [Theme fontForKey:@"table-cell-content-font"]
#define gTableCellContentColor    [Theme colorForKey:@"table-cell-content-color"]

#define gTableCellTagFont     [UIFont systemFontOfSize:12]
#define gTableCellNoteFont     [UIFont systemFontOfSize:12]
#define gTableCellTagColor    [UIColor colorWithWhite:0.4 alpha:1]



#define gButtonTitleFont            [Theme fontForKey:@"button-title-font"]
#define gButtonTitleColor           [Theme colorForKey:@"button-title-color"]
#define gButtonTitleShadowColor     [UIColor colorWithWhite:0 alpha:0.5]


#define gNavBarBackButton       [Theme navBarButtonForKey:@"navigationbar-back-button"]

#define gPlayerPlayButton       [Theme buttonForKey:@"icon-play"]


#define gThumbnailColor         [UIColor colorWithWhite:1.0 alpha:1]

#define gNoteFont               [UIFont systemFontOfSize:12.0]
#define gNoteColor              [UIColor colorWithWhite:0.3 alpha:1]
#define gTagFont               [UIFont systemFontOfSize:12.0]
#define gTagColor               [UIColor colorWithWhite:0.5 alpha:1]
#define gTitleColor             [UIColor colorWithWhite:0 alpha:1]
#define gTitleFont              [UIFont boldSystemFontOfSize:16.0]
#define gBigTitleFont              [UIFont boldSystemFontOfSize:18.0]
#define gDescFont               [UIFont systemFontOfSize:14.0]
#define gDescColor              [UIColor colorWithWhite:0.3 alpha:1]
#define gTitleShadowColor       [UIColor colorWithWhite:1 alpha:0.9]
#define gShadowColor            [UIColor colorWithWhite:0.1 alpha:0.6]

/*******按钮圆形图片*******/
#define gButtonCircleBgGradColor1    [UIColor colorWithWhite:0.8 alpha:1]
#define gButtonCircleBgGradColor2    [UIColor colorWithWhite:0.96 alpha:1]
#define gButtonCircleBgGradColor3    [UIColor colorWithWhite:0.98 alpha:1]
#define gButtonCircleBgGradColor4    [UIColor colorWithWhite:0.8 alpha:1]
#define gButtonCircleBgImageColor    [UIColor colorWithWhite:0.7 alpha:1]
/***mv小窗口**/
#define gMVWindowWidth               240
#define gMVWindowHeight              180
/***歌词***/

#define gLyricFont                  [UIFont systemFontOfSize:14]
#define gLyricColor                 [UIColor colorWithWhite:1 alpha:0.8]
#define gLyricHighlightColor        [UIColor colorWithWhite:1 alpha:0.8]
#define gLyricShadowColor           [UIColor colorWithWhite:0 alpha:0.8]
#define gLyricShadowHighlightColor  [UIColor redColor]
#define gLyricColorHightlight       [UIColor redColor]

#define gWidgetShadowColor      [UIColor colorWithWhite:0 alpha:0.8]
#define gWidgetBgColor          [UIColor colorWithWhite:0 alpha:0.5]
#define gWidgetTextColor          [UIColor colorWithWhite:1 alpha:0.5]
#define gWidgetTextShadowColor     [UIColor colorWithWhite:0 alpha:0.5]
#define gWidgetBorderColor      [UIColor colorWithWhite:1 alpha:0.5]
#define gWidgetCornerRad        6.0

#define defNavBgColor           [UIColor colorFromString:@"#1ba1e2"]

#define ThemeNavBarItemTitleColor [Theme colorForKey:@"navigationbar-item-title-color"]
#define ThemeSingleLineColor [Theme colorForKey:@"single-line-color"]
#define ThemeTabBarSelectTitleColor [Theme colorForKey:@"tabbar-select-title-color"]
#define ThemeTabBarUnSelectTitleColor [Theme colorForKey:@"tabbar-unselect-title-color"]
#define ThemeTabBarBackground [Theme imageForKey:@"tabbar-background"]
#define ThemeTabBarSelectedBackground [Theme imageForKey:@"tabbar-background-selected"]
#define ThemeSectionViewBackground [Theme imageForKey:@"table-section-background"]
#define ThemeSectionViewTitleColor [Theme colorForKey:@"table-section-title-color"]
@interface Theme : NSObject
+ (void)setup:(NSString *)theme;
+ (UIColor *) colorForKey:(NSString *)key;
+ (UIFont *)  fontForKey:(NSString *)key;
+ (UIImage *) imageForKey:(NSString *)key;
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key;
+ (UIBarButtonItem *) navBarButtonForKey:(NSString *)key withTarget:(id)target action:(SEL)action;
+ (UIButton *) buttonForKey:(NSString *)key;
+ (UIButton *) buttonForKey:(NSString *)key withTarget:(id)target action:(SEL)action;
+ (UIButton *) buttonWithTitle:(NSString *)title background:(NSString *)imageName  target:(id)target action:(SEL)action;

+ (UILabel *) labelForStyle:(NSString *)style;

+ (UIButton *) buttonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
+ (UIBarButtonItem *) navButtonForStyle:(NSString *)style withTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
@end
