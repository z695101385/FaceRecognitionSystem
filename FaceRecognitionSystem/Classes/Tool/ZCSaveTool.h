//
//  ZCSaveTool.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSaveTool : NSObject


+ (instancetype)sharedInstance;

- (void)saveIP:(NSString *)IP  port:(NSString *)port;

- (NSString *)IP;

- (uint16_t)port;

@end
