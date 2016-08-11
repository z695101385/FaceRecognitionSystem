//
//  NSObject+Extension.h
//  JS_OC
//
//  Created by 张晨 on 16/6/16.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)params;

@end
