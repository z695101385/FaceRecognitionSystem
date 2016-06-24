//
//  NSObject+Model.h
//  lotteryApp
//
//  Created by 张晨 on 16/5/20.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)
+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict;
@end
