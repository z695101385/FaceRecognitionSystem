//
//  ZCViewController.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/5/26.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCViewController.h"

@interface ZCViewController ()

@end

@implementation ZCViewController

+ (void)initialize
{
    //设置UITabBarItem富文本属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selAttrs = [NSMutableDictionary dictionary];
    selAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selAttrs forState:UIControlStateHighlighted];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
