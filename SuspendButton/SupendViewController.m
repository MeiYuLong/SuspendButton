//
//  SupendViewController.m
//  SuspendButton
//
//  Created by yulong mei on 16/9/22.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

// 屏幕高度
#define ScreenH [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define ScreenW [[UIScreen mainScreen] bounds].size.width
// 悬浮按钮的尺寸
#define floatSize 50


#import "SupendViewController.h"
#import "SuspendButton.h"

@interface SupendViewController ()<SuspendButtonDelegate>

//悬浮的window
@property (strong,nonatomic)UIWindow *window;

//悬浮按钮
@property (strong,nonatomic)SuspendButton *button;

@end

@implementation SupendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置视图尺寸为0，防止阻碍其它视图元素的交互
    self.view.frame = CGRectZero;
    
    //延时显示悬浮按钮
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
    
}

//创建悬浮按钮
- (void)createButton{
    
    _button = [SuspendButton buttonWithType:UIButtonTypeCustom];
    
    [_button setImage:[UIImage imageNamed:@"image.jpg"] forState:UIControlStateNormal];
    
    _button.imageView.contentMode = UIViewContentModeScaleToFill;
    
    _button.frame  =CGRectMake(0, 0, floatSize, floatSize);
    
    //按钮点击事件代理
    _button.buttonDelegate = self;
    
    _button.selected = NO;
    
    //取消高粱状态
    _button.adjustsImageWhenHighlighted = NO;
    
    _button.rootView = self.view.superview;
    
    
    //悬浮窗
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenW-floatSize, ScreenH/2, floatSize, floatSize)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor orangeColor];
    _window.layer.cornerRadius = floatSize/2;
    _window.layer.masksToBounds = YES;
    
    [_window addSubview:_button];
    
    //显示window
    [_window makeKeyAndVisible];
    
}

//点击事件
- (void)dragButtonClicked:(UIButton *)sender{
    
    sender.selected =!sender.selected;
    
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        
        [sender setImage:[UIImage imageNamed:@"image.jpg"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
