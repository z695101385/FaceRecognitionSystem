//
//  UIView+Frame.h
//
//
//  Created by zhangcehn on 16/6/26.
//  Copyright (c) 2016年 张晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZCExtension)


// 分类里面不能生成成员属性
// 会自动生成get，set方法和成员属性

// @property如果在分类里面只会生成get,set方法的声明，并不会生成成员属性。

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
/** 判断一个控件是否真正显示在主窗口 */
@property (nonatomic, assign, readonly) BOOL zc_isShowingOnKeyWindow;

/**
 *  通过Nib创建View
 */
+ (instancetype)zc_viewFromNib;

- (UIViewController *)currentController;

@end
