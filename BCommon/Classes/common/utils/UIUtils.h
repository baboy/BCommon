//
//  UIUtils.h
//  itv
//
//  Created by Zhang Yinghui on 9/24/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    CustomButtonStyleDefault,
    CustomButtonStyle1,
    CustomButtonStyle2,
    CustomButtonStyle3,
    CustomButtonStyle4
};
extern UIView *loadViewFromNib(Class nibClass,id owner);

extern UILabel * createLabel(CGRect frame,UIFont *font,UIColor *bg,UIColor *textColor,UIColor *shadow,CGSize shadowSize,int textAlign,int numOfLines,int lineBreakMode);

extern UIButton * createCustomButton(CGRect rect,NSString *title,UIColor *titleColor,UIColor *titleShadowColor,NSString *imgName,NSString *imgName2);
extern UIButton * createStyleButton(CGRect rect,NSString *title,int style);
extern UIBarButtonItem * createBarButtonItem(NSString *title,id target,SEL action);
extern UIBarButtonItem * createBarImageButtonItem(NSString *iconName,id target,SEL action);
extern UIButton *createButton(NSString *title,id target, SEL action);
extern UIButton * createRoundCornerButton(CGRect rect,NSString *title,id target, SEL actionb);
extern UIButton * createImgBarButton(CGRect rect,NSString *title,NSString *imgName);
extern UIButton * createImgButton(CGRect rect,NSString *imgName);
extern UIButton * createColorizeImgButton(CGRect rect,NSString *imgName,UIColor *color);
extern UIButton * createPlayButton(CGRect rect,id target,SEL action);
extern CGSize CGSizeScale(CGSize size,float scale);
UIImage *createButtonCircleBg(CGSize size,float rad,UIColor *borderColor,UIColor *color1,UIColor *color2,UIColor *color3,UIColor *color4);
@interface UIUtils : NSObject {

}

@end
