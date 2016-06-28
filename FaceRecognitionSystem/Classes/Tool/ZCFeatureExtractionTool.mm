//
//  ZCFeatureExtractionTool.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/24.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCFeatureExtractionTool.h"
#import "opencv2/opencv.hpp"

@interface ZCFeatureExtractionTool ()

@property(nonatomic) IplImage *IplImage;

@end

@implementation ZCFeatureExtractionTool

- (NSArray *)featureExtraction
{
    if (_IplImage) {
        
        NSArray *fea = [self LBP];
        NSLog(@"%@",fea);
        return fea;
    }
    
    return nil;
}

-(void)setFaceImage:(UIImage *)faceImage
{
    cvSetErrMode(CV_ErrModeParent);
    
    _faceImage = faceImage;
    
    CGImageRef imageRef = faceImage.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    IplImage *iplimage = cvCreateImage(cvSize(faceImage.size.width, faceImage.size.height), IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, faceImage.size.width, faceImage.size.height), imageRef);
    
    CGContextRelease(contextRef);
    
    CGColorSpaceRelease(colorSpace);
    
    IplImage *grayImg = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 1); //先转为灰度图
    
    cvCvtColor(iplimage, grayImg, CV_BGRA2GRAY);
    
    _IplImage = cvCreateImage(cvSize(64,64), IPL_DEPTH_8U, 1);
    
    cvResize(grayImg, _IplImage);
    
    cvReleaseImage(&grayImg);
    cvReleaseImage(&iplimage);
}

- (instancetype)initWithFaceImage:(UIImage *)image
{
    
    self.faceImage = image;
    
    return self;
}

- (void)dealloc
{
    cvReleaseImage(&_IplImage);
}

- (NSArray *)LBP
{
    NSMutableArray *fea = [NSMutableArray array];
    for(int j = 1; j < _IplImage->width - 1; j++)
    {
        for(int i = 1; i < _IplImage->height - 1; i++)
        {
            uchar neighborhood[8] = {0};
            neighborhood[7] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j-1);
            neighborhood[6] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j);
            neighborhood[5] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j+1);
            neighborhood[4] = CV_IMAGE_ELEM(_IplImage, uchar, i, j-1);
            neighborhood[3] = CV_IMAGE_ELEM(_IplImage, uchar, i, j+1);
            neighborhood[2] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j-1);
            neighborhood[1] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j);
            neighborhood[0] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j+1);
            uchar center = CV_IMAGE_ELEM( _IplImage, uchar, i, j);
            uchar temp=0;
            
            for(int k=0;k<8;k++)
            {
                temp += (neighborhood[k] >= center)<<k;
            }
            
            [fea addObject:@(temp)];
        }
    }
    
    return [fea copy];
}

void LBP(IplImage* src, IplImage* dst)
{
    int width=src->width;
    int height=src->height;
    for(int j=1;j<width-1;j++)
    {
        for(int i=1;i<height-1;i++)
        {
            uchar neighborhood[8]={0};
            neighborhood[7] = CV_IMAGE_ELEM( src, uchar, i-1, j-1);
            neighborhood[6] = CV_IMAGE_ELEM( src, uchar, i-1, j);
            neighborhood[5] = CV_IMAGE_ELEM( src, uchar, i-1, j+1);
            neighborhood[4] = CV_IMAGE_ELEM( src, uchar, i, j-1);
            neighborhood[3] = CV_IMAGE_ELEM( src, uchar, i, j+1);
            neighborhood[2] = CV_IMAGE_ELEM( src, uchar, i+1, j-1);
            neighborhood[1] = CV_IMAGE_ELEM( src, uchar, i+1, j);
            neighborhood[0] = CV_IMAGE_ELEM( src, uchar, i+1, j+1);
            uchar center = CV_IMAGE_ELEM( src, uchar, i, j);
            uchar temp=0;
            
            for(int k=0;k<8;k++)
            {
                temp+=(neighborhood[k]>=center)<<k;
            }
            CV_IMAGE_ELEM( dst, uchar, i, j)=temp;
        }
    }  
}

@end
