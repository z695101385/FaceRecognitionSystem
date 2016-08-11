//
//  ZCFaceDeteController.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/2.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCFaceDeteController.h"
#import "ZCMaskView.h"
#import "ZCCvImage.h"

@interface ZCFaceDeteController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *image;

@property (weak, nonatomic) IBOutlet UIImageView *ROIImageView;

@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
/** imageView */
@property (nonatomic, weak) UIImageView *imageView;
/** MaskView */
@property (nonatomic, weak) IBOutlet ZCMaskView *maskView;
/** cvImage */
@property (nonatomic, strong) ZCCvImage *cvImage;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ZCFaceDeteController

- (IBAction)cancel:(id)sender {
    
    [ZCKeyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)choose:(id)sender {
    
    if (_block) {
        _block([UIImage zc_imageWithCaputureView:_maskView]);
    }
    
    [ZCKeyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setUpCountLabel
{
    
    NSInteger index = _cvImage.index;
    
    NSInteger numberOfFace = _cvImage.numberOfFace;
    
    if (numberOfFace == 0) {
        _countLabel.text = @"Face not detected";
    } else {
        _countLabel.text = [NSString stringWithFormat:@"%d of total %d", index + 1, numberOfFace];
    }
}

- (IBAction)lastFace:(id)sender {
    //返回ROI图像
    
//    UIImage *faceImage = [_cvImage imageOfLastFace];
//    
//    if(faceImage)
//    {
//        self.imageView.image = faceImage;
//        self.imageView.frame = _maskView.bounds;
//    }
    
    //返回ROI区域
    
    CGRect Roi = [_cvImage ROIRectOfLastFace];
    
    [self setUpROIRect:Roi];
    //  设置标签
    [self setUpCountLabel];
}

- (IBAction)autoDetection:(UIButton *)sender {
    
    sender.enabled = NO;
    
    _cvImage = [ZCCvImage cvImageWithUIImage:_image];
    
    //返回ROI图像
    
//    UIImage *faceImage = [cvImage imageOfFaceDetec];
//    
//    if(faceImage)
//    {
//        self.imageView.image = faceImage;
//        self.imageView.frame = _maskView.bounds;
//    }
    
    //返回ROI区域
    
    CGRect Roi = [_cvImage ROIRectOfFaceDetec];
    
    _ROIImageView.image = _cvImage.ROIImage;
    
    [self setUpROIRect:Roi];
    
    _countLabel.hidden = NO;
    //  设置标签
    [self setUpCountLabel];

}

- (IBAction)nextFace:(id)sender {
    //返回ROI图像
    
//    UIImage *faceImage = [_cvImage imageOfNextFace];
//    
//    if(faceImage)
//    {
//        self.imageView.image = faceImage;
//        self.imageView.frame = _maskView.bounds;
//    }
    
    //返回ROI区域
    
    CGRect Roi = [_cvImage ROIRectOfNextFace];
    
    [self setUpROIRect:Roi];
    //  设置标签
    [self setUpCountLabel];
}

- (void)setUpROIRect:(CGRect)rect
{
    if (CGRectIsNull(rect)) return;
    
    //计算ROI区域的中心点。设为锚点
    CGPoint anchor = CGPointMake((rect.origin.x + rect.size.width * 0.5) / _image.size.width, (rect.origin.y + rect.size.height * 0.5) / _image.size.height);
    
    _imageView.layer.anchorPoint = anchor;
    //计算蒙板中心坐标，设为position
    CGPoint position = CGPointMake(_maskView.width * 0.5, _maskView.height * 0.5);
    
    _imageView.layer.position = position;
    //计算缩放比率
    CGFloat scale = _maskView.width / rect.size.width;
    
    _imageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    UIGraphicsBeginImageContextWithOptions(_cvImage.ROIImage.size, NO, 0);
    
    [_cvImage.ROIImage drawAtPoint:CGPointZero];
    
    rect.origin.x = rect.origin.x * _cvImage.scaleW;
    
    rect.origin.y = rect.origin.y * _cvImage.scaleH;
    
    rect.size.width = rect.size.width * _cvImage.scaleW;
    
    rect.size.height = rect.size.height * _cvImage.scaleH;
    
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    
    path.lineWidth = 5.0 * (_cvImage.ROIImage.size.width > _cvImage.ROIImage.size.height ? _cvImage.ROIImage.size.width : _cvImage.ROIImage.size.height) / 1200.0;
    
    [[UIColor redColor] set];
    
    [path stroke];
    
    UIImage *roiImage = UIGraphicsGetImageFromCurrentImageContext();

    _ROIImageView.image = roiImage;

    // 4.关闭上下文
    UIGraphicsEndImageContext();

}

+ (instancetype)ControllerWithImage:(UIImage *)image
{
    ZCFaceDeteController *vc = [[ZCFaceDeteController alloc] initWithNibName:@"ZCFaceDeteController" bundle:nil];
    
    vc.image = image;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    
    self.imageView = imageView;
    
    _imageView.center = CGPointMake(_maskView.width / 2, _maskView.height / 2);
    
    _imageView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [_imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    pinch.delegate = self;
    
    [_imageView addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    
    rotation.delegate = self;
    
    [_imageView addGestureRecognizer:rotation];
    
    [_maskView addSubview:_imageView];
    
    _ROIImageView.image = _image;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint trans = [pan translationInView:_imageView];
    
    _imageView.transform = CGAffineTransformTranslate(_imageView.transform, trans.x, trans.y);
    
    [pan setTranslation:CGPointZero inView:_imageView];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    
    pinch.scale = 1;
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotation.rotation);
    
    rotation.rotation = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //NSLog(@"人脸选取完毕");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
