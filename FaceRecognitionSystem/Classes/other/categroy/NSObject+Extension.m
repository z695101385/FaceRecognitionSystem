//
//  NSObject+Extension.m
//  JS_OC
//
//  Created by 张晨 on 16/6/16.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)params
{
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    if (signature == nil) {
        
        [NSException raise:@"Error" format:@"%@方法找不到", NSStringFromSelector(aSelector)];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    
    invocation.selector = aSelector;
    
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    
    paramsCount = MIN(paramsCount, params.count);
    
    for (NSInteger i = 0; i < paramsCount; i++) {
        id param = params[i];
        if ([param isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&param atIndex:i + 2];
    }
    
    // 调用方法
    [invocation invoke];
    
    id returnValue = nil;
    
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    
    return returnValue;
    
}

@end
