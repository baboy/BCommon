//
//  TableCell.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/8/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize titleLabel = _titleLabel;
@synthesize introLabel = _introLabel;
@synthesize imgView = _imgView;
- (void)dealloc{
    RELEASE(_imgView);
    RELEASE(_titleLabel);
    RELEASE(_introLabel);
    [super dealloc];
}
- (void)setIntro:(NSString *)intro{
    [_introLabel setText:intro];
}
- (void)setImage:(UIImage *)image{
    [self setImg:image];
}
- (void)setImg:(UIImage *)image{
    DLOG(@"[TableCell]setImage:%@,%@",_imgView,image);
    [_imgView setImage:image];
}
- (void)setTitle:(NSString *)title{
    [_titleLabel setText:title];
}
@end
