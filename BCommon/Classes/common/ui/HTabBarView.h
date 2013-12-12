//
//  HTabBarView.h
//  itv
//
//  Created by Zhang Yinghui on 10/12/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTabBarViewDelegate;
@interface HTabBarView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign)id<HTabBarViewDelegate>delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) float itemWidth;
@property (nonatomic, assign) float itemBorderWidth;
@property (nonatomic, assign) float spacing;
@property (nonatomic, assign) float separatorWidth;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *selectedTitleColor;
@property (nonatomic, retain) UIColor *unSelectedTitleColor;
@property (nonatomic, retain) id unSelectedImage;
@property (nonatomic, retain) id selectedImage;
@property (nonatomic, retain) id unSelectedBackgroundImage;
@property (nonatomic, retain) id selectedBackgroundImage;

@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, retain) UIColor *separatorLeftColor;
@property (nonatomic, retain) UIColor *separatorRightColor;
@property (nonatomic, assign) BOOL  alignLeft;
@property (nonatomic, assign) BOOL  vPadding;
@property (nonatomic, retain) UIImage *backgroundImage;

- (void) tappedAtIndex:(int)i;
- (void) selectAtIndex:(int)i;
- (void) selectWithValue:(NSString *)v;
- (NSDictionary *)selectValue;
@end

@protocol HTabBarViewDelegate<NSObject>
- (void)tabBar:(HTabBarView *)tabBar didSelectItem:(NSDictionary *)info;
@end

@protocol HTabBarGroupViewDelegate;


@interface HTabBarGroupView : UIView
@property (nonatomic, assign)id<HTabBarGroupViewDelegate>delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) float itemWidth;
@property (nonatomic, assign) float itemBorderWidth;
@property (nonatomic, assign) float spacing;
@property (nonatomic, assign) float titleWidth;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) float separatorWidth;
@property (nonatomic, retain) UIColor *vSeparatorColor;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) UIColor *selectedTitleColor;
@property (nonatomic, retain) UIColor *unSelectedTitleColor;
@property (nonatomic, retain) id unSelectedImage;
@property (nonatomic, retain) id selectedImage;
@property (nonatomic, assign) float vPadding;
@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, retain) UIColor *separatorLeftColor;
@property (nonatomic, retain) UIColor *separatorRightColor;

- (NSDictionary *)selectValue;
@end

@protocol HTabBarGroupViewDelegate<NSObject>
- (void)tabBar:(HTabBarGroupView *)groupView didSelectItem:(NSDictionary *)info;
@end