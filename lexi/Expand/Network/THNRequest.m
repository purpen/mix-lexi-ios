//
//  THNRequest.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNRequest.h"
#import "THNConst.h"

#import <CommonCrypto/CommonDigest.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/UIKit+AFNetworking.h>

typedef NS_ENUM(NSUInteger, NCancelType) {
    NCancelTypeDealloc,     // dealloc取消
    NCancelTypeUser         // 用户取消
};

/**
 网络状态的监测，是否可以发送通知消息
 */
static AFHTTPSessionManager *_managerReachability = nil;
static BOOL _canSendMessage = YES;

/**
 响应信息 key 值
 */
static const NSString *kResponseInfoSuccess = @"success";
static const NSString *kResponseInfoStatus = @"status";
static const NSString *kResponseInfoMessage = @"message";

@interface THNRequest()

@property (nonatomic, strong) AFHTTPSessionManager        *manager;
@property (nonatomic, strong) NSURLSessionDataTask        *httpOperation;
@property (nonatomic, assign) NCancelType                 cancelType;
@property (nonatomic, assign) BOOL                        isRunning;

/**
 默认设置
 */
- (void)defaultConfig;

/**
 初始化网络状态监测
 */
+ (void)networkReachability;

/**
 根据序列化枚举值返回对应的请求策略
 
 @param serializerType 序列化枚举值
 @return 序列化策略
 */
+ (AFHTTPRequestSerializer *)requestSerializerWith:(AFNetworkingRequestType)serializerType;

/**
 根据序列化枚举值返回对应的回复策略
 
 @param serializerType 序列化枚举值
 @return 序列化策略
 */
+ (AFHTTPResponseSerializer *)responseSerializerWith:(AFNetworkingResponseType)serializerType;

@end

@implementation THNRequest

+ (void)initialize {
    if (self == [THNRequest class]) {
        [self showNetworkActivityIndicator:YES];    // 显示网络指示器
        [self networkReachability];                 // 初始化网络监测
        [self startMonitoring];                     // 开启网络监测
    }
}

/**
 初始化网络监测
 */
+ (void)networkReachability {
    NSURL *baseURL = [NSURL URLWithString:kReachabeBaseURL];
    _managerReachability = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = _managerReachability.operationQueue;
    [_managerReachability.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                
                if (_canSendMessage) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkingReachability
                                                                        object:nil
                                                                      userInfo:@{@"networkReachable": kNetworkingStatusWWAN}];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                
                if (_canSendMessage) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkingReachability
                                                                        object:nil
                                                                      userInfo:@{@"networkReachable": kNetworkingStatusWIFI}];
                }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                
                if (_canSendMessage) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkingReachability
                                                                        object:nil
                                                                      userInfo:@{@"networkReachable": kNetworkingStatusNotReachable}];
                }
                break;
        }
    }];
}

+ (void)startMonitoring {
    _canSendMessage = YES;
    [_managerReachability.reachabilityManager startMonitoring];
}

+ (void)stopMonitoring {
    _canSendMessage = NO;
    [_managerReachability.reachabilityManager stopMonitoring];
}

+ (BOOL)isReachable {
    return _managerReachability.reachabilityManager.isReachable;
}

+ (BOOL)isReachableViaWWAN {
    return _managerReachability.reachabilityManager.isReachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi {
    return _managerReachability.reachabilityManager.isReachableViaWiFi;
}

/**
 初始化方法
 
 @return 实例对象
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

+ (void)showNetworkActivityIndicator:(BOOL)show {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:show];
}

- (NSDictionary *)transformRequestDictionary {
    return self.requestDictionary;
}

- (id)transformRequestData:(id)data {
    return data;
}

/**
 默认设置
 */
- (void)defaultConfig {
    self.manager = [AFHTTPSessionManager manager];
    self.isRunning = NO;
}

#pragma mark - delegate method
- (void)startRequest {
    if (self.urlString.length <= 0) { return; }
    
    // 进入请求状态
    _isRunning = YES;
    
    self.manager = [THNRequest defaultHTTPSessionManagerWithRequestType:self.requestType
                                                           responseType:self.responseType
                                                        timeoutInterval:self.timeoutInterval
                                                           headerFields:self.HTTPHeaderFieldsWithValues];
    
    __weak THNRequest *weakSelf = self;
    
    if (self.RequestMethod == AFNetworkingRequestMethodGET) {
        
        self.httpOperation = [self.manager GET:self.urlString
                                    parameters:[weakSelf transformRequestDictionary]
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:result:)]) {
                                               [weakSelf.delegate requestSucess:weakSelf result:[weakSelf transformRequestData:responseObject]];
                                           }
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           if (self.cancelType == NCancelTypeUser) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                   [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                   weakSelf.cancelType = NCancelTypeDealloc;
                                               }
                                               
                                           } else {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                   [weakSelf.delegate requestFailed:weakSelf error:error];
                                               }
                                           }
                                       }];
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodPOST) {
        
        self.httpOperation = [self.manager POST:self.urlString
                                     parameters:[weakSelf transformRequestDictionary]
                                       progress:nil
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            
                                            weakSelf.isRunning = NO;
                                            
                                            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:result:)]) {
                                                [weakSelf.delegate requestSucess:weakSelf result:[weakSelf transformRequestData:responseObject]];
                                            }
                                        }
                                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            
                                            weakSelf.isRunning = NO;
                                            
                                            if (self.cancelType == NCancelTypeUser) {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                    [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                    weakSelf.cancelType = NCancelTypeDealloc;
                                                }
                                                
                                            } else {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                    [weakSelf.delegate requestFailed:weakSelf error:error];
                                                }
                                            }
                                        }];
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodUPLOAD) {
        
        if (self.constructingBodyBlock) {
            
            self.httpOperation = [self.manager POST:self.urlString
                                         parameters:[weakSelf transformRequestDictionary]
                          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                              weakSelf.constructingBodyBlock(formData);
                          }
                                           progress:nil
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                
                                                weakSelf.isRunning = NO;
                                                
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:result:)]) {
                                                    [weakSelf.delegate requestSucess:weakSelf result:[weakSelf transformRequestData:responseObject]];
                                                }
                                            }
                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                
                                                weakSelf.isRunning = NO;
                                                
                                                if (self.cancelType == NCancelTypeUser) {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                        [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                        weakSelf.cancelType = NCancelTypeDealloc;
                                                    }
                                                    
                                                } else {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                        [weakSelf.delegate requestFailed:weakSelf error:error];
                                                    }
                                                }
                                            }];
            
        } else if (self.RequestMethod == AFNetworkingRequestMethodDELETE) {
            
            self.httpOperation = [self.manager DELETE:self.urlString
                                           parameters:[weakSelf transformRequestDictionary]
                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                  
                                                  weakSelf.isRunning = NO;
                                                  
                                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:result:)]) {
                                                      [weakSelf.delegate requestSucess:weakSelf result:[weakSelf transformRequestData:responseObject]];
                                                  }
                                                  
                                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                  
                                                  weakSelf.isRunning = NO;
                                                  
                                                  if (self.cancelType == NCancelTypeUser) {
                                                      if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                          [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                          weakSelf.cancelType = NCancelTypeDealloc;
                                                      }
                                                      
                                                  } else {
                                                      if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                          [weakSelf.delegate requestFailed:weakSelf error:error];
                                                      }
                                                  }
                                              }];
        } else {
            
            self.httpOperation = [self.manager POST:self.urlString
                                         parameters:[weakSelf transformRequestDictionary]
                          constructingBodyWithBlock:nil
                                           progress:nil
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                
                                                weakSelf.isRunning = NO;
                                                
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSucess:result:)]) {
                                                    [weakSelf.delegate requestSucess:weakSelf result:[weakSelf transformRequestData:responseObject]];
                                                }
                                                
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                
                                                weakSelf.isRunning = NO;
                                                
                                                if (self.cancelType == NCancelTypeUser) {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                        [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                        weakSelf.cancelType = NCancelTypeDealloc;
                                                    }
                                                    
                                                } else {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                                                        [weakSelf.delegate requestFailed:weakSelf error:error];
                                                    }
                                                }
                                            }];
        }
    }
}

#pragma mark - block method
- (void)startRequestSuccess:(void (^)(THNRequest *, THNResponse *))success failure:(void (^)(THNRequest *, NSError *))failure {
    
    if (self.urlString.length <= 0) { return; }
    
    // 进入请求状态
    _isRunning = YES;
    
    
    self.manager = [THNRequest defaultHTTPSessionManagerWithRequestType:self.requestType
                                                           responseType:self.responseType
                                                        timeoutInterval:self.timeoutInterval
                                                           headerFields:self.HTTPHeaderFieldsWithValues];
    
    __weak THNRequest *weakSelf = self;
    
    if (self.RequestMethod == AFNetworkingRequestMethodGET) {
        self.httpOperation = [self.manager GET:self.urlString
                                    parameters:[weakSelf transformRequestDictionary]
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           THNResponse *response = [[THNResponse alloc] initWithResponseObject:responseObject];
                                           success(weakSelf, response);
                                           
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           if (self.cancelType == NCancelTypeUser) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                   [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                   weakSelf.cancelType = NCancelTypeDealloc;
                                               }
                                               
                                           } else {
                                               if (failure) {
                                                   failure(weakSelf, error);
                                               }
                                           }
                                       }];
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodPOST) {
        self.httpOperation = [self.manager POST:self.urlString
                                     parameters:[weakSelf transformRequestDictionary]
                                       progress:nil
                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            
                                            weakSelf.isRunning = NO;
                                            
                                            THNResponse *response = [[THNResponse alloc] initWithResponseObject:responseObject];
                                            success(weakSelf, response);
                                            
                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            
                                            weakSelf.isRunning = NO;
                                            
                                            if (self.cancelType == NCancelTypeUser) {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                    [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                    weakSelf.cancelType = NCancelTypeDealloc;
                                                }
                                                
                                            } else {
                                                if (failure) {
                                                    failure(weakSelf, error);
                                                }
                                            }
                                        }];
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodUPLOAD) {
        if (self.constructingBodyBlock) {
            
            self.httpOperation = [self.manager POST:self.urlString
                                         parameters:[weakSelf transformRequestDictionary]
                          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                              weakSelf.constructingBodyBlock(formData);
                          }
                                           progress:nil
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                
                                                weakSelf.isRunning = NO;
    
                                                THNResponse *response = [[THNResponse alloc] initWithResponseObject:responseObject];
                                                success(weakSelf, response);
                                                
                                            }
                                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                
                                                weakSelf.isRunning = NO;
                                                
                                                if (self.cancelType == NCancelTypeUser) {
                                                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                        [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                        weakSelf.cancelType = NCancelTypeDealloc;
                                                    }
                                                    
                                                } else {
                                                    if (failure) {
                                                        failure(weakSelf, error);
                                                    }
                                                }
                                            }];
            
        }
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodDELETE) {
        self.httpOperation = [self.manager DELETE:self.urlString
                                       parameters:[weakSelf transformRequestDictionary]
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                              
                                              weakSelf.isRunning = NO;
                                              
                                              THNResponse *response = [[THNResponse alloc] initWithResponseObject:responseObject];
                                              success(weakSelf, response);
                                              
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              
                                              weakSelf.isRunning = NO;
                                              
                                              if (self.cancelType == NCancelTypeUser) {
                                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                      [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                      weakSelf.cancelType = NCancelTypeDealloc;
                                                  }
                                                  
                                              } else {
                                                  if (failure) {
                                                      failure(weakSelf, error);
                                                  }
                                              }
                                          }];
        
    } else if (self.RequestMethod == AFNetworkingRequestMethodPUT) {
        self.httpOperation = [self.manager PUT:self.urlString
                                    parameters:[weakSelf transformRequestDictionary]
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           THNResponse *response = [[THNResponse alloc] initWithResponseObject:responseObject];
                                           success(weakSelf, response);
                                           
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           
                                           weakSelf.isRunning = NO;
                                           
                                           if (self.cancelType == NCancelTypeUser) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userCanceledFailed:error:)]) {
                                                   [weakSelf.delegate userCanceledFailed:weakSelf error:error];
                                                   weakSelf.cancelType = NCancelTypeDealloc;
                                               }
                                               
                                           } else {
                                               if (failure) {
                                                   failure(weakSelf, error);
                                               }
                                           }
                                       }];
        
    }
}

#pragma mark - request method
+ (instancetype)requestWithUrlString:(NSString *)urlString
                   requestDictionary:(NSDictionary *)requestDictionary
                            delegate:(id)delegate
                     timeoutInterval:(NSTimeInterval)timeoutInterval
                                flag:(NSString *)flag
                       requestMethod:(AFNetworkingRequestMethod)requestMethod
                         requestType:(AFNetworkingRequestType)requestType
                        responseType:(AFNetworkingResponseType)responseType {
    
    THNRequest *request = (THNRequest *)[[[self class] alloc] init];
    request.urlString           = urlString;
    request.requestDictionary   = requestDictionary;
    request.delegate            = delegate;
    request.timeoutInterval     = timeoutInterval;
    request.flag                = flag;
    request.RequestMethod       = requestMethod;
    request.requestType         = requestType;
    request.responseType        = responseType;
    
    return request;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeInterval
                  requestType:(AFNetworkingRequestType)requestType
                 responseType:(AFNetworkingResponseType)responseType
                      success:(void (^)(NSURLSessionTask *, id))success
                      failure:(void (^)(NSURLSessionTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [THNRequest defaultHTTPSessionManagerWithRequestType:requestType
                                                                            responseType:responseType
                                                                         timeoutInterval:timeInterval
                                                                            headerFields:nil];
    
    NSURLSessionDataTask *httpOperation = [manager GET:URLString
                                            parameters:parameters
                                              progress:nil
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   if (success) {
                                                       success(task, responseObject);
                                                   }
                                                   
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   if (failure) {
                                                       failure(task, error);
                                                   }
                                               }];
    return httpOperation;
}

+ (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeInterval
                  requestType:(AFNetworkingRequestType)requestType
                 responseType:(AFNetworkingResponseType)responseType
                      success:(void (^)(NSURLSessionTask *, id))success
                      failure:(void (^)(NSURLSessionTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [THNRequest defaultHTTPSessionManagerWithRequestType:requestType
                                                                            responseType:responseType
                                                                         timeoutInterval:timeInterval
                                                                            headerFields:nil];
    
    NSURLSessionDataTask *httpOperation = [manager PUT:URLString
                                            parameters:parameters
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   if (success) {
                                                       success(task, responseObject);
                                                   }
                                                   
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   if (failure) {
                                                       failure(task, error);
                                                   }
                                               }];
    return httpOperation;
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
               timeoutInterval:(NSTimeInterval)timeInterval
                   requestType:(AFNetworkingRequestType)requestType
                  responseType:(AFNetworkingResponseType)responseType
                       success:(void (^)(NSURLSessionTask *, id))success
                       failure:(void (^)(NSURLSessionTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [THNRequest defaultHTTPSessionManagerWithRequestType:requestType
                                                                            responseType:responseType
                                                                         timeoutInterval:timeInterval
                                                                            headerFields:nil];
    
    NSURLSessionDataTask *httpOperation = [manager POST:URLString
                                             parameters:parameters
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    if (success) {
                                                        success(task, responseObject);
                                                    }
                                                    
                                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    if (failure) {
                                                        failure(task, error);
                                                    }
                                                }];
    return httpOperation;
}

+ (NSURLSessionDataTask *)UploadDataWithUrlString:(NSString *)URLString
                                       parameters:(id)parameters
                                  timeoutInterval:(NSTimeInterval)timeInterval
                                      requestType:(AFNetworkingRequestType)requestType
                                     responseType:(AFNetworkingResponseType)responseType
                        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                          success:(void (^)(NSURLSessionTask *, id))success
                                          failure:(void (^)(NSURLSessionTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [THNRequest defaultHTTPSessionManagerWithRequestType:requestType
                                                                            responseType:responseType
                                                                         timeoutInterval:timeInterval
                                                                            headerFields:nil];
    
    NSURLSessionDataTask *httpOperation = [manager POST:URLString
                                             parameters:parameters
                              constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                  if (block) {
                                      block(formData);
                                  }
                              }
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    if (success) {
                                                        success(task, responseObject);
                                                    }
                                                    
                                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    if (failure) {
                                                        failure(task, error);
                                                    }
                                                }];
    
    return httpOperation;
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                 timeoutInterval:(NSTimeInterval)timeInterval
                     requestType:(AFNetworkingRequestType)requestType
                    responseType:(AFNetworkingResponseType)responseType
                         success:(void (^)(NSURLSessionTask *, id))success
                         failure:(void (^)(NSURLSessionTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [THNRequest defaultHTTPSessionManagerWithRequestType:requestType
                                                                            responseType:responseType
                                                                         timeoutInterval:timeInterval
                                                                            headerFields:nil];
    
    NSURLSessionDataTask *httpOperation = [manager DELETE:URLString
                                               parameters:parameters
                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      if (success) {
                                                          success(task, responseObject);
                                                      }
                                                  }
                                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                      if (failure) {
                                                          failure(task, error);
                                                      }
                                                  }];
    
    return httpOperation;
}

#pragma mark - private methods
/**
 配置请求
 */
+ (AFHTTPSessionManager *)defaultHTTPSessionManagerWithRequestType:(AFNetworkingRequestType)requestType
                                                      responseType:(AFNetworkingResponseType)responseType
                                                   timeoutInterval:(NSTimeInterval)timeInterval
                                                      headerFields:(NSDictionary *)headerFields {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求类型
    if (requestType) {
        manager.requestSerializer = [THNRequest requestSerializerWith:requestType];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
        [manager.requestSerializer setValue:@"application/json; charset:utf-8" forHTTPHeaderField:@"Content-Type" ];
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain",nil];
        
    } else {
        manager.requestSerializer = [THNRequest requestSerializerWith:AFNetworkingRequestTypeHTTP];
    }
    
    // 设置请求头部信息
    if (headerFields) {
        NSArray *allKeys = headerFields.allKeys;
        
        for (NSString *headerField in allKeys) {
            NSString *value = [headerFields valueForKey:headerField];
            [manager.requestSerializer setValue:value forHTTPHeaderField:headerField];
        }
    }
    
    // 设置回复类型
    if (responseType) {
        manager.responseSerializer = [THNRequest responseSerializerWith:responseType];
        manager.responseSerializer.acceptableContentTypes = \
        [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
    } else {
        manager.responseSerializer = [THNRequest responseSerializerWith:AFNetworkingResponseTypeHTTP];
        manager.responseSerializer.acceptableContentTypes = \
        [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    
    // 设置超时时间
    if (timeInterval && timeInterval > 0) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    return manager;
}

+ (AFHTTPRequestSerializer *)requestSerializerWith:(AFNetworkingRequestType)serializerType {
    if (serializerType == AFNetworkingRequestTypeJSON) {
        return [AFJSONRequestSerializer serializer];
        
    } else if (serializerType == AFNetworkingRequestTypeHTTP) {
        return [AFHTTPRequestSerializer serializer];
        
    } else if (serializerType == AFNetworkingRequestTypePlist) {
        return [AFPropertyListRequestSerializer serializer];
        
    } else {
        return nil;
    }
}

+ (AFHTTPResponseSerializer *)responseSerializerWith:(AFNetworkingResponseType)serializerType {
    if (serializerType == AFNetworkingResponseTypeJSON) {
        return [AFJSONResponseSerializer serializer];
        
    } else if (serializerType == AFNetworkingResponseTypeHTTP) {
        return [AFHTTPResponseSerializer serializer];
        
    } else if (serializerType == AFNetworkingResponseTypePlist) {
        return [AFPropertyListResponseSerializer serializer];
        
    } else if (serializerType == AFNetworkingResponseTypeImage) {
        return [AFImageResponseSerializer serializer];
        
    } else if (serializerType == AFNetworkingResponseTypeCompound) {
        return [AFCompoundResponseSerializer serializer];
        
    } else if (serializerType == AFNetworkingResponseTypeXML) {
        return [AFXMLParserResponseSerializer serializer];
        
    } else {
        return nil;
    }
}

- (void)cancelRequest {
    self.cancelType = NCancelTypeUser;
    [self.httpOperation cancel];
}

- (void)dealloc {
    self.cancelType = NCancelTypeDealloc;
    [self.httpOperation cancel];
}

@end
