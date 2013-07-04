//
//  BImageView.h
//  iLook
//
//  Created by Zhang Yinghui on 7/10/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    BImageTitleStyleDefault,
    BImageTitleStyleBelow
} BImageTitleStyle;

@interface BImageView : UIView {
	NSString *		_imageLocalPath;
	id				_target;
	SEL				_action;
	float			_padding;
    UIProgressView *    _progressView;
}
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) NSObject *object;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, assign) float padding;
@property (nonatomic, assign) BImageTitleStyle titleStyle;

- (id)initWithFrame:(CGRect)frame imageURL:(NSString *)url;
- (void) addTarget:(id)target action:(SEL)action;
- (void)setRadius:(float)rad;
- (void) showProgress:(BOOL)showProgress;
@end
