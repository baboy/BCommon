    //
//  TabBarMoreViewController.m
//  itv
//
//  Created by Zhang Yinghui on 11-12-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarMoreViewController.h"

@implementation TabBarMoreViewController
@synthesize items = _items;
@synthesize tableView = _tableView;
- (id) init{
	if (self = [super init]) {
        UITabBarItem *tabItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:5] autorelease];
        [tabItem setTitle:NSLocalizedString(@"more", nil)];
        [self setTabBarItem:tabItem];
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	_tableView = [[TableView alloc] initWithFrame:_frame style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items?[_items count]:0;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    TabBarMoreItem *item = [_items objectAtIndex:indexPath.row];
    [cell.imageView setImage:nil];
    [_tableView loadImg:item.icon forIndexPath:indexPath];
    return  cell;
}
- (void)cacheImage:(NSString *)imgLocalPath forIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell.imageView setImage:[UIImage imageWithContentsOfFile:imgLocalPath]];
    }
}
- (void)dealloc {
    RELEASE(_items);
    [super dealloc];
}
@end


@implementation TabBarMoreItem
@synthesize controller = _controller;
@synthesize title = _title;
@synthesize icon = _icon;
- (void)dealloc{
    RELEASE(_controller);
    RELEASE(_icon);
    RELEASE(_title);
    [super dealloc];
}
@end
