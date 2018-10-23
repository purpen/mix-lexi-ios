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
static NSString *const kKeyRid = @"rid";
static NSString *const kKeyRids = @"rids";

@implementation THNGoodsActionButton (SelfManager)

- (void)selfManagerLikeGoodsStatus:(BOOL)like goodsId:(NSString *)goodsId {
    self.goodsId = goodsId;
    [self setLikedGoodsStatus:like];
    [self addTarget:self action:@selector(likeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerLikeGoodsStatus:(BOOL)like count:(NSInteger)count goodsId:(NSString *)goodsId {
    self.goodsId = goodsId;
    self.likeCount = count;
    [self setLikedGoodsStatus:like count:count];
    [self addTarget:self action:@selector(likeCountButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)selfManagerWishGoodsStatus:(BOOL)wish goodsId:(NSString *)goodsId {
    self.goodsId = goodsId;
    [self setWishGoodsStatus:wish];
    [self addTarget:self action:@selector(wishButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - event response
- (void)likeButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [self thn_openUserLoginController];
        return;
    }
    
    if (self.selected) {
        [self thn_requestCancelLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected];
        }];
        
    } else {
        [self thn_requestLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected];
        }];
    }
}

- (void)likeCountButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [self thn_openUserLoginController];
        return;
    }
    
    if (self.selected) {
        [self thn_requestCancelLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected count:self.likeCount - 1];
            self.likeCount -= 1;
            self.likeGoodsCompleted(self.likeCount);
        }];
        
    } else {
        [self thn_requestLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected count:self.likeCount + 1];
            self.likeCount += 1;
            self.likeGoodsCompleted(self.likeCount);
        }];
    }
}

- (void)wishButtonAction:(id)sender {
    if (![THNLoginManager isLogin]) {
        [self thn_openUserLoginController];
        return;
    }
    
    if (self.selected) {
        [self thn_requestCancelWishGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setWishGoodsStatus:self.selected];
            self.wishGoodsCompleted(self.selected);
        }];
        
    } else {
        [self thn_requestWishGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setWishGoodsStatus:self.selected];
            self.wishGoodsCompleted(self.selected);
        }];
    }
}

#pragma mark - event response
/**
 打开登录视图
 */
- (void)thn_openUserLoginController {
    dispatch_async(dispatch_get_main_queue(), ^{
        THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
        THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNavController
                                                                                     animated:YES
                                                                                   completion:nil];
    });
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
    NSArray *rids = @[self.goodsId];
    THNRequest *request = [THNAPI postWithUrlString:kURLWishlist requestDictionary:@{kKeyRids: rids} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

- (void)thn_requestCancelWishGoodsCompleted:(void (^)(NSError *error))completed {
    NSArray *rids = @[self.goodsId];
    THNRequest *reuqest = [THNAPI deleteWithUrlString:kURLWishlist requestDictionary:@{kKeyRids: rids} delegate:nil];
    [reuqest startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.success) {
            completed(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completed(error);
    }];
}

@end
