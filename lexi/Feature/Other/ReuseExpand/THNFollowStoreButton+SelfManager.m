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
#import "THNLoginManager.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"

/// api 地址
static NSString *const kURLFollow       = @"/follow/store";
static NSString *const kURLFollowCancel = @"/unfollow/store";

@implementation THNFollowStoreButton (SelfManager)

- (void)selfManagerFollowStoreStatus:(BOOL)follow storeModel:(THNStoreModel *)model {
    if (!model.rid.length) return;
    
    [self setFollowStoreStatus:follow];
    self.storeId = model.rid;
    self.storeModel = model;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerFollowBrandStatus:(BOOL)follow brandModel:(THNFeaturedBrandModel *)model {
    if (!model.rid.length) return;
    
    [self setFollowStoreStatus:follow];
    self.storeId = model.rid ? model.rid : model.store_rid;
    self.brandModel = model;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerFollowBrandStatus:(BOOL)follow OffcialStoreModel:(THNOffcialStoreModel *)model {
    if (!model.rid.length) return;
    
    [self setFollowStoreStatus:follow];
    self.storeId = model.rid;
    self.offcialStoreModel = model;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerFollowBrandStatus:(BOOL)follow grassListModel:(THNGrassListModel *)model {
    if (!model.uid.length) return;
    
    [self setFollowStoreStatus:follow];
    self.storeId = model.uid;
    self.grassListModel = model;
    [self addTarget:self action:@selector(followStoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)followStoreAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
    
    if (!self.storeId.length) {
        [SVProgressHUD thn_showInfoWithStatus:@"品牌馆数据错误"];
        return;
    }
    
    [self startLoading];
    
    [self requestFollowStoreWithURL:self.selected ? kURLFollowCancel : kURLFollow
                            storeId:self.storeId
                          completed:^(NSError *error) {
                              [self endLoading];
                              if (error) {
                                  [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
                                  return;
                              }
    }];
}

#pragma mark - private methods
- (void)thn_changeButtonAnimation {
    self.selected = !self.selected;
    self.backgroundColor = self.selected ? self.selectedBgColor : self.normalBgColor;
    [self setTitleEdgeInsets:(UIEdgeInsetsMake(0, self.selected ? 0 : 5, 0, 0))];
    
    self.storeModel.isFollowed = self.selected;
    self.storeModel.followedStatus = self.selected;
    self.brandModel.is_followed = self.selected;
    self.brandModel.is_follow_store = self.selected;
    self.offcialStoreModel.is_followed = self.selected;
    self.grassListModel.is_follow = self.selected;
}

#pragma mark - request
/**
 关注&取消关注店铺
 
 @param url api 地址
 @param storeId 店铺 id
 @param completed 成功后的回调
 */
- (void)requestFollowStoreWithURL:(NSString *)url storeId:(NSString *)storeId completed:(void (^)(NSError *error))completed {
    [self thn_changeButtonAnimation];
    
    THNRequest *request = [THNAPI postWithUrlString:url requestDictionary:@{@"rid": storeId} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            [self thn_changeButtonAnimation];
            completed(nil);
            return ;
        }
        
        if (self.followStoreBlock) {
            self.followStoreBlock(!self.selected);
        }

        if (self.isNeedRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowStoreSuccess" object:nil];
        }
        
        completed(nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        [self thn_changeButtonAnimation];
        completed(error);
    }];
}

@end
