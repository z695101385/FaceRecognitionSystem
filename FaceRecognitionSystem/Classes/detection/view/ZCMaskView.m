//
//  ZCMaskView.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/2.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCMaskView.h"
#define ZCMargin 70

@implementation ZCMaskView

- (void)setUp
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.path = path.CGPath;
    
    self.layer.mask = layer;
}


@end
