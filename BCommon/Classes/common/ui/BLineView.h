//
//  LineView.h
//  iLook
//
//  Created by Zhang Yinghui on 7/1/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLineView : UIView {
	NSArray *_lines;
	float _lineWidth;
}
@property (nonatomic, retain) NSArray *lines;
@property (nonatomic, assign) float lineWidth;
- (id) initWithFrame:(CGRect)frame lines:(NSArray *)lines;
- (void) setColors:(NSArray *)colors;
@end
