//
//  XScrollView.h
//  Pods
//
//  Created by baboy on 1/15/13.
//
//

#import <UIKit/UIKit.h>
enum {
	DragStateUnInit = 0,
	DragStateDraging,
	DragStateDragBeyond,
	DragStateRelease,
	DragStateLoading,
	DragStateLoadFinished,
	DragStateLoadError
};
typedef int DragState;

enum  {
    DragLocationTop ,
    DragLocationBottom
};
typedef int DragLocation;


@interface DragView : UIView
@property (nonatomic, assign) DragState state;
@property (nonatomic, assign) DragLocation location;
- (float)activeHeight;
@end

@interface XScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign, getter = isSupportLoadMore) BOOL supportLoadMore;
@property (nonatomic, assign, getter = isSupportUpdate) BOOL supportUpdate;
- (void) startUpdate;
- (void) startLoadMore;
- (void) updateFinished;
@end

@protocol XScrollViewDelegate <NSObject>
@optional
- (void)update:(id)scrollView;
- (void)loadMore:(id)scrollView;
@end