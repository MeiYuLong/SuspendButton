//
//  SuspendButton.m
//  SuspendButton
//
//  Created by yulong mei on 16/9/22.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

#import "SuspendButton.h"

#define Screen_Hight [[UIScreen mainScreen] bounds].size.height//屏高

#define Screen_Width [[UIScreen mainScreen] bounds].size.width //屏宽

@interface SuspendButton ()

@property (assign,nonatomic)CGPoint startPos;//开始按下的触点坐标

@end

@implementation SuspendButton

typedef enum{
    
    Left,
    Right,
    Top,
    Bottom
}Dir;

/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //获取触摸在跟视图中的坐标
    UITouch *touch = [touches anyObject];
    
    _startPos = [touch locationInView:_rootView];
}

//手指按住移动过程，通过悬浮按钮的拖动事件来拖动整个悬浮窗口
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //获取图中跟视图的坐标
    UITouch *touch = [touches anyObject];
    
    //移动按钮到当前触摸位置
    self.superview.center = [touch locationInView:_rootView];
}

//拖动结束后是悬浮窗口吸附在最近的屏幕边缘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint curPoint = [touch locationInView:_rootView];
    
    //通知代理，如果结束触点和起始点极近就认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y), 2) <1) {
        
        [self.buttonDelegate dragButtonClicked:self];
        
        return;//点击后不动
    }
    
    CGFloat left = curPoint.x;
    CGFloat right = Screen_Width  - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = Screen_Hight -curPoint.y;
    
    //计算吸附方向
    Dir mindir = Left;
    
    CGFloat minDistance  = left;
    
    if (right < minDistance) {
        
        minDistance = right;
        
        mindir = Right;
    }
    if (top < minDistance) {
        
        minDistance = top;
        
        mindir = Top;
    }
    if (bottom <minDistance) {
        
        minDistance = bottom;
        
        mindir = Bottom;
    }
    
    //开始吸附
    switch (mindir) {
        case Left:
            
            self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            
            break;
            
        case Right:
            
            self.superview.center = CGPointMake(Screen_Width - self.superview.frame.size.width/2, self.superview.center.y);
            
            break;
        case Top:
            
            self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            
            break;
            
        case Bottom:
            
            self.superview.center = CGPointMake(self.superview.center.x, Screen_Hight - self.superview.frame.size.height/2);
            
            break;
            
        default:
            break;
    }
}

@end
