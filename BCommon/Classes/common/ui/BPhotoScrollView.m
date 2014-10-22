//
//  BPhotoScrollView.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-3.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BPhotoScrollView.h"


@interface BPhotoView()<UIScrollViewDelegate>
@property (nonatomic, retain)UIView *container;
@property (nonatomic, retain) XUIImageView *fullScreenImgView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
- (void)relayoutImageView:(UIImageView*)imgView withImage:(UIImage *)image;
@end

@implementation BPhotoView
- (void)dealloc{
    if ([self.scrollView superview]) {
        [self.scrollView removeFromSuperview];
    }
    RELEASE(_scrollView);
    RELEASE(_userInfo);
    RELEASE(_container);
    RELEASE(_thumbnail);
    RELEASE(_origin);
    RELEASE(_fullScreenImgView);
    RELEASE(_indicator);
    RELEASE(_bottomView);
    RELEASE(_backgroundImageView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)setup{
    [self addTarget:self action:@selector(viewFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotate:) name:UIDeviceOrientationDidChangeNotification  object:[UIDevice currentDevice]];

}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.canShowFullScreen = YES;
    }
    return self;
}
- (void)awakeFromNib{
    [self setup];
}
- (void)clear{
    RELEASE(_fullScreenImgView);
    RELEASE(_indicator);
    RELEASE(_bottomView);
    RELEASE(_container);
    [[UIWindow preViewWindow] setHidden:YES];
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    //[self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    //[super removeTarget:target action:action forControlEvents:controlEvents];
    [super addTarget:target action:action forControlEvents:controlEvents];
}
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        [self addSubview:_backgroundImageView];
        [self sendSubviewToBack:_backgroundImageView];
    }
    return _backgroundImageView;
}
- (void)setContentMode:(UIViewContentMode)contentMode{
    self.backgroundImageView.contentMode = contentMode;
}
- (UIViewContentMode)contentMode{
    return self.backgroundImageView.contentMode;
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [self.backgroundImageView setImage:image];
    [self bringSubviewToFront:self.imageView];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self bringSubviewToFront:self.imageView];
}
- (void)setThumbnail:(NSString *)thumbnail{
    if (!thumbnail) {
        return;
    }
    RELEASE(_thumbnail);
    _thumbnail = [thumbnail retain];
    
    NSURL *url = isURL(thumbnail) ? [NSURL URLWithString:thumbnail] : [NSURL fileURLWithPath:thumbnail];
    [self.backgroundImageView setImageURL:url];
}
- (void)saveStatusBarStyle{
    self.statusBarStyle = [APP statusBarStyle];
}
- (void)setStatusBarStyle{
    [APP setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)restoreStatusBarStyle{
    [APP setStatusBarStyle:self.statusBarStyle];
}
- (void)relayoutImageView:(UIImageView*)imgView withImage:(UIImage *)image{
    if (!image)
        return;
    float padding = 0;
    float W = self.container.bounds.size.width - 2*padding, H = self.container.bounds.size.height- 2*padding;
    float imgWidth = MIN(W, image.size.width);
    float imgHeight = image.size.height*imgWidth/image.size.width;
    
    CGRect rect = CGRectMake((self.container.bounds.size.width - imgWidth)/2, MAX((self.container.bounds.size.height-imgHeight)/2, 0), imgWidth, imgHeight);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [imgView setFrame:rect];
                         [self.container setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.96]];
                     }
                     completion:^(BOOL finished) {
                         self.scrollView.contentSize = CGSizeMake(MAX(imgView.bounds.size.width, self.scrollView.bounds.size.width), MAX(imgView.bounds.size.height, self.scrollView.bounds.size.height));
                         
                     }];
    
    float minScale = image.size.width/self.scrollView.bounds.size.width;
    minScale = minScale>1?1:minScale;
    
    [self.scrollView setMinimumZoomScale:minScale];
    [self.scrollView setMaximumZoomScale:3.0];
}
- (UIView *)bottomView{
    if (_bottomView) {
        return _bottomView;
    }
    CGRect rect = CGRectMake(0, self.container.bounds.size.height-40, self.container.bounds.size.width, 40);
    UIView* view = [[[UIView alloc] initWithFrame:rect] autorelease];
    [view setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
    rect = view.bounds;
    float iconWidth = rect.size.height;
    rect.size.width -= iconWidth+10;
    UILabel *titleLabel = createLabel(rect, [UIFont systemFontOfSize:14], nil, [UIColor whiteColor], nil, CGSizeZero, UITextAlignmentLeft, 1, UILineBreakModeTailTruncation);
    [titleLabel setText:self.title];
    [view addSubview:titleLabel];
    
    rect.origin.x += rect.size.width;
    rect.size.width = iconWidth;
    UIImage *downloadImage = [UIImage imageNamed:@"icon-download"];
    rect = CGRectMake(rect.origin.x+(iconWidth-downloadImage.size.width)/2, rect.origin.y+(iconWidth-downloadImage.size.height)/2, downloadImage.size.width, downloadImage.size.height);
    UIButton *btn = AUTORELEASE([[UIButton alloc] initWithFrame:rect]);
    [btn setImage:downloadImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self setBottomView:view];
    return view;
}
- (void)viewFullScreen:(id)sender{
    BOOL canFullScreen = self.canShowFullScreen;
    if (sender==nil) {
        sender = self;
        canFullScreen = YES;
    }
    if (!canFullScreen) {
        return;
    }
    [self saveStatusBarStyle];
    [self setStatusBarStyle];
    UIImage *thumbnailImage = self.backgroundImageView.image;
    thumbnailImage = thumbnailImage?:[UIImage imageNamed:@"thumbnail"];
    
    
    UIWindow *window = [UIWindow preViewWindow];
    UIView *container = AUTORELEASE([[UIView alloc] initWithFrame:window.bounds] );
    [container setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    float angle = 0;
    if ([APP statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        angle = M_PI*0.5;
    }
    if([APP statusBarOrientation] == UIInterfaceOrientationLandscapeLeft){
        angle = -M_PI*0.5;
    }
    if (angle!=0) {
        container.bounds = CGRectMake(0, 0, window.bounds.size.height, window.bounds.size.width);
        container.center = window.center;
        container.transform = CGAffineTransformMakeRotation(angle);
    }
    
    UIScrollView *scrollView = AUTORELEASE([[UIScrollView alloc] initWithFrame:container.bounds]);
    scrollView.bounces = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    scrollView.bouncesZoom = YES;
    scrollView.userInteractionEnabled=YES;
    [container addSubview:scrollView];
    [window addSubview:container];
    self.container = container;
    self.scrollView = scrollView;
    
    
    
    
    CGRect rect = [scrollView convertRect:self.frame fromView:self.superview];
    XUIImageView *imgView = [[[XUIImageView alloc] initWithFrame:rect] autorelease];
    [imgView setImage:thumbnailImage];
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
    
    UITapGestureRecognizer *tap = AUTORELEASE([[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitFullScreen:)]);
    [scrollView addGestureRecognizer:tap];
    
    [self relayoutImageView:imgView withImage:thumbnailImage];
    
    if ([self.origin isURL])
        [self.indicator startAnimating];
    if (!self.origin) {
        return;
    }
    NSURL *imageURL = [self.origin isURL] ? [NSURL URLWithString:self.origin]:[NSURL fileURLWithPath:self.origin];
    [imgView setImageURL:imageURL placeholderImage:thumbnailImage withImageLoadedCallback:^(NSURL *imageURL, NSString *filePath, NSError *error) {
        [self.indicator stopAnimating];
        if (error) {
            [BIndicator showMessageAndFadeOut:error.localizedDescription];
            return ;
        }
        [self relayoutImageView:self.fullScreenImgView withImage:self.fullScreenImgView.image];
        [self.container addSubview:[self bottomView]];
    }];
    [window makeKeyAndVisible];
}
- (void)removeSelf{
    if(self.superview)
        [self removeFromSuperview];
    RELEASE(self);
    [[UIWindow preViewWindow] setHidden:YES];
}
- (void)quitFullScreen:(UIGestureRecognizer *)r{
    [self restoreStatusBarStyle];
    UIScrollView *scrollView = (UIScrollView*)r.view;
    UIImageView *imgView = self.fullScreenImgView;
    CGRect rect = [scrollView convertRect:self.frame fromView:self.superview];
    [self.indicator stopAnimating];
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (imgView) {
                             [imgView setFrame:rect];
                         }
                         [self.container setAlpha:0.3];
                     }
                     completion:^(BOOL finished) {
                         if (self.container.superview) {
                             [self.container removeFromSuperview];
                         }
                         if (self.autoRemove) {
                             [self removeSelf];
                         }
                         [self clear];
                     }];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIView *imageView = [self viewForZoomingInScrollView:scrollView];
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageFrame = imageView.frame;
    
    // center horizontally
    if (imageFrame.size.width < boundsSize.width)
    {
        imageFrame.origin.x = (boundsSize.width - imageFrame.size.width) / 2;
    } else {
        imageFrame.origin.x = 0;
    }
    
    // center vertically
    if (imageFrame.size.height < boundsSize.height)
    {
        imageFrame.origin.y = (boundsSize.height - imageFrame.size.height) / 2;
    } else {
        imageFrame.origin.y = 0;
    }
    imageView.frame = imageFrame;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    DLOG(@"%@",NSStringFromCGSize(scrollView.contentSize));
    for ( id imgView in scrollView.subviews ) {
        if ([imgView isKindOfClass:[UIImageView class]]) {
            return imgView;
        }
    }
    return nil;
}
- (void)saveImage:(id)sender{
    if (self.fullScreenImgView.image) {
        UIImageWriteToSavedPhotosAlbum(self.fullScreenImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL){
        [BIndicator showMessageAndFadeOut:error.localizedDescription];
    }
    else{
        [BIndicator showMessageAndFadeOut:NSLocalizedString(@"已保存到相册", nil)];
    }
}
- (void)deviceRotate:(NSNotification *)noti  {
    if (!self.container) {
        return;
    }
    UIInterfaceOrientation orientation = [APP statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft: //home button on the right
        case UIDeviceOrientationLandscapeRight:{
            float angle = M_PI*0.5;
            if(orientation == UIDeviceOrientationLandscapeRight){
                angle = -M_PI*0.5;
            }
            [UIView animateWithDuration:0.8
                             animations:^{
                                 self.container.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                             }];
            break;
            
        }
        default:
            break;
    }
}
@end

