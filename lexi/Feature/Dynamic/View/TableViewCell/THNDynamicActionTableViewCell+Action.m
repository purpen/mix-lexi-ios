//
//  THNDynamicActionTableViewCell+Action.m
//  lexi
//
//  Created by FLYang on 2018/11/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicActionTableViewCell+Action.h"
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"
#import "THNCommentViewController.h"

/// url
static NSString *const kURLLikeDynamic = @"/shop_windows/user_likes";
/// key
static NSString *const kKeyRid = @"rid";

@implementation THNDynamicActionTableViewCell (Action)

- (void)thn_likeDynamicWithStatusWithModel:(THNDynamicModelLines *)model {
    self.likeButton.selected = model.isLike;
    [self.likeButton addTarget:self action:@selector(likeDynamicAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)thn_checkDynamicComment {
    [self.commentButton addTarget:self action:@selector(commentDynamicAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - event response
- (void)likeDynamicAction:(UIButton *)button {
    [self thn_dynamicLikeButtonSelected:!button.selected];
    
    if (!button.selected) {
        [self requestCancelLikeDynamic];
        
    } else {
        [self requestLikeDynamic];
    }
}

- (void)commentDynamicAction:(UIButton *)button {
    if (!self.dynamicRid.length) return;
    
    THNCommentViewController *commentVC = [[THNCommentViewController alloc] init];
    commentVC.rid = self.dynamicRid;
    commentVC.isFromShopWindow = YES;
    [self.currentVC.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - private methods
- (void)thn_dynamicLikeButtonSelected:(BOOL)selected {
    self.likeButton.selected = selected;
    
    NSInteger likeCount = [self.likeButton.titleLabel.text integerValue];
    likeCount += selected ? 1 : -1;
    NSString *likeCountStr = [NSString stringWithFormat:@"%zi", likeCount];
    
    [self.likeButton setTitle:likeCountStr forState:(UIControlStateNormal)];
    
    self.dynamicModel.likeCount = likeCount;
    self.dynamicModel.isLike = selected;
}

#pragma mark - network
- (void)requestLikeDynamic {
    if (!self.dynamicRid.length) return;
    
    THNRequest *request = [THNAPI postWithUrlString:kURLLikeDynamic requestDictionary:@{kKeyRid: self.dynamicRid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) return;
        
        [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
        [self thn_dynamicLikeButtonSelected:NO];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        [self thn_dynamicLikeButtonSelected:NO];
    }];
}

- (void)requestCancelLikeDynamic {
    if (!self.dynamicRid.length) return;
    
    THNRequest *request = [THNAPI deleteWithUrlString:kURLLikeDynamic requestDictionary:@{kKeyRid: self.dynamicRid} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) return;
        
        [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
        [self thn_dynamicLikeButtonSelected:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        [self thn_dynamicLikeButtonSelected:YES];
    }];
}

@end
