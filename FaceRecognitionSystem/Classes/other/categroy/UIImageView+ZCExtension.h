//
//  UIImageView+ZCExtension.h
//  百思不得姐
//
//  Created by 张晨 on 2016/7/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZCExtension)
//基于SDWebImage,设置网络图片
- (void)zc_setIcon:(NSString *)url placeholder:(NSString *)placeholder;

@end
