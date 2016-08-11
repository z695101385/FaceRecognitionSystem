//
//  UIBarButtonItem+ZCExtension.h
//  百思不得姐
//
//  Created by 张晨 on 16/6/28.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZCExtension)

+ (instancetype)zc_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
