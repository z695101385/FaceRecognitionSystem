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
    
//    [bar setBackgroundColor:[UIColor redColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
// 
//    NSMutableDictionary *attrDisabledDict = [NSMutableDictionary dictionary];
//    attrDisabledDict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    attrDisabledDict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [item setTitleTextAttributes:attrDisabledDict forState:UIControlStateHighlighted];
//    
//    
//    NSMutableDictionary *attrNormalDict = [NSMutableDictionary dictionary];
//    attrNormalDict[NSForegroundColorAttributeName] = [UIColor blackColor];
//    attrNormalDict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [item setTitleTextAttributes:attrNormalDict forState:UIControlStateNormal];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //屏幕边缘滑动返回功能
    //由于自定义了导航栏左边按钮，所以导致边缘滑动返回失效。
    //清空代理可以重新实现该功能
    self.interactivePopGestureRecognizer.delegate = nil;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [button sizeToFit];
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
