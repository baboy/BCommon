//
//  AppBaseViewController.m
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (NSArray *)getInputCheckConfig{
    return nil;
}
- (BOOL)checkInput{
    return [self checkInput:[self getInputCheckConfig]];
}
- (BOOL)checkInput:(NSArray *)config{
    
    NSArray* confs = config;
    for (NSDictionary *conf in confs) {
        UITextField *field = [conf valueForKey:@"field"];
        NSString *name = [conf valueForKey:@"name"];
        int minLen = [[conf valueForKey:@"min-len"] intValue];
        int maxLen = [[conf valueForKey:@"max-len"] intValue];
        NSString *regex = [conf valueForKey:@"regex"];
        NSString *regex_desc = [conf valueForKey:@"regex-desc"];
        NSString *val = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *errMsg = nil;
        if (regex && ![val testRegex:regex]) {
            errMsg = [NSString stringWithFormat:@"%@格式错误", name];
            if (regex_desc) {
                errMsg = [NSString stringWithFormat:@"%@,%@",errMsg, regex_desc];
            }
        }else if ([val length] == 0) {
            errMsg = [NSString stringWithFormat:@"%@不能为空",name];
        }else if ([val length] < minLen) {
            errMsg = [NSString stringWithFormat:@"%@长度不能小于%d位",name,minLen];
        }else if ( maxLen > 0 && [val length]>maxLen ){
            errMsg = [NSString stringWithFormat:@"%@长度不能大于%d位",name,maxLen];
        }
        if (errMsg) {
            [self alert:errMsg];
            [field becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}


@end
