//
//  ZCRequestServer.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/11.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCRequestServer : NSObject

+ (instancetype)sharedInstance;

- (void)classFeature:(NSString *)feature;

- (void)addFeature:(NSString *)feature ID:(NSString *)ID;

@end
