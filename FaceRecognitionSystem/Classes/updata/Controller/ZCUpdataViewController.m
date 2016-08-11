//
//  ZCUpdataViewController.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/11.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCUpdataViewController.h"
#import "ZCRequestServer.h"
#import "SVProgressHUD.h"

@interface ZCUpdataViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *featureTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;

@end

@implementation ZCUpdataViewController

- (IBAction)updataFeature {
    
    if (!self.IDTextField.text) {
        [SVProgressHUD showErrorWithStatus:@"请输入ID"];
        return;
    }
    
    [[ZCRequestServer sharedInstance] addFeature:self.feature ID:self.IDTextField.text];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (![SVProgressHUD isVisible]) [self cancel];
    });
}


- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (instancetype)controllerWithFeature:(NSString *)feature image:(UIImage *)image
{
    ZCUpdataViewController *UC = [[ZCUpdataViewController alloc] initWithNibName:NSStringFromClass([ZCUpdataViewController class]) bundle:nil];
    
    UC.image = image;
    UC.feature = feature;
    
    return UC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView.image = self.image;
    
    NSString *method = [self.feature componentsSeparatedByString:@"_"][1];
    
    self.featureTypeLabel.text = [NSString stringWithFormat:@"特征类型：%@",method];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
