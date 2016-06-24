//
//  ZCFaceDeteController.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/2.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^serUpImage)(UIImage *image);

@interface ZCFaceDeteController : UIViewController

/** block */
@property (nonatomic, strong) serUpImage block;

+ (instancetype)ControllerWithImage:(UIImage *)image;

@end
