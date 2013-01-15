//
//  XScrollView.h
//  Pods
//
//  Created by baboy on 1/15/13.
//
//

#import <UIKit/UIKit.h>
enum DragState{
	DragStateUnInit=0,
	DragStateDraging,
	DragStateDragBeyond,
	DragStateRelease,
	DragStateLoading,
	DragStateLoadFinished,
	DragStateLoadError
};
typedef int DragState;

enum DragLocation {
    DragLocationTop ,
    DragLocationBottom
};
typedef int DragLocation;


@interface DragView : UIView
@property (nonatomic, assign) DragState state;
@property (nonatomic, assign) DragLocation location;
@end

@interface XScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign, getter = isSupportLoadMore) BOOL supportLoadMore;
@property (nonatomic, assign, getter = isSupportUpdate) BOOL supportUpdate;
- (void) startUpdate;
- (void) startLoadMore;
@end

@protocol XScrollViewDelegate <NSObject>
@optional
- (void)update:(XScrollView *)scrollView;
- (void)loadMore:(XScrollView *)scrollView;
@end