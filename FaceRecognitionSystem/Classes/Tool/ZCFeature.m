//
//  ZCFeature.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/27.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCFeature.h"
#import "ZCSaveTool.h"

@implementation ZCFeature

- (instancetype)initWithID:(NSString *)ID
{
    if (self = [super init]) {
        _ID = ID;
    }
    return self;
}

- (NSMutableDictionary *)featureDict
{
    if (!_featureDict) {
        _featureDict = [NSMutableDictionary dictionary];
    }
    return _featureDict;
}

- (void)addFeature:(id)fea withKey:(NSString *)key
{
    [self.featureDict setValue:fea forKey:key];
}

@end
