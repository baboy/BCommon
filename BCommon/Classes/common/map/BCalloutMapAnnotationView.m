//
//  BCalloutMapAnnotationView.m
//  iLookForiPhone
//
//  Created by Zhang Yinghui on 12-9-5.
//  Copyright (c) 2012年 LavaTech. All rights reserved.
//

#import "BCalloutMapAnnotationView.h"
#import "BCommon.h"

#define AnnoTitleFont       [UIFont boldSystemFontOfSize:16]
#define AnnoSubTitleFont    [UIFont systemFontOfSize:14]
#define AnnoTitleColor      [UIColor colorWithWhite:0 alpha:1.0]
#define AnnoSubTitleColor   [UIColor colorWithWhite:0.3 alpha:1.0]
#define AnnoImageWidth      48.0

@interface BCalloutMapAnnotationView()
@property (nonatomic, retain) UIImageView *videoIndicator;
@end

@implementation BCalloutMapAnnotationView
@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;
@synthesize photoView = _photoView;
@synthesize videoIndicator = _videoIndicator;
- (void)dealloc{
    RELEASE(_videoIndicator);
    RELEASE(_titleLabel);
    RELEASE(_descLabel);
    RELEASE(_photoView);
    [super dealloc];
}

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        _photoView = [[BPhotoScrollView alloc] initWithFrame:CGRectZero];
        [_photoView setClipsToBounds:YES];
        _titleLabel = [createLabel(CGRectZero, AnnoTitleFont, nil, AnnoTitleColor, [UIColor colorWithWhite:1.0 alpha:0.6], CGSizeMake(0, 1), UITextAlignmentLeft, 1, UILineBreakModeTailTruncation) retain];
        _descLabel = [createLabel(CGRectZero, AnnoSubTitleFont, nil, AnnoSubTitleColor, nil, CGSizeZero, UITextAlignmentLeft, 1, UILineBreakModeTailTruncation) retain];
        
        
        _videoIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_play_btn"]];
        [_videoIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin];
        [_videoIndicator setHidden:YES];
        [_photoView addSubview:_videoIndicator];
        
        [_photoView setEnabled:YES];
        [_photoView setExclusiveTouch:YES];
        [self.contentView addSubview:_photoView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_descLabel];
        
        [self.contentView setTag:BCalloutAnnoViewTapTagBackground];
        [self.photoView setTag:BCalloutAnnoViewTapTagPhoto];
        
        //[_photoView addTarget:self action:@selector(tapPhoto:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
        [_photoView removeTarget:_photoView action:NULL forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapContentView = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)] autorelease];
        [self.contentView addGestureRecognizer:tapContentView];
        
        UITapGestureRecognizer *tapPhoto = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)] autorelease];
        [self.photoView addGestureRecognizer:tapPhoto];
	}
	return self;
}
- (void) setPhotoCanFullScreen:(BOOL)canFullScreen{
    [self.photoView setCanShowFullScreen:canFullScreen];
}
- (void)relayoutContent{
    BCalloutMapAnnotation *anno = (BCalloutMapAnnotation*)self.annotation;
    CGRect rect = self.contentView.bounds;
    DLOG(@"relayoutContent:%@",NSStringFromCGRect(rect));
    float padding = 3.0;
    if (isURL(anno.smallPic)) {
        CGRect imgRect = CGRectMake(rect.size.width - AnnoImageWidth, 0, AnnoImageWidth, AnnoImageWidth);
        imgRect = CGRectInset(imgRect, padding,padding);
        [self.photoView setFrame:imgRect];
        [self.photoView setHidden:NO];
        rect = CGRectMake(0, 0, rect.size.width - AnnoImageWidth, rect.size.height);
        [self.photoView setSmallPic:anno.smallPic];
        [self.photoView setBigPic:anno.bigPic];
        if (isURL([anno video])) {
            CGRect vRect = self.videoIndicator.frame;
            vRect.origin = CGPointMake(imgRect.size.width - vRect.size.width, imgRect.size.height-vRect.size.height);
            [self.videoIndicator setFrame:vRect];
            [self.videoIndicator setHidden:NO];
        }else{
            [self.videoIndicator setHidden:YES];
        }
    }else{        
        [self.photoView setHidden:YES];
    }
    rect.size.height = AnnoImageWidth/2;
    rect.origin.x += padding;
    rect.size.width -= padding;
    [self.titleLabel setFrame:rect];
    [self.titleLabel setText:anno.title];
    if (anno.subtitle) {
        rect.origin.y += rect.size.height;
        [self.descLabel setFrame:rect];
        [self.descLabel setText:anno.subtitle];
    }
}
- (void)prepareFrameSize {
    BCalloutMapAnnotation *anno = (BCalloutMapAnnotation*)self.annotation;
    float minWidth = self.mapView.frame.size.width*0.5, maxWidth = self.mapView.frame.size.width*0.8;
    float w = [anno.title sizeWithFont:AnnoTitleFont forWidth:maxWidth lineBreakMode:UILineBreakModeTailTruncation].width;
    if (anno.subtitle) {
        w = MAX(w,[anno.subtitle sizeWithFont:AnnoTitleFont forWidth:maxWidth lineBreakMode:UILineBreakModeTailTruncation].width);
    }
    if (isURL(anno.smallPic)) {
        w += AnnoImageWidth;
    }
    w += 10;
    w = MAX(minWidth,w);
    w = MIN(maxWidth,w);
    float h = AnnoImageWidth/2;
    if (anno.subtitle || isURL(anno.smallPic)) {
        h += AnnoImageWidth/2;
    }
    self.contentHeight = h;
	CGRect frame = self.frame;
	h +=	CalloutMapAnnotationViewContentHeightBuffer + CalloutMapAnnotationViewBottomShadowBufferSize -	self.offsetFromParent.y;
	
	frame.size = CGSizeMake(w, h);
    DLOG(@"prepareFrameSize:%@",NSStringFromCGRect(frame));
	self.frame = frame;
}
- (void)setAnnotation:(id <MKAnnotation>)annotation {
    BCalloutMapAnnotation *anno = (BCalloutMapAnnotation*)self.annotation;
    [self setPhotoCanFullScreen:(!isURL([anno video]) && [anno smallPic])];
	[super setAnnotation:annotation];
    [self relayoutContent];
}
- (void)reselectAnnotation{
    [self.mapView selectAnnotation:self.parentAnnotationView.annotation animated:NO];
}
- (void)tapPhoto:(UITapGestureRecognizer *)r{
    if (r.state == UIGestureRecognizerStateEnded && r.view == self.photoView) {
        if (self.photoView.canShowFullScreen) {        
            [self.photoView viewFullScreen:nil];
        }
        if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]){
            [self.mapView.delegate mapView:self.mapView annotationView:self.parentAnnotationView calloutAccessoryControlTapped:(id)r.view];
        }

    }
}
- (void)tapContentView:(UITapGestureRecognizer *)r{
    DLOG(@"tapContentView:%d",r.state);
    if (r.state == UIGestureRecognizerStateEnded && r.view==self.contentView) {
        if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]){
            [self.mapView.delegate mapView:self.mapView annotationView:self.parentAnnotationView calloutAccessoryControlTapped:(id)r.view];
        }
        [self.mapView deselectAnnotation:self.parentAnnotationView.annotation animated:YES];
    }
}
- (void)drawRect:(CGRect)rect {
	CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat parentX = [self relativeParentXPosition];
	
	//Determine Size
	rect = self.bounds;
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + CalloutMapAnnotationViewHeightAboveParent - self.offsetFromParent.y + CalloutMapAnnotationViewBottomShadowBufferSize;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0;
	
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
				 radius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 15, 
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, 
						 rect.origin.y + rect.size.height + 15);
	CGPathAddLineToPoint(path, NULL, parentX + 15, 
						 rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, 
						 rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, 
				 rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
				 radius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, 
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(path);
	
	//Fill Callout Bubble & Add Shadow
	color = [UIColor colorWithWhite:0.96 alpha:0.9];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 2, [UIColor colorWithWhite:0 alpha:1.0].CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	//Stroke Callout Bubble
	color = [UIColor colorWithWhite:1.0 alpha:1.0];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	return;
	//Determine Size for Gloss
	CGRect glossRect = self.bounds;
	glossRect.size.width = rect.size.width - stroke;
	glossRect.size.height = (rect.size.height - stroke) / 2;
	glossRect.origin.x = rect.origin.x + stroke / 2;
	glossRect.origin.y += rect.origin.y + stroke / 2;
	
	CGFloat glossTopRadius = radius - stroke / 2;
	CGFloat glossBottomRadius = radius / 1.5;
	
	//Create Path For Gloss
	CGMutablePathRef glossPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossTopRadius);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossRect.size.height - glossBottomRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, 
				 glossBottomRadius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
						 glossRect.origin.y + glossRect.size.height);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
				 glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, glossRect.origin.y + glossTopRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, glossRect.origin.y + glossTopRadius, 
				 glossTopRadius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, 
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(glossPath);
	
	//Fill Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	CGFloat colors[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
	};
	CGFloat locations[] = { 0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
	CGPoint startPoint = glossRect.origin;
	CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	//Gradient Stroke Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextSetLineWidth(context, 2);
	CGContextReplacePathWithStrokedPath(context);
	CGContextClip(context);
	CGFloat colors2[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
		1, 1, 1, .0,
	};
	CGFloat locations2[] = { 0, .1, 1.0 };
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, colors2, locations2, 3);
	CGPoint startPoint2 = glossRect.origin;
	CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
	
	//Cleanup
	CGPathRelease(path);
	CGPathRelease(glossPath);
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
	CGGradientRelease(gradient2);
}

@end


@implementation BCalloutMapAnnotation
@synthesize smallPic = _smallPic;
@synthesize bigPic = _bigPic;
@synthesize video = _video;
- (void)dealloc{
    RELEASE(_video);
    RELEASE(_smallPic);
    RELEASE(_bigPic);
    [super dealloc];
}

- (id)initWithAnnotation:(BCalloutMapAnnotation *)annotation{
    if (self = [super init]) {
        [self setCoordinate:annotation.coordinate];
        [self setTitle:annotation.title];
        [self setSubtitle:annotation.subtitle];
        [self setSmallPic:annotation.smallPic];
        [self setBigPic:annotation.bigPic];
        [self setVideo:annotation.video];
    }
    return self;
}
@end
