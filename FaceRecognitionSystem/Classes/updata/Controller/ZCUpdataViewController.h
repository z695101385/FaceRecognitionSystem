//
//  ZCUpdataViewController.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/11.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCUpdataViewController : UIViewController

/** feature */
@property (nonatomic, copy) NSString *feature;

/** image */
@property (nonatomic, weak) UIImage *image;

+ (instancetype)controllerWithFeature:(NSString *)feature image:(UIImage *)image;

@end
