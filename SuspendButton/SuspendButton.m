//
//  SuspendButton.m
//  SuspendButton
//
//  Created by yulong mei on 16/9/22.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

#import "SuspendButton.h"
#import "AppDelegate.h"

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
    
    _startPos = [self converDir:_startPos];
}

//手指按住移动过程，通过悬浮按钮的拖动事件来拖动整个悬浮窗口
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //获取图中跟视图的坐标
    UITouch *touch = [touches anyObject];
    
    //移动按钮到当前触摸位置
    self.superview.center = [self converDir:[touch locationInView:_rootView]];
}

//拖动结束后是悬浮窗口吸附在最近的屏幕边缘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint curPoint = [touch locationInView:_rootView];
    
    curPoint = [self converDir:curPoint];
    
    //通知代理，如果结束触点和起始点极近就认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y), 2) <1) {
        
        [self.buttonDelegate dragButtonClicked:self];
        
        return;//点击后不动
    }
    
    //由于计算吸附时，坐标要转换到手机竖直状态不旋转的坐标系，因此要保障屏幕宽度是竖直状态的快读，高度也是竖直状态的高度，不随屏幕的旋转二变化
    //获取屏幕的方向
    UIInterfaceOrientation  orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat W = Screen_Width;
    CGFloat H = Screen_Hight;
    if (orientation == UIInterfaceOrientationLandscapeLeft ||  orientation == UIInterfaceOrientationLandscapeRight) {
        
        W = Screen_Hight;
        H = Screen_Width;
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
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            
            }];
            
            break;
        }
        case Right:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(Screen_Width - self.superview.frame.size.width/2, self.superview.center.y);
            }];
            
            break;
        }
        case Top:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
            self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            }];
            break;
        }
        case Bottom:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
            self.superview.center = CGPointMake(self.superview.center.x, Screen_Hight - self.superview.frame.size.height/2);
            }];
            break;
        }
        default:
            break;
    }
}

//屏幕颠倒时坐标交换
- (CGPoint)UpsideDown:(CGPoint)p{
    
    return CGPointMake(Screen_Width - p.x, Screen_Hight - p.y);
}

//屏幕左转时坐标交换
- (CGPoint)LandScapeLeft:(CGPoint)p{
    
    return CGPointMake(p.y, Screen_Width - p.x);
}

//屏幕右转时坐标交换
- (CGPoint)LandScapeRight:(CGPoint)p{
    
    return CGPointMake(Screen_Hight - p.y,p.x);
}

//坐标交换，转换到屏幕旋转之前的坐标系中
- (CGPoint)converDir:(CGPoint)p{
    
    //获取屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return [self LandScapeLeft:p];
            break;
        case UIInterfaceOrientationLandscapeRight:
            return [self LandScapeRight:p];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return [self UpsideDown:p];
            break;
        default:
            return p;
            break;
    }
}

@end
