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
@property (nonatomic, retain) UIColor *selectedTitleColor;
@property (nonatomic, retain) UIColor *unSelectedTitleColor;
@property (nonatomic, retain) UIImage *unSelectedImage;
@property (nonatomic, retain) UIImage *selectedImage;

- (void) selectAtIndex:(int)i;
- (void) selectWithValue:(NSString *)v;
@end

@protocol HTabBarViewDelegate<NSObject>
- (void)tabBar:(HTabBarView *)tabBar didSelectItem:(NSDictionary *)info;
@end