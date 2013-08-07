//
//  TableView.h
//  itv
//
//  Created by Zhang Yinghui on 9/28/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XScrollView.h"

enum  {
	TableViewCellStyleDefault,
	TableViewCellStyleImage,
};
typedef NSInteger TableViewCellStyle;

enum{
    SeparatorLineStyleNone,
	SeparatorLineStyleTop = 1 << 0,
	SeparatorLineStyleBottom = 1 << 1
};
typedef NSInteger SeparatorLineStyle;

@interface TableViewCellBackground : UIView
@property (nonatomic, assign) SeparatorLineStyle separatorLineStyle;
@property (nonatomic, retain) UIColor *topLineColor;
@property (nonatomic, retain) UIColor *bottomLineColor;
@property (nonatomic, retain) UIImage *backgroundImage;
- (void)setTopLineColor:(UIColor *)topLineColor bottomLineColor:(UIColor *)bottomLineColor;
@end

@interface TableViewSection : TableViewCellBackground{
    UIView *_bg;
}
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *rightLabel;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *rightTitle;
@property (nonatomic, retain) UIView *rightView;
- (void)setBackgroundImage:(UIImage *)img;

@end


@interface TableCellContentView : UIView {
	CGRect				_imgRect;
	id					_cell;
}
@property (nonatomic, assign) TableViewCellStyle style;
@property (nonatomic, assign) NSInteger numOfLines;
@property (nonatomic, assign) float aspectRatio;
- (id)initWithFrame:(CGRect)frame cell:(UITableViewCell *)cell;
- (void)drawImage;
- (void)drawImageInRect:(CGRect)rect inContext:(CGContextRef)ctx withTitle:(NSString *)title;
- (void)drawLine:(NSInteger)line inRect:(CGRect)rect inContext:(CGContextRef)ctx;
- (CGRect)rectForImageInContent:(CGContextRef)ctx;
- (CGRect)rectForLine:(NSInteger)line offsetY:(float)y inContext:(CGContextRef)ctx;
@end


@class TableView;
@protocol TableViewDelegate <NSObject>
@optional
- (void)update:(TableView *)tableView;
- (void)loadMore:(TableView *)tableView;
- (void)tableView:(id)tableView didLoadedImageAtPath:(NSString *)imagePath forIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(id)tableView cacheImagePath:(NSString *)imagePath forIndexPath:(NSIndexPath *)indexPath;
@end

@interface TableView : UITableView <UIScrollViewDelegate>
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) BLineView *topLine;
@property (nonatomic, assign) BOOL useCache;
@property (nonatomic, retain) NSMutableDictionary *imgCache;

@property (nonatomic, assign, getter = isSupportLoadMore) BOOL supportLoadMore;
@property (nonatomic, assign, getter = isSupportUpdate) BOOL supportUpdate;

- (void)addFormRow:(int)fromRow toRow:(int)toRow forSection:(int)section;
- (void)updateFinished;
- (void)startUpdate;
- (void)startLoadMore;
- (void)loadImage:(NSString *)imgURL forIndexPath:(NSIndexPath *)indexPath;

- (NSString *)imageCacheForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)imageCacheForUrl:(NSString *)url;
- (void)cacheImage:(NSString *)imgLocalPath forIndexPath:(NSIndexPath *)indexPath;
@end

@interface TableViewCell : UITableViewCell{	
	UIView *_cellContentView;
	NSString *_imgLocalPath;
}
@property (nonatomic, retain) NSString *imgLocalPath;
- (void) setContentView:(UIView *)view;
@end
