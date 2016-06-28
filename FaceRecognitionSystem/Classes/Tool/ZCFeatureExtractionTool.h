//
//  ZCFeatureExtractionTool.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/24.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCFeatureExtractionTool : NSObject

/** faceImage */
@property (nonatomic, strong, readonly) UIImage *faceImage;

- (instancetype)initWithFaceImage:(UIImage *)image;

- (NSArray *)featureExtraction;

@end
