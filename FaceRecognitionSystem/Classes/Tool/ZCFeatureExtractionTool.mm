//
//  ZCFeatureExtractionTool.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/24.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCFeatureExtractionTool.h"
#import "opencv2/opencv.hpp"
#import "SVProgressHUD.h"

@interface ZCFeatureExtractionTool ()

@property(nonatomic) IplImage *IplImage;

@end

@implementation ZCFeatureExtractionTool

- (NSString *)featureExtractUseMethod:(ZCFeatureExtractMethod)method
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"特征提取中..."];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    if (_IplImage) {
        
        NSString *fea = nil;
        
        switch (method) {
            case 0:
                fea = [self LBP];
                break;
            case 1:
                fea = [self MLBP];
                break;
            default:
                [SVProgressHUD showErrorWithStatus:@"错误的方法！！"];
                return fea;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"特征提取完成！"];
        return fea;
    }
    [SVProgressHUD showErrorWithStatus:@"图像未找到！！"];
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

- (NSString *)LBP
{
    NSMutableString *fea = [NSMutableString stringWithString:@"FEA_LBP"];
    
    
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
            
            [fea appendFormat:@"_%d",temp];
        }
    }
    
    return [fea copy];
}

//int HistogramBlock = 59;
//float HistogramRange1[2]={0,255};
//float *HistogramRange[1]={&HistogramRange1[0]};

- (NSString *)MLBP
{
    NSMutableString *fea = [NSMutableString stringWithString:@"FEA_MLBP"];
    
    int hist[256];
    
    for (int i = 0; i < 256; i++) {
        hist[i] = 0;
    }
    
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
            
            if (i >= 16 && i<= 63 && j >= 16 && j <= 47) {
                [fea appendFormat:@"_%d",temp];
            } else {
                hist[temp] += 1;
            }
        }
    }
    
    for (int i = 0; i < 256; i++) {
        [fea appendFormat:@"_%d",hist[i]];
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
