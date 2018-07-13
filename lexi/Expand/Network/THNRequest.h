//
//  THNRequest.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class THNRequest;

/**
 网络请求方法
 */
typedef NS_ENUM(NSUInteger, AFNetworkingRequestMethod) {
    AFNetworkingRequestMethodGET,       // GET 请求
    AFNetworkingRequestMethodPOST,      // POST 请求
    AFNetworkingRequestMethodUPLOAD,    // 上传文件的请求(POST 请求)
    AFNetworkingRequestMethodDELETE     // DELETE 请求
};

/**
 网络请求格式
 */
typedef NS_ENUM(NSUInteger, AFNetworkingRequestType) {
    AFNetworkingRequestTypeHTTP,        // 二进制格式 (不设置的话为默认格式)
    AFNetworkingRequestTypeJSON,        // JSON 格式
    AFNetworkingRequestTypePlist        // 集合文件方式
};

/**
 网络响应格式
 */
typedef NS_ENUM(NSUInteger, AFNetworkingResponseType) {
    AFNetworkingResponseTypeHTTP,       // 二进制格式 (不设置的话为默认格式)
    AFNetworkingResponseTypeJSON,       // JSON 格式
    AFNetworkingResponseTypeXML,        // XML 的格式
    AFNetworkingResponseTypeImage,      // 图片格式
    AFNetworkingResponseTypePlist,      // 集合文件格式
    AFNetworkingResponseTypeCompound,   // 组合格式
};

/**
 用于测试网络是否可以连接的基准 URL 地址
 */
static NSString *kReachabeBaseURL               = @"https://www.baidu.com/";

/**
 提供给外部监听用，监测网络状态变化
 */
static NSString *kNetworkingReachability        = @"_networkingReachability_";

/**
 外部接收通知用字符串
 */
static NSString *kNetworkingStatusWWAN          = @"_netStatus_WWAN_";
static NSString *kNetworkingStatusWIFI          = @"_netStatus_WIFI_";
static NSString *kNetworkingStatusNotReachable  = @"_netStatus_NotReachable_";

typedef void(^ConstructingBodyBlock)(id <AFMultipartFormData> formData);

#pragma mark - delegate
@protocol THNRequestDelegate <NSObject>

@optional
/**
 请求成功
 
 @param request Request 实例对象
 */
- (void)requestSucess:(THNRequest *)request result:(id)result;

/**
 请求失败
 
 @param request Request 实例对象
 @param error 错误信息
 */
- (void)requestFailed:(THNRequest *)request error:(NSError *)error;

/**
 用户取消请求
 
 @param request Request 实例对象
 @param error 错误信息
 */
- (void)userCanceledFailed:(THNRequest *)request error:(NSError *)error;

@end

#pragma mark - request
@interface THNRequest : NSObject

/**
 是否显示网络提示(左上角旋转的Indicator,默认为显示)
 
 @param show YES为显示，NO为不显示
 */
+ (void)showNetworkActivityIndicator:(BOOL)show;

/**
 开始网络监测(默认就是开启)
 */
+ (void)startMonitoring;

/**
 停止网络监测
 */
+ (void)stopMonitoring;

/**
 是否可以联网
 
 @return YES为可以，NO为不行
 */
+ (BOOL)isReachable;

/**
 当前是否是 WWAN 网络
 
 @return YES为是，NO为不是
 */
+ (BOOL)isReachableViaWWAN;

/**
 当前是否为 WIFI 网络
 
 @return YES为是，NO为不是
 */
+ (BOOL)isReachableViaWiFi;

/**
 是否正在处于请求当中(可以用这个值来判断一个请求是否处于执行状态当中)
 */
@property (nonatomic, readonly) BOOL                isRunning;

/**
 签名认证
 */
@property (nonatomic, assign) BOOL                  sign;

/**
 请求的类型
 */
@property (nonatomic) AFNetworkingRequestType       requestType;

/**
 回复的类型
 */
@property (nonatomic) AFNetworkingResponseType      responseType;

/**
 请求的方法类型
 */
@property (nonatomic) AFNetworkingRequestMethod     RequestMethod;

/**
 超时时间间隔(设置了才能生效,不设置,使用的是AFNetworking自身的超时时间间隔)
 */
@property (nonatomic, assign) NSTimeInterval        timeoutInterval;

/**
 标识符
 */
@property (nonatomic, strong) NSString              *flag;

/**
 网络请求地址
 */
@property (nonatomic, strong) NSString              *urlString;

/**
 作为请求数据字典
 */
@property (nonatomic, strong) NSDictionary          *requestDictionary;

/**
 设置请求头部信息用字典
 */
@property (nonatomic, strong) NSDictionary          *HTTPHeaderFieldsWithValues;

/**
 构造数据用 block(用于 UPLOAD_DATA 方法)
 */
@property (nonatomic, copy) ConstructingBodyBlock   constructingBodyBlock;

/**
 代理
 */
@property (nonatomic, weak) id <THNRequestDelegate> delegate;

/**
 --- 此方法由继承的子类来重载实现 ---
 
 转换请求字典
 
 @return 转换后的字典
 */
- (NSDictionary *)transformRequestDictionary;

/**
 --- 此方法由继承的子类来重载实现 ---
 
 对返回的结果进行转换
 
 @return 转换后的结果
 */
- (id)transformRequestData:(id)data;

/**
 开始请求方法
 */
- (void)startRequest;
- (void)startRequestSuccess:(void(^)(THNRequest *request, id result))success failure:(void(^)(THNRequest *request, NSError *error))failure;

/**
 取消请求方法
 */
- (void)cancelRequest;

#pragma mark - 便利构造器方法
/**
 便利构造器方法
 
 @param urlString           请求地址
 @param requestDictionary   请求参数
 @param delegate            代理
 @param timeoutInterval     超时时间
 @param flag                标签
 @param sign                是否需要签名
 @param requestMethod       请求方法
 @param requestType         请求类型
 @param responseType        回复数据类型
 @return 实例对象
 */
+ (instancetype)requestWithUrlString:(NSString *)urlString
                   requestDictionary:(NSDictionary *)requestDictionary
                            delegate:(id)delegate
                     timeoutInterval:(NSTimeInterval)timeoutInterval
                                flag:(NSString *)flag
                              isSign:(BOOL)sign
                       requestMethod:(AFNetworkingRequestMethod)requestMethod
                         requestType:(AFNetworkingRequestType)requestType
                        responseType:(AFNetworkingResponseType)responseType;

#pragma mark - block的形式请求
/**
 AFNetworking的GET请求
 
 @param URLString    请求网址
 @param parameters   网址参数
 @param timeInterval 超时时间(可以设置为nil)
 @param requestType  请求类型
 @param responseType 返回结果类型
 @param success      成功时调用的block
 @param failure      失败时调用的block
 @return 网络操作句柄
 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeInterval
                  requestType:(AFNetworkingRequestType)requestType
                 responseType:(AFNetworkingResponseType)responseType
                      success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;


/**
 AFNetworking的POST请求
 
 @param URLString    请求网址
 @param parameters   网址参数
 @param timeInterval 超时时间(可以设置为nil)
 @param requestType  请求类型
 @param responseType 返回结果类型
 @param success      成功时调用的block
 @param failure      失败时调用的block
 @return 网络操作句柄
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
               timeoutInterval:(NSTimeInterval)timeInterval
                   requestType:(AFNetworkingRequestType)requestType
                  responseType:(AFNetworkingResponseType)responseType
                       success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                       failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;


/**
 上传文件(POST请求)
 
 @param URLString    请求地址
 @param parameters   网址参数
 @param timeInterval 超时时间(可以设置为nil)
 @param requestType  请求类型
 @param responseType 返回结果类型
 @param block        构造上传数据
 @param success      成功时调用的block
 @param failure      失败时调用的block
 @return 网络操作句柄
 */
+ (NSURLSessionDataTask *)UploadDataWithUrlString:(NSString *)URLString
                                       parameters:(id)parameters
                                  timeoutInterval:(NSTimeInterval)timeInterval
                                      requestType:(AFNetworkingRequestType)requestType
                                     responseType:(AFNetworkingResponseType)responseType
                        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                          success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                                          failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;

@end
