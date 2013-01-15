//
//  XUIWebView.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/16/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "XUIWebView.h"

@implementation XUIWebView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Share", nil) action:@selector(share:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:shareItem, nil]];
    [shareItem release];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ( [UIMenuController sharedMenuController] == sender && (action == @selector(copy:) || action == @selector(share:)) )
        return YES;
    return [super canPerformAction:action withSender:sender];
}
- (void)share:(id)sender{
    if (self.delegate && [self.delegate  respondsToSelector:@selector(shareWithText:)]) {
        [self copy:sender];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [self.delegate performSelector:@selector(shareWithText:) withObject:pb.string];
    }
}
@end
