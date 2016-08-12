//
//  KeyboardToolBar.m
//  playKeyboard
//
//  Created by 张晨 on 16/3/2.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCKeyboardToolBar.h"
@interface ZCKeyboardToolBar ()
/** 上一文本框按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastButton;
/** 下一文本框按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
/** 结束编辑按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneEditButton;
@end

@implementation ZCKeyboardToolBar
/**
 *  手动实现属性定义，完成对父类属性覆写
 */
@synthesize delegate = _delegate;
/**
 *  初始化方法
 *
 *  @param fieldArr 文本框数组
 *
 *  @return 键盘工具栏
 */
+ (instancetype)keyboardWithFieldArray:(NSArray *)fieldArr {
    ZCKeyboardToolBar *Ktb = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    
    Ktb.fieldArr = fieldArr;
    
    for (UITextField *textField in fieldArr) {
        textField.inputAccessoryView = Ktb;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:Ktb selector:@selector(keyboardWasShown) name:UIKeyboardWillShowNotification object:nil];
    
    return Ktb;
}

/**
 *  上一文本框
 */
- (IBAction)lastField {
    _numberOfcurrentField -= 1;
    self.currentField = _fieldArr[_numberOfcurrentField];
    [_currentField becomeFirstResponder];
}
/**
 *  下一文本框
 */
- (IBAction)nextField {
    _numberOfcurrentField += + 1;
    self.currentField = _fieldArr[_numberOfcurrentField];
    [_currentField becomeFirstResponder];
}

/**
 *  结束编辑
 */
- (IBAction)doneEditing {
    [_fieldArr[_numberOfcurrentField] resignFirstResponder];
    _numberOfcurrentField = -1;
    _currentField = nil;
}

/**
 *  重写当前文本框索引set方法(也可输入当前文本框)
 *
 *  @param numberOfcurrentField 当前文本框索引
 */
- (void)setNumberOfCurrentField:(NSInteger)numberOfcurrentField {
    _numberOfcurrentField = numberOfcurrentField;
    _currentField = _fieldArr[_numberOfcurrentField];
    [self checkButtonStatus];
}

/**
 *  重写当前文本框set方法(也可输入当前文本框索引)
 *
 *  @param currentField 当前响应者文本框
 */
- (void)setCurrentField:(UITextField *)currentField {
    _currentField = currentField;
    _numberOfcurrentField = [_fieldArr indexOfObject:currentField];
    [self checkButtonStatus];
}

/**
 *  检测按钮状态
 */
- (void)checkButtonStatus {
    if (_numberOfcurrentField == 0) {
        _lastButton.enabled = NO;
        _nextButton.enabled = YES;
    }else if(_numberOfcurrentField == _fieldArr.count - 1) {
        _lastButton.enabled = YES;
        _nextButton.enabled = NO;
    }else {
        _lastButton.enabled = YES;
        _nextButton.enabled = YES;
    }
}
/**
 *  即将出现时，检测状态
 */
- (void)keyboardWasShown
{
    for (UITextField *text in _fieldArr) {
        if ([text isFirstResponder]) {
            self.currentField = text;
            break;
        }
    }
    [self checkButtonStatus];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
