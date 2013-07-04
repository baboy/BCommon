//
//  BImageView.m
//  iLook
//
//  Created by Zhang Yinghui on 7/10/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "BImageView.h"

#define BImgViewTitleFont			[UIFont boldSystemFontOfSize:12]
#define BImgViewTitleColor			[UIColor whiteColor]
#define BImgViewTitleShadowColor	[UIColor blackColor]


@interface BImageView()
@property(nonatomic, retain) BHttpRequestOperation *operation;
- (void) loadImage;
- (void) handleTap:(UIGestureRecognizer *)recognizer;
- (void) createSubviews;
@end

@implementation BImageView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
        [self createSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageURL:(NSString *)url{	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
        [self createSubviews];
		[self setImageURL:url];
    }
    return self;
}
- (void) createSubviews{
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imgView.clipsToBounds = YES;
    [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_imgView];
    
    _titleLabel = [createLabel(CGRectZero, BImgViewTitleFont, [UIColor clearColor], BImgViewTitleColor, BImgViewTitleShadowColor, CGSizeMake(0, 1), UITextAlignmentCenter, 1, UILineBreakModeTailTruncation) retain];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_titleLabel];
    
    CGRect rect = CGRectMake(0, self.bounds.size.height-12, self.bounds.size.width, 12);
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setFrame:CGRectInset(rect, 5, 0)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_progressView setHidden:YES];
    [self addSubview:_progressView];
}
- (void)setFrame:(CGRect)frame{
	if (CGRectEqualToRect(frame, self.frame)) {
		return;
	}
	[super setFrame:frame];
    [self setNeedsLayout];
}
- (void)setTitleStyle:(BImageTitleStyle)titleStyle{
    _titleStyle = titleStyle;
    [self setNeedsLayout];
}
- (void) setPadding:(float)padding{
	_padding = padding;	
    [self setNeedsLayout];
}
- (void) addTarget:(id)target action:(SEL)action{
	if (target && action) {		
		_target = target;
		_action = action;
		UITapGestureRecognizer *tap = AUTORELEASE([[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)]);
		[self addGestureRecognizer:tap];
	}
}
- (void) handleTap:(UIGestureRecognizer *)recognizer{
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		if (_target && _action) {
			[_target performSelector:_action withObject:self afterDelay:0];
		}
	}
}
- (void) setImageLocalPath:(NSString *)fp{
	[_imageLocalPath release];
	_imageLocalPath = [fp retain];
	[_imgView setImage:[UIImage imageWithContentsOfFile:fp]];
}
- (void) setImageURL:(NSString *)imgUrl{
    imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ( !_imageURL && [_imageURL isEqualToString:imgUrl] ) {
		return;
	}
	if (![imgUrl isURL]) {
		[self setImageLocalPath:imgUrl];
		return;
	}
	[_imageURL release];
	_imageURL = [imgUrl retain];
	[self loadImage];
	
}
- (void) loadImage{
    BHttpClient *client = [BHttpClient defaultClient];
    NSURLRequest *request = [client requestWithGetURL:[NSURL URLWithString:self.imageURL] parameters:nil];
    BHttpRequestOperation *operation = [client dataRequestWithURLRequest:request
                                                                 success:^(BHttpRequestOperation *operation, id data) {
                                                                     if (self && [self isKindOfClass:[UIImageView class]]) {
                                                                         NSString *fp = operation.cacheFilePath;
                                                                         [self setImageLocalPath:fp];
                                                                         self.operation = nil;
                                                                     }
                                                                 }
                                                                 failure:^(BHttpRequestOperation *request, NSError *error) {
                                                                     
                                                                 }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        _progressView.progress = ((float)totalBytesRead/totalBytesExpectedToRead);
    }];
    [operation setRequestCache:[BHttpRequestCache fileCache]];
    self.operation = operation;
    [operation start];
}
- (void) showProgress:(BOOL)showProgress{
    [_progressView setHidden:!showProgress];
}
- (void)setRadius:(float)rad{
    [self.layer setCornerRadius:rad];
    [_imgView.layer setCornerRadius:rad];
}
- (void) layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    if (_titleStyle == BImageTitleStyleBelow) {
        rect.size.height -= 20;
    }
    [_imgView setFrame:CGRectInset(rect, _padding, _padding)];
    rect = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    [_titleLabel setFrame:rect];
    rect.origin.y += rect.size.height-32;;
    rect.size.height=12;
    [_progressView setFrame:CGRectInset(rect, 3, 0)];
}
- (void)dealloc {
    if (self.operation) {
        [self.operation cancel];
    }
    [_operation release];
	[_object release];
	[_imageURL release];
	[_imageLocalPath release];
    [_imgView release];
    [_progressView release];
    [super dealloc];
}


@end
