//
//  KeyboardToolBar.h
//  playKeyboard
//
//  使用时要保持对工具条的强引用
//  Created by 张晨 on 16/3/2.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 声明协议(暂未使用) */
@protocol ZCKeyboardToolBarDelegate;

@interface ZCKeyboardToolBar : UIToolbar

/** 覆写UIToolbar代理方法
 *  父类已有delegate属性需手动在 .m中实现 @synthesize delegate = _delegate;
 */
@property(nonatomic,assign) id<UIToolbarDelegate, ZCKeyboardToolBarDelegate> delegate NS_AVAILABLE_IOS(7_0);
/** 文本框数组 */
@property (nonatomic, strong) NSArray *fieldArr;
/** 当前响应者文本框 */
@property (nonatomic, weak) UITextField *currentField;
/** 当前响应者索引 */
@property (nonatomic, assign) NSInteger numberOfcurrentField;
/** 初始化类方法 */
+ (instancetype)keyboardWithFieldArray:(NSArray *)fieldArr;

@end


/** 定义协议(暂无) */
@protocol ZCKeyboardToolBarDelegate <NSObject>

@required

@optional

@end

