//
//  ViewController.m
//  SuspendButton
//
//  Created by yulong mei on 16/9/22.
//  Copyright © 2016年 yulong mei. All rights reserved.
//

#import "ViewController.h"
#import "SupendViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SupendViewController *suspend = [[SupendViewController alloc]init];
    
    [self addChildViewController:suspend];
    [self.view addSubview:suspend.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
