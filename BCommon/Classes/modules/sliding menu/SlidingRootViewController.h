//
//  RootViewController.h
//  iShow
//
//  Created by baboy on 13-3-17.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "IIViewDeckController.h"

@interface SlidingRootViewController : IIViewDeckController<IIViewDeckControllerDelegate>

- (void)pushViewController:(id)viewController animated:(BOOL)animated;
- (id)popViewControllerAnimated:(BOOL)animated;
@end
