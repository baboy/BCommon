//
//  BTableLoadMoreView.h
//  itv
//
//  Created by Zhang Yinghui on 11-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTableLoadMoreView : UIButton {
	UILabel*                  _label;
	UIActivityIndicatorView*  _indicatorView;
	id						_target;
	SEL						_action;
}
@property (nonatomic, assign) int state;
- (void) start;
- (void) stop;
- (BOOL) isLoading;
@end
