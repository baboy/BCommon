//
//  XUILabel.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/6/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum LabelVerticalAlignment {
    LabelVerticalAlignmentTop,
    LabelVerticalAlignmentMiddle,
    LabelVerticalAlignmentBottom,
} LabelVerticalAlignment;

@interface XUILabel : UILabel
@property (nonatomic, assign) LabelVerticalAlignment verticalAlignment;
@property (nonatomic, retain) NSString *caption;

@end
