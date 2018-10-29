//
//  THNFollowUserButton+SelfManager.m
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowUserButton+SelfManager.h"
#import "THNApi.h"
#import "SVProgressHUD+Helper.h"

#import "THNNotificationHeader.h"

static NSString *const kURLFollow   = @"/follow/user";
static NSString *const kURLUnFollow = @"/unfollow/user";
/// 参数
static NSString *const kKeyStatus   = @"followed_status";

@implementation THNFollowUserButton (SelfManager)

- (void)selfManagerFollowUserStatus:(THNUserFollowStatus)status userModel:(THNUserModel *)model {
    self.userModel = model;
    self.userId = model.uid;
    [self setFollowUserStatus:status];
    [self addTarget:self action:@selector(followButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - event response
- (void)followButtonAction:(id)sender {
    if (!self.userId.length) {
        [SVProgressHUD thn_showInfoWithStatus:@"用户数据错误"];
        return;
    }
    
    [self requestFollowUserWithURL:self.followStatus == THNUserFollowStatusNot ? kURLFollow : kURLUnFollow
                            userId:self.userId
                         completed:^(NSInteger status, NSError *error) {
                             if (error) return;
                             
                             [self setFollowUserStatus:(THNUserFollowStatus)status];
                             self.userModel.followed_status = status;
                         }];
}

#pragma mark - request
/**
 关注&取消关注用户

 @param url api 地址
 @param uid 用户 id
 @param completed 成功后的回调
 */
- (void)requestFollowUserWithURL:(NSString *)url userId:(NSString *)uid completed:(void (^)(NSInteger status, NSError *error))completed {
    THNRequest *request = [THNAPI postWithUrlString:url requestDictionary:@{@"uid": uid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed([result.data[kKeyStatus] integerValue], nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(0, error);
    }];
}

@end
