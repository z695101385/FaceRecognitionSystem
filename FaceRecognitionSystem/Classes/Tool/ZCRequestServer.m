//
//  ZCRequestServer.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/11.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCRequestServer.h"
#import "GCDAsyncSocket.h"
#import "SVProgressHUD.h"

typedef enum : NSUInteger {
    ZCRequestTypeAddFeature,
    ZCRequestTypeClassFeature,
} ZCRequestType;

@interface ZCRequestServer ()<GCDAsyncSocketDelegate>

/** clientSocket */
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

/** 特征 */
@property (nonatomic, copy) NSString *feature;

/** ID */
@property (nonatomic, copy) NSString *ID;

/** 操作类型 */
@property (nonatomic, assign) ZCRequestType type;

/** 是否在等待服务器返回值 */
@property (nonatomic, assign, getter=isWaitForData) BOOL waitForData;

@end

@implementation ZCRequestServer

static id _instace;

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

- (instancetype)init
{
    if (self = [super init]) {
        
        GCDAsyncSocket *clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        self.clientSocket = clientSocket;
        
    }
    return self;
}

- (void)classFeature:(NSString *)feature
{
    if (!feature) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"未检测到特征！\n请先提取特征！"];
        return;
    }
    
    self.type = ZCRequestTypeClassFeature;
    
    self.waitForData = YES;
    
    NSError *err;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"正在连接服务器..."];
    
    [self.clientSocket connectToHost:@"192.168.1.111" onPort:2333 error:&err];
    
    self.feature = feature;
    
    if (err) NSLog(@"%@",err);
}

- (void)addFeature:(NSString *)feature ID:(NSString *)ID
{
    self.type = ZCRequestTypeAddFeature;
    
    self.waitForData = YES;
    
    NSError *err;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SVProgressHUD showWithStatus:@"正在连接服务器..."];
    
    [self.clientSocket connectToHost:@"192.168.1.111" onPort:2333 error:&err];
    
    self.feature = feature;
    
    self.ID = ID;
    
    if (err) {
       NSLog(@"%@",err);
    }
}

- (void)socket:(GCDAsyncSocket *)clientSocket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *sentStr;
    
    if (self.type == ZCRequestTypeClassFeature) {
        
        [SVProgressHUD showWithStatus:@"正在获取识别结果..."];
        
        sentStr = [NSString stringWithFormat:@"%@\n",self.feature];
        
    } else if (self.type == ZCRequestTypeAddFeature) {
        
        [SVProgressHUD showWithStatus:@"特征上传中..."];
        
        sentStr = [NSString stringWithFormat:@"ID_%@_%@\n",self.ID,self.feature];
    }
    
    
    NSData *data = [sentStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [clientSocket writeData:data withTimeout:30 tag:0];
    
    [clientSocket readDataWithTimeout:30 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)clientSocket withError:(NSError *)err
{
    NSLog(@"服务器断开连接");
    
    if (self.isWaitForData) {
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"服务器超时！"];
    }
}

- (void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    
    self.waitForData = NO;
    
    if ([str containsString:@"库中最接近结果为："])
    {
        [SVProgressHUD showSuccessWithStatus:str];
        [clientSocket disconnect];
        return;
    } else if ([str containsString:@"特征上传成功！"]) {
        [SVProgressHUD showSuccessWithStatus:str];
        [clientSocket disconnect];
        return;
    }
    else {
        [SVProgressHUD showErrorWithStatus:str];
        [clientSocket disconnect];
        return;
    }
}

@end
