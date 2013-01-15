//
//  UIColor+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 7/16/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "UIColor+x.h"

@implementation UIColor(x)

+ (UIColor *)colorFromString:(NSString *)s{
    if(!s || ![s isKindOfClass:[NSString class]])
        return [UIColor blackColor];
    NSString *cString = [[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6) 
        return [UIColor blackColor];
    if ([cString hasPrefix:@"#"]) 
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && [cString length] != 8) 
        return [UIColor blackColor];
    
    NSRange range = {0,2};
    NSString *alphaString = @"FF";
    if ( [cString length] == 8 ) {
        alphaString = [cString substringWithRange:range];
        range.location += range.length;
    }
    
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location += range.length;
    NSString *gString = [cString substringWithRange:range];
    
    range.location += range.length;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
