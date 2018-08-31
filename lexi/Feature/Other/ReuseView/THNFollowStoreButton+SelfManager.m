//
//  THNFollowStoreButton+SelfManager.m
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreButton+SelfManager.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import <SVProgressHUD/SVProgressHUD.h>

/// api 地址
static NSString *const kURLFollow       = @"/follow/store";
static NSString *const kURLFollowCancel = @"/unfollow/store";

@implementation THNFollowStoreButton (SelfManager)

- (void)selfManagerFollowStoreStatus:(BOOL)follow storeRid:(NSInteger)rid {
    [self setFollowStoreStatus:follow];
    self.storeId = rid;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)followStoreAction:(id)sender {
    [self requestFollowStoreWithURL:self.selected ? kURLFollowCancel : kURLFollow
                            storeId:self.storeId
                          completed:^(NSError *error) {
                              if (error) {
                                  [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                  return;
                              }
                              
                              self.selected = !self.selected;
                              [self thn_changeButtonAnimation];
    }];
}

#pragma mark - private methods
- (void)thn_changeButtonAnimation {
    self.backgroundColor = [UIColor colorWithHexString:self.selected ? @"#EFF3F2" : kColorMain];
    [self setTitleEdgeInsets:(UIEdgeInsetsMake(0, self.selected ? 0 : 5, 0, 0))];
    
//    self.transform = CGAffineTransformIdentity;
//    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        }];
//    } completion:nil];
}

#pragma mark - request
/**
 关注&取消关注店铺
 店铺 id
 测试：99356178、98501397、98326157、97398026

 @param url api 地址
 @param storeId 店铺 id
 @param completed 成功后的回调
 */
- (void)requestFollowStoreWithURL:(NSString *)url storeId:(NSInteger)storeId completed:(void (^)(NSError *error))completed {
    THNRequest *request = [THNAPI postWithUrlString:url
                                  requestDictionary:@{@"rid": [NSString stringWithFormat:@"%zi", storeId]}
                                           delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

@end
