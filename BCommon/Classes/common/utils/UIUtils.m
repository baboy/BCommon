//
//  UIUtils.m
//  itv
//
//  Created by Zhang Yinghui on 9/24/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "UIUtils.h"
#import "BCommon.h"

id loadViewFromNib(Class nibClass,id owner){
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass)
                                                          owner:owner
                                                        options:nil];
    assert( objectsInNib.count == 1);
    return [objectsInNib objectAtIndex:0];
}
void setButtonImage(UIButton *button,NSString *imageName, NSString *imageName2, BOOL isBackground){
    UIImage *image = nil, *image2 = nil, *selectImage = nil;
    if ([imageName isKindOfClass:[UIColor class]]) {
        image = [UIImage imageWithColor:(id)imageName size:CGSizeMake(5, 5)];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    }else{
        image = [UIImage imageNamed:imageName];
        if (!image && ![imageName hasSuffix:@"-0"]) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", imageName]];
            if (image) {
                imageName = [NSString stringWithFormat:@"%@-0", imageName];
            }
        }
        if (!imageName2) {
            imageName2 = [imageName stringByReplacingOccurrencesOfString:@"-0" withString:@"-1"];
        }
        image2 = [imageName2 isEqualToString:imageName]?nil:[UIImage imageNamed:imageName2];
        image = image?:[UIImage imageWithContentsOfFile:imageName];
        image2 = image2?:[UIImage imageWithContentsOfFile:imageName2];
        NSString *imageSelectName = [imageName stringByReplacingOccurrencesOfString:@"-0" withString:@"-selected"];
        selectImage = [UIImage imageNamed:imageSelectName];
    }
    
    if (isBackground) {
        image = image?[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)]:nil;
        image2 = image?[image2 resizableImageWithCapInsets:UIEdgeInsetsMake(image2.size.height/2, image2.size.width/2, image2.size.height/2, image2.size.width/2)]:nil;
        selectImage = selectImage?[selectImage resizableImageWithCapInsets:UIEdgeInsetsMake(selectImage.size.height/2, selectImage.size.width/2, selectImage.size.height/2, selectImage.size.width/2)]:nil;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    }else{
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image2 forState:UIControlStateHighlighted];
        [button setImage:selectImage forState:UIControlStateSelected];
    }
}
CGSize sizeOfImage(NSString *imageName){
    CGSize size = CGSizeZero;
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image && ![imageName hasSuffix:@"-0"]) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", imageName]];
    }
    if (!image)
        image = [UIImage imageWithContentsOfFile:imageName];
    if (image)
        size = image.size;
    return size;
}
UILabel * createLabel(CGRect frame,UIFont *font,UIColor *bg,UIColor *textColor,UIColor *shadow,CGSize shadowSize,int textAlign,int numOfLines,int lineBreakMode){
	frame.origin.x = ceilf(frame.origin.x);
    frame.origin.y = ceilf(frame.origin.y);
    frame.size.width = ceilf(frame.size.width);
    frame.size.height = ceilf(frame.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.font = font;
	label.backgroundColor = bg?bg:[UIColor clearColor];
    label.textColor = textColor;
	if (shadow) {
		label.shadowColor = shadow;
		label.shadowOffset = shadowSize;
	}
	label.numberOfLines = numOfLines;
	label.lineBreakMode = lineBreakMode;
	label.textAlignment = textAlign;
	return [label autorelease];
}
UIButton *createCustomButton(CGRect rect,NSString *title,UIColor *titleColor,UIColor *titleShadowColor,NSString *imgName,NSString *imgName2){ 
    if (!imgName2) {        
        imgName2 = [imgName stringByReplacingOccurrencesOfString:@"-0." withString:@"-1."];
        if ([imgName2 isEqualToString:imgName]) {
            imgName2 = nil;
        }
    }
    UIImage *bg1 = [UIImage imageNamed:imgName];
    UIImage *bg2 = [UIImage imageNamed:imgName2];
    if (rect.size.width==0) {
        if (bg1) {
            rect.size = bg1.size;
        }else{            
            float w = [title sizeWithFont:gButtonTitleFont].width+10;
            rect.size = CGSizeMake(MAX(w, 48), 24);
        }
    }
	UIButton *btn = [[XUIButton alloc] initWithFrame:rect];
	btn.titleLabel.font = gButtonTitleFont;
    if (titleShadowColor) {
        btn.titleLabel.shadowColor = titleShadowColor;
        btn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    }
	[btn setTitleColor:titleColor forState:UIControlStateNormal];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if (bg1) {
        if(bg1) bg1 = [bg1 stretchableImageWithLeftCapWidth:bg1.size.width/2 topCapHeight:bg1.size.height/2];
        if(bg2) bg2 = [bg2 stretchableImageWithLeftCapWidth:bg2.size.width/2 topCapHeight:bg2.size.height/2];
    }else{
        UIColor *bg = [UIColor colorWithRed:112/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        bg1 = [UIImage imageWithColor:bg size:rect.size];
        bg2 = [UIImage imageWithColor:bg size:rect.size];
    }
	if(bg1) [btn setBackgroundImage:bg1 forState:UIControlStateNormal];
	if(bg2) [btn setBackgroundImage:bg2 forState:UIControlStateHighlighted];
	return [btn autorelease];

}
UIBarButtonItem * createBarButtonItem(NSString *title,id target,SEL action){
    //UIImage *btnBg = [UIImage imageNamed:@"btn_bg.png"];
    //[btnBg stretchableImageWithLeftCapWidth:btnBg.size.height/2 topCapHeight:btnBg.size.width/2];
    CGSize tsize = [title sizeWithFont:gButtonTitleFont];
    CGRect rect = CGRectMake(0, 0, tsize.width+12, 28);
    
    UIButton *btn = [[[XUIButton alloc] initWithFrame:rect] autorelease];
    //[btn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:gButtonTitleFont];
    [btn setTitleColor:gButtonTitleColor  forState:UIControlStateNormal];
    [btn.layer setBorderColor:[UIColor colorWithWhite:0.96 alpha:1.0].CGColor];
    [btn.layer setBorderWidth:1.0];
    //[btn setTitleShadowColor:gButtonTitleShadowColor forState:UIControlStateNormal];
   // [btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [item setTarget:target];
    [item setAction:action];
    return [item autorelease];
}
UIBarButtonItem * createBarImageButtonItem(NSString *iconName,id target,SEL action){
    UIButton *btn = createImageButton(CGRectZero, iconName, target, action);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //[item setTarget:target];
    //[item setAction:action];
    return [item autorelease];
}
UIButton * createRoundCornerButton(CGRect rect,NSString *title, id target, SEL action){
    if (rect.size.width==0) {
        rect.size.width = [title sizeWithFont:gButtonTitleFont].width+20;
        rect.size.height = 32;
    }
	UIButton *_btn = [[XUIButton alloc] initWithFrame:rect];
	_btn.titleLabel.font = gButtonTitleFont;
	[_btn setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
	[_btn setTitle:title forState:UIControlStateNormal];
	[_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	
	CGSize r = CGSizeMake(rect.size.width*2, rect.size.height*2);
	[_btn setBackgroundImage:createButtonBg([UIColor colorWithWhite:0.9 alpha:1], [UIColor whiteColor], r) forState:UIControlStateNormal];
	[_btn setBackgroundImage:createButtonBg([UIColor blueColor], [UIColor blueColor], r) forState:UIControlStateHighlighted];
	[_btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [_btn autorelease];
}

UIButton * createColorizeImgButton(CGRect rect,NSString *imgName,UIColor *color, id target, SEL action){
    if (!imgName) {
        return  nil;
    }
    UIImage *img1 = [UIImage imageNamed:imgName];
    if (!img1 && ![imgName hasSuffix:@"-0"]) {
        img1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@-0", imgName]];
        if (img1) {
            imgName = [NSString stringWithFormat:@"%@-0", imgName];
        }
    }
    NSString *imgName2 = [imgName stringByReplacingOccurrencesOfString:@"-0." withString:@"-1."];
    UIImage *img2 = [imgName2 isEqualToString:imgName]?nil:[UIImage imageNamed:imgName2];
    img1 = img1?:[UIImage imageWithContentsOfFile:imgName];
    img2 = img2?:[UIImage imageWithContentsOfFile:img2];
    
    if (!img1)
        return nil;
    if (img1 && color)
        img1 = [img1 imageWithColor:color];
    if (img2 && color)
        img2 = [img2 imageWithColor:color];
    if (rect.size.width==0)
        rect.size = img1.size;
    
	UIButton *btn = [[XUIButton alloc] initWithFrame:rect];
    btn.backgroundColor = [UIColor clearColor];
	[btn setImage:img1 forState:UIControlStateNormal];
	if (img2)
        [btn setImage:img2 forState:UIControlStateHighlighted];
    if (target)
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [btn autorelease];
}
UIButton * createImgButton(CGRect rect,NSString *imgName,id target, SEL action){
    return createColorizeImgButton(rect, imgName,nil, target, action);
}

UIButton * createPlayButton(CGRect rect,id target,SEL action){    
    UIImage *icon_play = [UIImage imageNamed:@"play_btn"];
    if (rect.size.width<10) {
        rect.size = icon_play.size;
    }
    UIButton *btn = [[[XUIButton alloc] initWithFrame:rect] autorelease];
    [btn setImage:icon_play forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
UIButton *createImageButton(CGRect frame, NSString *imageName, id target, SEL action){
    if (frame.size.width == 0 || frame.size.height == 0) {
        frame.size = sizeOfImage(imageName);
    }
    UIButton *btn = createButton(frame, nil,imageName, target, action);
    return btn;
}
UIButton *createButton(CGRect frame, NSString *title, id imgName,id target, SEL action){
    if ( (frame.size.width == 0 || frame.size.height == 0) && [title length] > 0 ) {
        CGSize size = title ? [title sizeWithFont:gButtonTitleFont] : CGSizeMake(48, 28);
        frame = CGRectMake(0,0, MAX(size.width+20, 44), size.height+10);
    }
    if ( ( !title || [title isEqualToString:@""] ) && ![imgName isKindOfClass:[UIColor class]] ) {
        UIImage *backgroundImage = [UIImage imageNamed:imgName];
        if (backgroundImage) {
            frame.size = CGSizeMake( backgroundImage.size.width, backgroundImage.size.height);
        }
    }
    UIButton *btn = AUTORELEASE([[XUIButton alloc] initWithFrame:frame]);
    btn.titleLabel.font = gButtonTitleFont;
    btn.titleLabel.textColor = gButtonTitleColor;
    [btn setTitle:title forState:UIControlStateNormal];
    setButtonImage(btn, imgName, nil,title?YES:NO);
    if (target)
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

CGSize CGSizeScale(CGSize size,float scale){
	return CGSizeMake(size.width*scale,size.height*scale);
}
UIImage *createButtonCircleBg(CGSize size,float rad,UIColor *borderColor,UIColor *color1,UIColor *color2,UIColor *color3,UIColor *color4){
    if (!color1) {
        color1 = gButtonCircleBgGradColor1;
        color2 = gButtonCircleBgGradColor2;
        color3 = gButtonCircleBgGradColor3;
        color4 = gButtonCircleBgGradColor4;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);	
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
	CGRect r = CGRectInset(rect, 0, 0);
	createPath(ctx, r,rad);
    
	CGContextClosePath(ctx);	
	CGContextClip(ctx);
    
	CGFloat locations[] = {0.0,1.0};
	CGGradientRef gradient = createGradient(ctx,[NSArray arrayWithObjects:color1,color2, nil],locations);
	CGPoint s = r.origin;
	CGPoint e = CGPointMake(s.x, s.y+r.size.height);
	CGContextDrawLinearGradient(ctx, gradient,s,e, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
    
	
	r = CGRectInset(r, 2, 2);
	createPath(ctx, r,rad-1);
    
	CGContextClosePath(ctx);	
	CGContextClip(ctx);
    
	CGFloat locations2[] = {0.0,1.0};
	gradient = createGradient(ctx,[NSArray arrayWithObjects:color3,color4, nil],locations2);
	s = r.origin;
	e = CGPointMake(s.x, s.y+r.size.height);
	CGContextDrawLinearGradient(ctx, gradient,s,e, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
    
	
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
	UIGraphicsEndImageContext();
	return _img;	
}

@implementation XUIButton
- (void)dealloc{
    RELEASE(_object);
    [super dealloc];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *backgroundImage = [self backgroundImageForState:UIControlStateNormal];
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2, image.size.width/2)];
    [super setBackgroundImage:image forState:state];
}
- (void)relayout{
    if (self.textAlignStyle == UIButtonTextAlignmentStyleHorizontal) {
        return;
    }
    UIImage *image = self.currentImage;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float labelWidth = self.titleLabel.bounds.size.width;
    float labelHeight = self.titleLabel.bounds.size.height;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight/2,labelWidth/2,labelHeight/2,-labelWidth/2);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.size = titleSize;
    self.titleLabel.frame = labelFrame;
    CGFloat offsetX = (titleSize.width-labelWidth)/2;
    self.titleEdgeInsets = UIEdgeInsetsMake(imageHeight/2,-imageWidth/2-offsetX,-imageHeight/2,imageWidth/2+offsetX);
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self relayout];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self relayout];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self relayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self relayout];
}
@end

@implementation VerticalButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textAlignStyle = UIButtonTextAlignmentStyleVertical;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignStyle = UIButtonTextAlignmentStyleVertical;
    }
    return self;
}

@end

