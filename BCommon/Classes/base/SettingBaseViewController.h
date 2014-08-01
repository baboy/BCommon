//
//  SettingBaseViewController.h
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "AppBaseTableViewController.h"

@interface SettingBaseViewController : AppBaseTableViewController

@property (nonatomic, strong) NSArray *sections;
- (void)openController:(NSString *)controller;
- (id)configOfIndexPath:(NSIndexPath *)indexPath;
@end
