//
//  SuspendButton.h
//  SuspendButton
//
//  Created by yulong mei on 16/9/22.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 代理按钮点击事件
 */
@protocol SuspendButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;

@end

@interface SuspendButton : UIButton

//悬浮按钮所依赖的跟视图
@property (strong,nonatomic)UIView *rootView;

@property (weak,nonatomic)id <SuspendButtonDelegate>buttonDelegate;

@end
