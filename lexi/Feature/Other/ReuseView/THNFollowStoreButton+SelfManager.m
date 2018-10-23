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
#import "SVProgressHUD+Helper.h"

/// api 地址
static NSString *const kURLFollow       = @"/follow/store";
static NSString *const kURLFollowCancel = @"/unfollow/store";

@implementation THNFollowStoreButton (SelfManager)

- (void)selfManagerFollowStoreStatus:(BOOL)follow storeRid:(NSString *)rid {
    [self setFollowStoreStatus:follow];
    self.storeId = rid;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)followStoreAction:(id)sender {
    [self requestFollowStoreWithURL:self.selected ? kURLFollowCancel : kURLFollow
                            storeId:self.storeId
                          completed:^(NSError *error) {
                              if (error) {
                                  [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
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
}

#pragma mark - request
/**
 关注&取消关注店铺
 
 @param url api 地址
 @param storeId 店铺 id
 @param completed 成功后的回调
 */
- (void)requestFollowStoreWithURL:(NSString *)url storeId:(NSString *)storeId completed:(void (^)(NSError *error))completed {
    THNRequest *request = [THNAPI postWithUrlString:url requestDictionary:@{@"rid": storeId} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            
            if (self.followStoreBlock) {
                self.followStoreBlock(!self.selected);
            }
            
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

@end
