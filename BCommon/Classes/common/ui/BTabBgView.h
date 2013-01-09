//
//  BTabBgView.h
//  iLook
//
//  Created by Zhang Yinghui on 7/11/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTabBgView : UIView {
	UIColor *borderColor;
	UIColor *bgColor;
	float borderWidth;
	id _target;
	SEL _action;
}
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, assign) float borderWidth;

- (void) addTarget:(id)target action:(SEL)action;
@end
