//
//  ZCTrainViewController.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/5/26.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCTrainViewController.h"
#import "ZCFaceDeteController.h"
#import "ZCFeatureExtractionTool.h"

@interface ZCTrainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;

@end

@implementation ZCTrainViewController

- (IBAction)databaseDownload{
    
}

- (IBAction)addImage {
    UIAlertController *AC = [UIAlertController alertControllerWithTitle:@"请选择图片" message:@"从以下两种方式中选择一种" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"从照片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [AC addAction:act1];
    [AC addAction:act2];
    [AC addAction:act3];
    
    [self presentViewController:AC animated:YES completion:nil];
    
}

- (void)imagePickWithSourceType:(UIImagePickerControllerSourceType)SourceType
{
    // 弹出系统的相册
    // 选择控制器（系统相册）
    UIImagePickerController *picekerVc = [[UIImagePickerController alloc] init];
    
    // 设置选择控制器的来源
    // UIImagePickerControllerSourceTypeCamera
    // UIImagePickerControllerSourceTypePhotoLibrary 相册集
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum 照片库
    picekerVc.sourceType = SourceType;
    
    // 设置代理
    picekerVc.delegate = self;
    
    // modal
    [self presentViewController:picekerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
// 当用户选择一张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选中的照片
    UIImage *image1 = info[UIImagePickerControllerOriginalImage];
    
    // 把选中的照片画到画板上
    UIImageOrientation imageOrientation=image1.imageOrientation;
    
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image1.size);
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        image1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    ZCFaceDeteController *vc = [ZCFaceDeteController ControllerWithImage:image1];
    
    vc.block = ^(UIImage *image){
        _faceImageView.image = image;
    };
    
    [picker presentViewController:vc animated:YES completion:nil];

    // dismiss
//    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)trainingImage{
    
    ZCFeatureExtractionTool *ft = [[ZCFeatureExtractionTool alloc] initWithFaceImage:_faceImageView.image];
    
    [ft featureExtraction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
