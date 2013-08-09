//
//  AppBaseTableViewController.m
//  iShow
//
//  Created by baboy on 13-3-18.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)dealloc{
    [self.tableView setDelegate:nil];
    RELEASE(_tableView);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tableStyle = UITableViewStylePlain;
    }
    return self;
}
- (id)init{
    if(self = [super init]){
        self.tableStyle = UITableViewStylePlain;
    }
    return self;
}
- (void)reset{
    [super reset];
    self.tableView = nil;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if (!self.tableView) {
        self.tableView = AUTORELEASE([[TableView alloc] initWithFrame:_frame style:self.tableStyle]);
        self.tableView.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self.view addSubview:_tableView];
    }
}
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView scrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
