//
//  TableCell.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/8/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
- (void)dealloc{
    RELEASE(_object);
    RELEASE(_imgView);
    RELEASE(_titleLabel);
    RELEASE(_detailLabel);
    [super dealloc];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //DLOG(@"[TableCell] setFrame:%@", NSStringFromCGRect(frame));
}
- (void)setDetail:(NSString *)text{
    [self.detailTextLabel setText:text];
}
- (void)setImg:(UIImage *)image{
    [_imgView setImage:image];
}
- (void)setImgFilePath:(NSString *)imgFilePath{
    [_imgView setImage:[UIImage imageWithContentsOfFile:imgFilePath]];
}
- (void)setTitle:(NSString *)title{
    [_titleLabel setText:title];
}
- (void)setImageViewHidden:(BOOL)imageHidden{
    CGFloat x = self.imgView.frame.origin.x + self.imgView.frame.size.width+5;
    CGFloat w = self.bounds.size.width - 60;
    CGRect titleFrame = self.titleLabel.frame;
    CGRect detailFrame = self.detailLabel.frame;
    
    titleFrame.origin.x = imageHidden?self.imgView.frame.origin.x:x;
    titleFrame.size.width = imageHidden?w:(w - self.imgView.frame.origin.x);
    detailFrame.origin.x = titleFrame.origin.x;
    detailFrame.size.width = titleFrame.size.width;
    self.titleLabel.frame = titleFrame;
    self.detailLabel.frame = detailFrame;
    
    self.imgView.hidden = imageHidden;
}
@end
