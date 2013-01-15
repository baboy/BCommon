//
//  UIUtils.m
//  itv
//
//  Created by Zhang Yinghui on 9/24/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "UIUtils.h"
#import "BCommon.h"

UIView * loadViewFromNib(Class nibClass,id owner){    
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass)
                                                          owner:owner
                                                        options:nil];
    assert( objectsInNib.count == 1);
    return [objectsInNib objectAtIndex:0];
}

UILabel * createLabel(CGRect frame,UIFont *font,UIColor *bg,UIColor *textColor,UIColor *shadow,CGSize shadowSize,int textAlign,int numOfLines,int lineBreakMode){
	frame.origin.x = ceilf(frame.origin.x);
    frame.origin.y = ceilf(frame.origin.y);
    frame.size.width = ceilf(frame.size.width);
    frame.size.height = ceilf(frame.size.height);
    UILabel *_label = [[UILabel alloc] initWithFrame:frame];
	_label.font = font;
	_label.backgroundColor = bg?bg:[UIColor clearColor];
	_label.textColor = textColor;
	if (shadow) {
		_label.shadowColor = shadow;
		_label.shadowOffset = shadowSize;
	}
	_label.numberOfLines = numOfLines;
	_label.lineBreakMode = lineBreakMode;
	_label.textAlignment = textAlign;
	return [_label autorelease];
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
            float w = [title sizeWithFont:gButtonFont].width+10;
            rect.size = CGSizeMake(MAX(w, 48), 24);
        }
    }
	UIButton *btn = [[UIButton alloc] initWithFrame:rect];
	btn.titleLabel.font = gButtonFont;
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
    CGSize tsize = [title sizeWithFont:gButtonFont];
    CGRect rect = CGRectMake(0, 0, tsize.width+12, 28);
    
    UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
    //[btn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:gButtonFont];
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
    UIImage *icon = [UIImage imageNamed:iconName];
    CGRect rect = CGRectMake(0, 0, icon.size.width, icon.size.height);
    
    UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [item setTarget:target];
    [item setAction:action];
    return [item autorelease];
}
UIButton * createRoundCornerButton(CGRect rect,NSString *title, id target, SEL action){
    if (rect.size.width==0) {
        rect.size.width = [title sizeWithFont:gButtonFont].width+20;
        rect.size.height = 32;
    }
	UIButton *_btn = [[UIButton alloc] initWithFrame:rect];
	_btn.titleLabel.font = gButtonFont;
	[_btn setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
	[_btn setTitle:title forState:UIControlStateNormal];
	[_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	
	CGSize r = CGSizeMake(rect.size.width*2, rect.size.height*2);
	[_btn setBackgroundImage:createButtonBg([UIColor colorWithWhite:0.9 alpha:1], [UIColor whiteColor], r) forState:UIControlStateNormal];
	[_btn setBackgroundImage:createButtonBg([UIColor blueColor], [UIColor blueColor], r) forState:UIControlStateHighlighted];
	[_btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [_btn autorelease];
}
/*
UIButton * createImgBarButton(CGRect rect,NSString *title,NSString *imgName){
    NSString *imgName2 = [imgName stringByReplacingOccurrencesOfString:@"-0." withString:@"-1."];
    UIImage *img1 = [UIImage imageNamed:imgName];
    UIImage *img2 = [UIImage imageNamed:imgName2];
    
	UIButton *_btn = [[UIButton alloc] initWithFrame:rect];
	_btn.titleLabel.font = [Theme font:DkeyBarButtonTitleFont];
    
    
	[_btn setTitleColor:[Theme color:DkeyBarButtonTitleColor] forState:UIControlStateNormal];
	[_btn setTitle:title forState:UIControlStateNormal];
    [_btn setImage:img1 forState:UIControlStateNormal];
    [_btn setImage:img2 forState:UIControlStateHighlighted];
	[_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	
	CGSize r = CGSizeMake(rect.size.width*2, rect.size.height*2);
    NSArray *bgs = [NSArray arrayWithObjects:[Theme color:DkeyBarButtonBgColor2],[Theme color:DkeyBarButtonBgColor3],[Theme color:DkeyBarButtonBgColor],[Theme color:DkeyBarButtonBgColor], nil];
    CGFloat locations[] = {0,0.51,0.51,1};
    UIImage *bg = createGradientButtonBg(bgs,locations,[Theme color:DkeyBarButtonBorderColor], r,10);
	[_btn setBackgroundImage:bg forState:UIControlStateNormal];
	[_btn setBackgroundImage:createButtonBg([Theme color:DkeyBarButtonBgHighLightColor], [Theme color:DkeyBarButtonBorderColor], r) forState:UIControlStateHighlighted];
	
	return [_btn autorelease];
}
 */
UIButton * createColorizeImgButton(CGRect rect,NSString *imgName,UIColor *color){
    if (!imgName) {
        return  nil;
    }
    NSString *imgName2 = [imgName stringByReplacingOccurrencesOfString:@"-0." withString:@"-1."];
    UIImage *img1 = [UIImage imageNamed:imgName];
    UIImage *img2 = [imgName2 isEqualToString:imgName]?nil:[UIImage imageNamed:imgName2];
    if (!img1) return nil;
    
    if (img1 && color) img1 = [img1 imageWithColor:color];
    if (img2 && color) img2 = [img2 imageWithColor:color];
    if (rect.size.width==0) {
        rect.size = img1.size;
    }
	UIButton *btn = [[UIButton alloc] initWithFrame:rect];    
	[btn setImage:img1 forState:UIControlStateNormal];
	if (img2) [btn setImage:img2 forState:UIControlStateHighlighted];
	return [btn autorelease];
}
UIButton * createImgButton(CGRect rect,NSString *imgName){
    return createColorizeImgButton(rect, imgName,nil);
}

UIButton * createPlayButton(CGRect rect,id target,SEL action){    
    UIImage *icon_play = [UIImage imageNamed:@"play_btn"];
    if (rect.size.width<10) {
        rect.size = icon_play.size;
    }
    UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [btn setImage:icon_play forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
} 
UIButton *createButton(NSString *title,id target, SEL action){
    CGSize size = [title sizeWithFont:gButtonFont];
    CGRect rect = CGRectMake(0,0,size.width+10,size.height+10);
    UIButton *btn = [[[UIButton alloc] initWithFrame:rect] autorelease];
    [btn setTitle:title forState:UIControlStateNormal];
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
@implementation UIUtils

@end
