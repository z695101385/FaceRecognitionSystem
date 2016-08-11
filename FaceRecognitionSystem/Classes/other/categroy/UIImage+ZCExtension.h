//
//  UIImage+ZCExtension.h
//
//
//  Created by zhangchen on 16/6/19.
//  Copyright (c) 2016年 张晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 圆形裁剪
+ (UIImage *)zc_imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

// 控件截屏
+ (UIImage *)zc_imageWithCaputureView:(UIView *)view;

// 快速的返回一个最原始的图片
+ (instancetype)zc_imageWithOriRenderingImageNamed:(NSString *)imageName;
- (UIImage *)zc_oriRenderingImage;

//返回圆形图片
- (UIImage *)zc_circleImage;
- (UIImage *)zc_cornerImageWithCornerRadius:(CGFloat)cornerRadius;
@end
