//
//  BTableHeaderDragView.h
//  iLook
//
//  Created by Zhang Yinghui on 11-8-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
	DragDropStateUnInit=0,
	DragDropStatePulling,
	DragDropStatePullBeyond,
	DragDropStateRelease,
	DragDropStateLoading,
	DragDropStateLoadOk,
	DragDropStateLoadError
};
@interface BTableDragView : UIView {
	@private
	UILabel*                  _updatedLabel;
	UILabel*                  _stateLabel;
	UIImageView*              _arrowImg;
	UIActivityIndicatorView*  _indicatorView;
	BOOL						  _isFlipped;
	int						  _state;
	BOOL						  _arrowUp;
}
@property (nonatomic, assign) int state;
- (id) initWithFrame:(CGRect)frame toUp:(BOOL)toUp;
- (float)visibleHeight;
@end
