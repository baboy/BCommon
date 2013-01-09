//
//  TableCell.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/8/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
@property (nonatomic, retain)IBOutlet UIImageView *imgView;
@property (nonatomic, retain)IBOutlet UILabel *titleLabel;
@property (nonatomic, retain)IBOutlet UILabel *introLabel;
- (void)setImg:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setIntro:(NSString *)intro;
@end
