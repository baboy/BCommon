//
//  BDropMenu.h
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-8-23.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDropMenuDelegate ;

@interface BDropMenuItem : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSDictionary *dict;
- (id)initWithDictionary:(NSDictionary *)dict;
@end

@interface BDropMenu : UIView
@property (nonatomic, assign) id<BDropMenuDelegate>delegate;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) float menuWidth;
@property (nonatomic, assign) float itemHeight;
@property (nonatomic, retain) UIView *anchor;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) BDropMenuItem *filterItem;
- (void)show;
- (BOOL)isShow;
- (void)hide;
- (void)toggle;
@end

@protocol BDropMenuDelegate <NSObject>
@optional
- (void)dropMenu:(BDropMenu *)dropMenu didSelectItem:(BDropMenuItem*)item;
@end