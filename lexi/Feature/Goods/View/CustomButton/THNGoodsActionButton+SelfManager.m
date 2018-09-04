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
    if (self.selected) {
        [self thn_requestCancelLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected count:self.likeCount - 1];
            self.likeCount -= 1;
        }];
        
    } else {
        [self thn_requestLikeGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setLikedGoodsStatus:self.selected count:self.likeCount + 1];
            self.likeCount += 1;
        }];
    }
}

- (void)wishButtonAction:(id)sender {
    if (self.selected) {
        [self thn_requestCancelWishGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setWishGoodsStatus:self.selected];
        }];
        
    } else {
        [self thn_requestWishGoodsCompleted:^(NSError *error) {
            if (error) return;
            
            self.selected = !self.selected;
            [self setWishGoodsStatus:self.selected];
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
