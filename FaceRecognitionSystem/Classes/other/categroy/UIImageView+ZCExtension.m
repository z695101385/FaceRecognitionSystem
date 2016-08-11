//
//  UIImageView+ZCExtension.m
//  百思不得姐
//
//  Created by 张晨 on 2016/7/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "UIImageView+ZCExtension.h"
#import "UIImage+ZCExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (ZCExtension)

- (void)zc_setIcon:(NSString *)url placeholder:(NSString *)placeholderStr
{
    UIImage *placeholder = [[UIImage imageNamed:placeholderStr] zc_circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image zc_circleImage] : placeholder;
    }];
}

@end
