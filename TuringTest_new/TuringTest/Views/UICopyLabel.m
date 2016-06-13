//
//  UICopyLabel.m
//  TuringTest
//
//  Created by 刘小姐 on 16/6/13.
//  Copyright © 2016年 Zeng Haitao. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
//还需要针对复制的操作覆盖两个方法：
// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

//针对于响应方法的实现
-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}
//有了以上三个方法，我们就能处理copy了，当然，在能接收到事件的情况下：

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    
    [self addGestureRecognizer:longPress];
    
}
//绑定事件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self attachTapHandler];
    }
    return self;
}
//同上
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleLongPress:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
//拷贝不用加，是默认的
    [[UIMenuController sharedMenuController] setMenuItems: nil];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}
@end
