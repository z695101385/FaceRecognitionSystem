//
//  ZCNavigationController.m
//  百思不得姐
//
//  Created by 张晨 on 16/6/28.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCNavigationController.h"

@implementation ZCNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTintColor:[UIColor blackColor]];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
