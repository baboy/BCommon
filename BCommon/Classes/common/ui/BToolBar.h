//
//  BToolBar.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/5/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum BToolBarStyle{
    BToolBarStyleDefault,
    BToolBarStyleBlackTranslucent,
    BToolBarStyleBlue,
    BToolBarStyleTranslucent
}BToolBarStyle;
@interface BToolBar : UIView
@property (nonatomic, assign) BToolBarStyle style;
@end
