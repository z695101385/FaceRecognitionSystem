//
//  NSObject+Model.m
//  lotteryApp
//
//  Created by 张晨 on 16/5/20.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)
+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict
{
    id obj = [[self alloc] init];
    
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSString *ivarName = @(ivar_getName(ivar));
        
        ivarName = [ivarName substringFromIndex:1];
        
        id value = dict[ivarName];
        
        if (value == nil) {
            
            if (mapDict) {
                
                NSString *keyName = mapDict[ivarName];
                
                value = dict[keyName];
            }
            
        }
        
        [obj setValue:value forKey:ivarName];
    }
    
    return obj;
}
@end
