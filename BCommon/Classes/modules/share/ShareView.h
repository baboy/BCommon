//
//  ShareView.h
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIView.h"
#import "ShareUtils.h"
@class ShareView;

enum  {
    ShareViewTypeShare,
    ShareViewTypeComment
};
typedef int ShareViewType;

@protocol ShareViewDelegate <NSObject>
@optional
- (BOOL)shareView:(ShareView *)shareView shouldSendContent:(NSString *)content withImagePath:(NSString *)imagePath;

@end

@interface ShareView : XUIView
@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) BOOL showCountLabel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL autoSend;
@property (nonatomic, assign) ShareViewType shareViewType;
@property (nonatomic, retain) SharePlatform *sharePlatform;

+ (id)shareView;
- (void)show;
- (void) setTitle:(NSString *)title;
- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;

@end
