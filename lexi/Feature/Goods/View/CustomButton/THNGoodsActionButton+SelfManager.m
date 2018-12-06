//
//  THNGoodsActionButton+SelfManager.m
//  lexi
//
//  Created by FLYang on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsActionButton+SelfManager.h"
#import "THNConst.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNLoginManager.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"

/// api 地址
static NSString *const kURLLike       = @"/userlike";
static NSString *const kURLWishlist   = @"/wishlist";
/// key
static NSString *const kKeyRid  = @"rid";
static NSString *const kKeyRids = @"rids";

@implementation THNGoodsActionButton (SelfManager)

- (void)selfManagerLikeGoodsStatus:(BOOL)like goodsId:(NSString *)goodsId {
    if (!goodsId.length) return;
    
    self.goodsId = goodsId;
    [self setLikedGoodsStatus:like];
    [self addTarget:self action:@selector(likeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerLikeGoodsStatus:(BOOL)like count:(NSInteger)count goodsId:(NSString *)goodsId {
    if (!goodsId.length) return;
    
    self.goodsId = goodsId;
    self.likeCount = count;
    [self setLikedGoodsStatus:like count:count];
    [self addTarget:self action:@selector(likeCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerWishGoodsStatus:(BOOL)wish goodsId:(NSString *)goodsId {
    if (!goodsId.length) return;
    
    self.goodsId = goodsId;
    [self setWishGoodsStatus:wish];
    [self addTarget:self action:@selector(wishButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - event response
// 喜欢按钮（不显示喜欢数量的）
- (void)likeButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
    
    [self startLoading];
    
    if (self.selected) {
        [self thn_requestCancelLikeGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
        
            [self setLikedGoodsStatus:NO];
        }];
        
    } else {
        [self thn_requestLikeGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
            
            [self setLikedGoodsStatus:YES];
        }];
    }
}

// 喜欢按钮（显示喜欢数量）
- (void)likeCountButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
    
    [self startLoading];
    
    if (self.selected) {
        [self thn_requestCancelLikeGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
            
            self.likeCount -= 1;
            if (self.likeGoodsCompleted) {
                self.likeGoodsCompleted(self.likeCount);
            }
            [self setLikedGoodsStatus:NO count:self.likeCount];
        }];
        
    } else {
        [self thn_requestLikeGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
            
            self.likeCount += 1;
            if (self.likeGoodsCompleted) {
                self.likeGoodsCompleted(self.likeCount);
            }
            [self setLikedGoodsStatus:YES count:self.likeCount];
        }];
    }
}

// 加入心愿单按钮
- (void)wishButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
    
    [self startLoading];
    
    if (self.selected) {
        [self thn_requestCancelWishGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
            
            self.wishGoodsCompleted(NO);
            [self setWishGoodsStatus:NO];
        }];
        
    } else {
        [self thn_requestWishGoodsCompleted:^(NSError *error) {
            [self endLoading];
            if (error) return;
        
            self.wishGoodsCompleted(YES);
            [self setWishGoodsStatus:YES];
        }];
    }
}

#pragma mark - network
- (void)thn_requestLikeGoodsCompleted:(void (^)(NSError *error))completed {
    THNRequest *request = [THNAPI postWithUrlString:kURLLike requestDictionary:@{kKeyRid: self.goodsId} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

- (void)thn_requestCancelLikeGoodsCompleted:(void (^)(NSError *error))completed {
    THNRequest *reuqest = [THNAPI deleteWithUrlString:kURLLike requestDictionary:@{kKeyRid: self.goodsId} delegate:nil];
    [reuqest startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

- (void)thn_requestWishGoodsCompleted:(void (^)(NSError *error))completed {
    THNRequest *request = [THNAPI postWithUrlString:kURLWishlist requestDictionary:@{kKeyRids: @[self.goodsId]} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

- (void)thn_requestCancelWishGoodsCompleted:(void (^)(NSError *error))completed {
    THNRequest *reuqest = [THNAPI deleteWithUrlString:kURLWishlist requestDictionary:@{kKeyRids: @[self.goodsId]} delegate:nil];
    [reuqest startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

@end
