//
//  ZCSaveTool.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCSaveTool.h"

@interface ZCSaveTool ()

/** NSUserDefaults */
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation ZCSaveTool

- (NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

static id _instace;

static NSString * const IPKey = @"IP";
static NSString * const portKey = @"port";

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

- (void)saveIP:(NSString *)IP port:(NSString *)port
{
    [self.defaults setObject:IP forKey:IPKey];
    
    [self.defaults setObject:port forKey:portKey];
    
    [self.defaults synchronize];
}

- (NSString *)IP
{
    return [self.defaults objectForKey:IPKey];
}

- (uint16_t)port
{
    return [[self.defaults objectForKey:portKey] unsignedIntValue];
}


@end
