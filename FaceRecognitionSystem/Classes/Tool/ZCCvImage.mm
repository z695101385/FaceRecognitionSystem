//
//  ZCCvImage.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//
#import "opencv2/opencv.hpp"
#import "ZCCvImage.h"

@interface ZCCvImage ()

@property(nonatomic) IplImage *IplImage;
/** RoiImage */
@property (nonatomic) IplImage *RoIImg;
/** scale */
@property (nonatomic, assign) float ZCScale;
/** faces */
@property (nonatomic) CvSeq *faces;
/** RoiRectArr */
@property (nonatomic, strong) NSMutableArray *RoiRectArr;

//@property(nonatomic) IplImage *DeteImage;


@end


@implementation ZCCvImage

- (NSMutableArray *)RoiRectArr
{
    if (_RoiRectArr == nil) {
        _RoiRectArr = [NSMutableArray array];
    }
    return _RoiRectArr;
}


+ (instancetype)cvImageWithUIImage:(UIImage *)image
{
    ZCCvImage *cvImage = [[self alloc] init];
    
    cvImage.image = image;
    
    cvImage.ROIImage = image;
    
    return cvImage;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    
    CGContextRelease(contextRef);
    
    CGColorSpaceRelease(colorSpace);
    
    _IplImage = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    
    cvCvtColor(iplimage, _IplImage, CV_RGBA2BGR);
    
    cvReleaseImage(&iplimage);
}

- (UIImage *)UIImageFromIplImage:(IplImage *)image
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    CGDataProviderRelease(provider);
    
    CGColorSpaceRelease(colorSpace);
    return ret;
}

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    
    CGContextRelease(contextRef);
    
    CGColorSpaceRelease(colorSpace);
    
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    
    cvCvtColor(iplimage, ret, CV_RGBA2RGB);
    
    cvReleaseImage(&iplimage);
    
    return ret;
}


//static CvSeq *faces;

- (void)setIndex:(int)index
{
    _index = index;
    if(_numberOfFace > 0)
    {
        CvRect cvrect = *(CvRect*)cvGetSeqElem(_faces, index);
        
        _ROI = CGRectMake(cvrect.x * _ZCScale, cvrect.y * _ZCScale, cvrect.width * _ZCScale, cvrect.height * _ZCScale);
        
        cvSetImageROI(_IplImage, cvRect(cvrect.x * _ZCScale, cvrect.y * _ZCScale, cvrect.width * _ZCScale, cvrect.height * _ZCScale));
        
        _RoIImg = cvCreateImage(cvSize(cvrect.width * _ZCScale,cvrect.height * _ZCScale), IPL_DEPTH_8U, 3);
        
        cvCvtColor(_IplImage, _RoIImg, CV_BGR2RGB);
        
        cvResetImageROI(_IplImage);
    }
}

- (UIImage *)imageOfLastFace
{
    if (_numberOfFace > 0) {
        self.index = (_faces->total + _index - 1) % _faces->total;
        return [self UIImageFromIplImage:_RoIImg];
    }
    return nil;
}

- (CGRect)ROIRectOfLastFace
{
    if (_numberOfFace > 0) {
        self.index = (_faces->total + _index - 1) % _faces->total;
        return _ROI;
    }
    return CGRectNull;
}

- (UIImage *)imageOfNextFace
{
    if (_numberOfFace > 0) {
        self.index = (_index + 1) % _faces->total;
        return [self UIImageFromIplImage:_RoIImg];
    }
    return nil;
}

- (CGRect)ROIRectOfNextFace
{
    if (_numberOfFace > 0) {
        self.index = (_index + 1) % _faces->total;
        return _ROI;
    }
    return CGRectNull;
}



- (UIImage *)imageOfFaceDetec
{
    
    
    if(_IplImage) {
        
        [self faceDetec];
        
        if(_numberOfFace > 0)
        {
            self.index = 0;
            return [self UIImageFromIplImage:_RoIImg];
        }

    }
    return nil;
}

- (CGRect)ROIRectOfFaceDetec
{
    if(_IplImage) {
        
        
        [self faceDetec];
        
        if(_numberOfFace > 0)
        {
            self.index = 0;
            return _ROI;
        }
        
    }
    return CGRectNull;
}

- (void)dealloc
{
    cvReleaseMemStorage(&_faces->storage);
    cvReleaseImage(&_IplImage);
    cvReleaseImage(&_RoIImg);
}

- (void)faceDetec
{
    cvSetErrMode(CV_ErrModeParent);
    
    IplImage *grayImg = cvCreateImage(cvGetSize(_IplImage), IPL_DEPTH_8U, 1); //先转为灰度图
    
    cvCvtColor(_IplImage, grayImg, CV_BGR2GRAY);
    
    _ZCScale = (_IplImage->width > _IplImage->height ? _IplImage->width : _IplImage->height) / 1000.0;
    
    //        ZCScale = 1;
    
    IplImage *small_image = cvCreateImage(cvSize((int)(_IplImage->width/_ZCScale),(int)(_IplImage->height/_ZCScale)), IPL_DEPTH_8U, 1);
    
    cvResize(grayImg, small_image);
    
//    cvEqualizeHist(small_image, small_image);
    
    //加载分类器
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    
    CvHaarClassifierCascade *cascade = (CvHaarClassifierCascade*)cvLoad([facePath cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
    
    CvMemStorage *storage = cvCreateMemStorage(0);
    
    cvClearMemStorage(storage);
    
    //关键部分，使用cvHaarDetectObjects进行检测，得到一系列方框
    
    _faces = cvHaarDetectObjects(small_image, cascade, storage , 1.2, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0,0), cvSize(0, 0));
    
    _numberOfFace = _faces->total;
    
    cvReleaseHaarClassifierCascade(&cascade);
    
//    NSString *eyePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    
//    CvHaarClassifierCascade *eye_treeCascade = (CvHaarClassifierCascade*)cvLoad([eyePath cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
    
//    CvSeq *eyes;
    
    if (_numberOfFace > 0 && _RoiRectArr == nil) {
        
        for (int i = 0; i < _numberOfFace; i++) {
            
            CvRect cvrect = *(CvRect*)cvGetSeqElem(_faces, i);
            
            cvSetImageROI(_IplImage, cvRect(cvrect.x * _ZCScale, cvrect.y * _ZCScale, cvrect.width * _ZCScale, cvrect.height * _ZCScale));
            
//            eyes = cvHaarDetectObjects(_IplImage, eye_treeCascade, storage , 1.2, 2, CV_HAAR_SCALE_IMAGE, cvSize(0,0), cvSize(0, 0));
//            
//            if (eyes->total > 0) {
//                
                _ROI = CGRectMake(cvrect.x * _ZCScale, cvrect.y * _ZCScale, cvrect.width * _ZCScale, cvrect.height * _ZCScale);
                
                NSValue *roiValue = [NSValue valueWithCGRect:_ROI];
                
                [self.RoiRectArr addObject:roiValue];
//
//            }
            
            cvResetImageROI(_IplImage);
        }
        
//        cvReleaseHaarClassifierCascade(&eye_treeCascade);
        
        [self drawRoiImage];
        
    }
    
    cvReleaseImage(&small_image);
    cvReleaseImage(&grayImg);
}

static const int resize = 200;

- (void)drawRoiImage
{
    IplImage *small_image = cvCreateImage(cvSize(resize,resize), IPL_DEPTH_8U, 3);
    
    IplImage *DeteImage = [self CreateIplImageFromUIImage:_ROIImage];
    
    cvResize(DeteImage, small_image,CV_INTER_LINEAR);
    
    _ROIImage = [self UIImageFromIplImage:small_image];
    
    cvReleaseImage(&small_image);
    
    cvReleaseImage(&DeteImage);
    
    UIGraphicsBeginImageContextWithOptions(_ROIImage.size, NO, 0);
    
    _scaleW = resize / _image.size.width;
    
    _scaleH = resize / _image.size.height;
    
    [_ROIImage drawAtPoint:CGPointZero];
    
    for (NSValue *value in self.RoiRectArr) {
        
        CGRect roi = [value CGRectValue];
        
        roi.origin.x = roi.origin.x * _scaleW;
        
        roi.origin.y = roi.origin.y * _scaleH;
        
        roi.size.width = roi.size.width * _scaleW;
        
        roi.size.height = roi.size.height * _scaleH;
        
        UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:roi cornerRadius:0];
        
        path.lineWidth = 5.0 * (_ROIImage.size.width > _ROIImage.size.height ? _ROIImage.size.width : _ROIImage.size.height) / 1200.0;
        
        [[UIColor greenColor] set];
        
        [path stroke];
        
    }
    
    _ROIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
}

@end

