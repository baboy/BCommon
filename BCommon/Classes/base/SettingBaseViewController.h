//
//  SettingBaseViewController.h
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//


@interface SettingBaseViewController : BaseTableViewController

@property (nonatomic, retain) NSArray *sections;
- (void)openController:(NSString *)controller;
- (id)configOfIndexPath:(NSIndexPath *)indexPath;
- (void)setConfig:(NSString *)confFile;
@end
