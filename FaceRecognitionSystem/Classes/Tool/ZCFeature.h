//
//  ZCFeature.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/27.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCFeature : NSObject

/** featureDict */
@property (nonatomic, strong) NSMutableDictionary *featureDict;
/** ID */
@property (nonatomic, strong) NSString *ID;

- (void)addFeature:(id)fea withKey:(NSString *)key;

- (instancetype)initWithID:(NSString *)ID;

@end
