//
//  TabBarMoreViewController.h
//  itv
//
//  Created by Zhang Yinghui on 11-12-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "TableView.h"
#import "XUIViewController.h"

@interface TabBarMoreItem:NSObject
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIViewController *controller;
@end
@interface TabBarMoreViewController : XUIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) TableView *tableView;
@property (nonatomic, retain) NSArray *items;
@end
