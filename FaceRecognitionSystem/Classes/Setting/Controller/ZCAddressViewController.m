//
//  ZCAddressViewController.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/12.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCAddressViewController.h"
#import "ZCKeyboardToolBar.h"
#import "SVProgressHUD.h"
#import "ZCSaveTool.h"

@interface ZCAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IPTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
/** ZCKeyboardToolBar */
@property (nonatomic, strong) ZCKeyboardToolBar *keyboardToolBar;

@end

@implementation ZCAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardToolBar = [ZCKeyboardToolBar keyboardWithFieldArray:@[_IPTextField,_portTextField]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

- (void)save
{
    if ([self isIP:self.IPTextField.text] && [self isPort:self.portTextField.text])
    {
        [[ZCSaveTool sharedInstance] saveIP:self.IPTextField.text port:self.portTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:@"IP地址或端口号填写不正确！"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)next {
    [self.portTextField becomeFirstResponder];
}
- (IBAction)endEditing {
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing];
}

- (BOOL)isIP:(NSString *) textString
{
    NSString* number=@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

- (BOOL)isPort:(NSString *)textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
