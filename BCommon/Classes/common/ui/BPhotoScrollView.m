//
//  BPhotoScrollView.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-3.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BPhotoScrollView.h"

@interface BPhotoScrollView()<UIScrollViewDelegate>
@property (nonatomic, retain)UIView *container;
@property (nonatomic, retain) XUIImageView *fullScreenImgView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIView *bottomView;
- (void)relayoutImageView:(UIImageView*)imgView withImage:(UIImage *)image;
@end

@implementation BPhotoScrollView
@synthesize imgView = _imgView;
@synthesize container = _container;
@synthesize thumbnail = _thumbnail;
@synthesize smallPic = _smallPic;
@synthesize bigPic = _bigPic;
@synthesize fullScreenImgView = _fullScreenImgView;
@synthesize canShowFullScreen;
@synthesize autoRemove = _autoRemove;
@synthesize title = _title;
@synthesize indicator = _indicator;
@synthesize bottomView = _bottomView;
- (void)dealloc{
    [self.imgView setDelegate:nil];
    [self.fullScreenImgView setDelegate:nil];
    RELEASE(_imgView);
    RELEASE(_container);
    RELEASE(_thumbnail);
    RELEASE(_bigPic);
    RELEASE(_smallPic);
    RELEASE(_fullScreenImgView);
    RELEASE(_indicator);
    RELEASE(_bottomView);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgView = [[XUIImageView alloc] initWithFrame:self.bounds];
        [_imgView setClipsToBounds:YES];
        [_imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imgView];
        [self addTarget:self action:@selector(viewFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        self.canShowFullScreen = YES;
    }
    return self;
}
- (void)awakeFromNib{
    if (!self.imgView) {        
        _imgView = [[XUIImageView alloc] initWithFrame:self.bounds];
        [_imgView setClipsToBounds:YES];
        [_imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self addSubview:_imgView];
        [self addTarget:self action:@selector(viewFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        self.canShowFullScreen = YES;
    }
}
- (void)reset{
    [self.fullScreenImgView setDelegate:nil];
    RELEASE(_fullScreenImgView);
    RELEASE(_indicator);
    RELEASE(_bottomView);
    RELEASE(_container);
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [super removeTarget:target action:action forControlEvents:controlEvents];
    [super addTarget:target action:action forControlEvents:controlEvents];
}
- (void)setSmallPic:(NSString *)smallPic{
    RELEASE(_smallPic);
    _smallPic = [smallPic retain];
    [self.imgView setDelegate:self];
    [self.imgView setImageURLString:smallPic];
}
- (void)imageView:(XUIImageView *)imgView didChangeImage:(UIImage *)image{    
    if (imgView == self.imgView) {
        [self.fullScreenImgView setImage:image];
        return;
    }
    if (image) {
        [self relayoutImageView:imgView withImage:image];
        [self.container addSubview:[self bottomView]];
    }
    [self.indicator stopAnimating];
    
}
- (void)relayoutImageView:(UIImageView*)imgView withImage:(UIImage *)image{
    float W = self.container.bounds.size.width - 20, H = self.container.bounds.size.height-20;
    float imgWidth = image.size.width, imgHeight = image.size.height;
    if (W/H > imgWidth/imgHeight) {
        if (imgHeight>H) {
            imgHeight = H;
            imgWidth = image.size.width/image.size.height*imgHeight;
        }
    }else{
        if (imgWidth>W) {
            imgWidth = W;
            imgHeight = image.size.height/image.size.width*imgWidth;
        }
    }
    CGRect rect = CGRectMake((self.container.bounds.size.width - imgWidth)/2, (self.container.bounds.size.height-imgHeight)/2, imgWidth, imgHeight);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [imgView setFrame:rect]; 
                         [self.container setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.96]];
                     } 
                     completion:^(BOOL finished) {
                     }];

}
- (UIView *)bottomView{
    if (_bottomView) {
        return _bottomView;
    }
    CGRect rect = CGRectMake(0, self.container.bounds.size.height-40, self.container.bounds.size.width, 40);
    UIView* view = [[[UIView alloc] initWithFrame:rect] autorelease];
    [view setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.3]];
    rect = view.bounds;
    float iconWidth = rect.size.height;
    rect.size.width -= iconWidth+10;
    UILabel *titleLabel = createLabel(rect, [UIFont systemFontOfSize:14], nil, [UIColor whiteColor], nil, CGSizeZero, UITextAlignmentLeft, 1, UILineBreakModeTailTruncation);
    [titleLabel setText:self.title];
    [view addSubview:titleLabel];
    
    rect.origin.x += rect.size.width;
    rect.size.width = iconWidth;
    UIImage *downloadImage = [UIImage imageNamed:@"download"];
    rect = CGRectMake(rect.origin.x+(iconWidth-downloadImage.size.width)/2, rect.origin.y+(iconWidth-downloadImage.size.height)/2, downloadImage.size.width, downloadImage.size.height);
    UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [btn setImage:downloadImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self setBottomView:view];
    return view;
}
- (void)viewFullScreen:(id)sender{
    if (sender==nil) {
        sender = self;
    }
    if (!self.canShowFullScreen) {
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *container = [[[UIView alloc] initWithFrame:window.bounds] autorelease];
    [container setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:container.bounds] autorelease];
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:3.0];
    scrollView.bouncesZoom = YES;
    scrollView.userInteractionEnabled=YES;
    [container addSubview:scrollView];
    [window addSubview:container];
    
    
    CGRect rect = [scrollView convertRect:self.frame fromView:self.superview];
    XUIImageView *imgView = [[[XUIImageView alloc] initWithFrame:rect] autorelease];
    [imgView setObject:scrollView];
    [imgView setDelegate:self];
    UIImage *img = self.imgView.image?self.imgView.image:[UIImage imageNamed:@"thumbnail"];
    [imgView setImage:img];
    imgView.userInteractionEnabled=YES;
    [scrollView addSubview:imgView];    
    [self setFullScreenImgView:imgView];
    
    
    
    //
    self.indicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)] autorelease];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator setCenter:CGPointMake(container.bounds.size.width/2, container.bounds.size.height/2)];
    [self.indicator.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.indicator.layer setShadowOpacity:1.0];
    [self.indicator.layer setShadowRadius:3.0];
    [self.indicator.layer setShadowColor:[UIColor blackColor].CGColor];
    [container addSubview:self.indicator];
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitFullScreen:)] autorelease];
    [scrollView addGestureRecognizer:tap];
    [self setContainer: container];
    [self relayoutImageView:imgView withImage:img]; 
    if ([self.bigPic isURL]) 
        [self.indicator startAnimating];
    [imgView setImageURLString:self.bigPic];
}
- (void)removeSelf{
    if(self.superview)
        [self removeFromSuperview];
    RELEASE(self);
}
- (void)quitFullScreen:(UIGestureRecognizer *)r{
    UIScrollView *scrollView = (UIScrollView*)r.view;
    UIImageView *imgView = nil;
    for ( id v in scrollView.subviews ) {
        if ([v isKindOfClass:[UIImageView class]]) {
            imgView = v;
            break;
        }
    }
    CGRect rect = [scrollView convertRect:self.frame fromView:self.superview];
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
    }
    [self.indicator stopAnimating];
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (imgView) {
                             [imgView setFrame:rect];
                         }
                         [scrollView.superview setAlpha:0.3];
                     } 
                     completion:^(BOOL finished) {
                         [scrollView.superview removeFromSuperview];
                         if (self.autoRemove) {
                             [self removeSelf];
                         }
                         [self reset];
                     }];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width*scale, scrollView.bounds.size.height*scale)];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for ( id imgView in scrollView.subviews ) {
        if ([imgView isKindOfClass:[UIImageView class]]) {
            return imgView;
        }
    }
    return nil;
}
- (void)saveImage:(id)sender{
    if (self.fullScreenImgView.image) {
        [BIndicator showMessageAndFadeOut:NSLocalizedString(@"Save image success!", nil)];
        UIImageWriteToSavedPhotosAlbum(self.fullScreenImgView.image, nil, nil, nil);
    }
}
@end
