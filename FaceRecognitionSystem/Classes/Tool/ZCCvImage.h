//
//  ZCCvImage.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//



#import <UIKit/UIKit.h>



@interface ZCCvImage : NSObject

/** uiimage */
@property (nonatomic, strong) UIImage *image;
/** index */
@property (nonatomic, assign) int index;
/** faceNumber */
@property (nonatomic, assign) NSInteger numberOfFace;
/** ROIRect */
@property (nonatomic) CGRect ROI;
/** ROIImage */
@property (nonatomic, strong) UIImage *ROIImage;
/** roiImageScale */
@property (nonatomic, assign) CGFloat scaleW;
/** roiImageScale */
@property (nonatomic, assign) CGFloat scaleH;

+ (instancetype)cvImageWithUIImage:(UIImage *)image;

- (UIImage *)imageOfFaceDetec;

- (CGRect)ROIRectOfFaceDetec;

- (UIImage *)imageOfLastFace;

- (CGRect)ROIRectOfLastFace;

- (UIImage *)imageOfNextFace;

- (CGRect)ROIRectOfNextFace;

@end
