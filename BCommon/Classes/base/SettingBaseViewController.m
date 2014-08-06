//
//  SettingBaseViewController.m
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SettingBaseViewController.h"

@interface SettingBaseViewController ()

@end

@implementation SettingBaseViewController
- (void)dealloc{
    RELEASE(_sections);
    [super dealloc];
}
- (void)setConfig:(NSString *)confFile{
    NSArray *list = [NSMutableArray arrayWithContentsOfFile:getBundleFile(confFile)];
    [self setSections:list];
}
#pragma mark -- UITableViewDataSource and Delegate
- (id)configOfIndexPath:(NSIndexPath *)indexPath{
    id data = [self.sections objectAtIndex:indexPath.section];
    NSArray *list = [data valueForKey:@"list"];
    NSDictionary *conf = [list objectAtIndex:indexPath.row];
    return conf;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id data = [self.sections objectAtIndex:section];
    NSArray *list = [data valueForKey:@"list"];
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id conf = [self configOfIndexPath:indexPath];
    float h = [conf isKindOfClass:[NSDictionary class]] ? [[conf valueForKey:@"cell-height"] floatValue] : 0;
    return h>0?h:44;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id data = [self.sections objectAtIndex:section];
    NSString *title = [data valueForKey:@"title"];
    if (!title || title.length==0) {
        return 0;
    }
    return 32;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [self configOfIndexPath:indexPath];
    NSString *cellID = [data valueForKey:@"cell"];
    NSString *title = [data valueForKey:@"title"];
    NSString *icon = [data valueForKey:@"icon"];
    int tag = [[data valueForKey:@"tag"] intValue];
    NSString *tapAction = [data valueForKey:@"tap-accessory-action"];
    NSString *loadAction = [data valueForKey:@"load-action"];
    NSString *accessory = [data valueForKey:@"accessory"];
    id cell = nil;
    if (cellID) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [self loadViewFromNibNamed:cellID];
        }
        if ([cell respondsToSelector:@selector(titleLabel)] && [title length]>0) {
            [[cell titleLabel] setText:title];
        }
        if ([cell respondsToSelector:@selector(imgView)] && [icon length]>0) {
            [[cell imgView] setImage:[UIImage imageNamed:icon]];
            UIImage *highlightedImage = [UIImage highlightedImageNamed:icon];
            if (highlightedImage) {
                [[cell imgView] setHighlightedImage:highlightedImage];
            }
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            [cell textLabel].font = [UIFont systemFontOfSize:14];
            TableViewCellBackground *background = [[TableViewCellBackground alloc] initWithFrame:[cell bounds]];
            background.backgroundColor = [UIColor whiteColor];
            [cell setBackgroundView:background];
        }
        [cell textLabel].text = title;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (accessory) {
        CGRect accessoryFrame = CGRectMake(0, 0, 60, 24);
        id accessoryView = [[NSClassFromString(accessory) alloc] initWithFrame:accessoryFrame];
        [accessoryView setTag:tag];
        [cell setAccessoryView:accessoryView];
        if ([accessoryView isKindOfClass:[UIControl class]] && tapAction) {
            [(UIControl*)accessoryView addTarget:self action:NSSelectorFromString(tapAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (loadAction) {
        SEL selector = NSSelectorFromString(loadAction);
        IMP imp = [self methodForSelector:selector];
        void (*f)(id, SEL,id) = (void *)imp;
        f(self, selector,cell);
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [cell performSelector:@selector(setDelegate:) withObject:self afterDelay:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id data = [self configOfIndexPath:indexPath];
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *tapAction = [data valueForKey:@"tap-action"];
    NSString *controller = [data valueForKey:@"controller"];
    if (controller) {
        [self openController:controller];
        return;
    }
    if (tapAction) {
        [self performSelector:NSSelectorFromString(tapAction) withObject:indexPath afterDelay:0];
    }
}
- (void)openController:(NSString *)controller{
    Class clazz = NSClassFromString(controller);
    if (clazz) {
        id vc = [[clazz alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
