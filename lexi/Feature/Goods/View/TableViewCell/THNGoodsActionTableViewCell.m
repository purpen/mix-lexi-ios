//
//  THNGoodsActionTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsActionTableViewCell.h"
#import "THNGoodsActionButton.h"
#import "THNGoodsActionButton+SelfManager.h"
#import "NSString+Helper.h"
#import "YYLabel+Helper.h"
#import "THNMarco.h"
#import "THNLoginManager.h"

static NSString *const kGoodsActionTableViewCellId = @"kGoodsActionTableViewCellId";

@interface THNGoodsActionTableViewCell ()

/// 喜欢按钮
@property (nonatomic, strong) THNGoodsActionButton *likeButton;
/// 加入心愿单按钮
@property (nonatomic, strong) THNGoodsActionButton *wishButton;
/// 喜欢按钮
@property (nonatomic, strong) THNGoodsActionButton *putawayButton;
/// 是否是上架商品
@property (nonatomic, assign) BOOL canPutaway;
/// 是否上架过
@property (nonatomic, assign) BOOL hasPutaway;
/// 喜欢人数的宽度
@property (nonatomic, assign) CGFloat likeCountW;

@end

@implementation THNGoodsActionTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsActionTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsActionTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsActionTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setActionButtonWithGoodsModel:(THNGoodsModel *)model {
    self.goodsModel = model;
    
    if ([THNLoginManager sharedManager].openingUser && model.isDistributed) {
        self.canPutaway = YES;
        self.hasPutaway = model.haveDistributed;
    }
    
    self.likeCountW = [self thn_getLikeButtonWidthWithLikeCount:model.likeCount];
    
    [self setNeedsUpdateConstraints];
    
    WEAKSELF;
    
    [self.likeButton selfManagerLikeGoodsStatus:model.isLike count:model.likeCount goodsId:model.rid];
    self.likeButton.likeGoodsCompleted = ^(NSInteger count) {
        weakSelf.likeCountW = [weakSelf thn_getLikeButtonWidthWithLikeCount:count];
        weakSelf.baseCell.selectedCellBlock(@"");
        weakSelf.goodsModel.isLike = !weakSelf.goodsModel.isLike;
        weakSelf.goodsModel.likeCount = count;
        
        [weakSelf setNeedsUpdateConstraints];
    };
    
    [self.wishButton selfManagerWishGoodsStatus:model.isWish goodsId:model.rid];
    self.wishButton.wishGoodsCompleted = ^(BOOL isWish) {
        weakSelf.goodsModel.isWish = isWish;
        
        [weakSelf setNeedsUpdateConstraints];
    };
    
    [self.putawayButton setPutawayGoodsStauts:model.haveDistributed];
    self.putawayButton.hidden = !self.canPutaway;
}

#pragma mark - event response
- (void)putawayButtonAction:(UIButton *)button {
    if (self.hasPutaway) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_putawayProduct)]) {
        [self.delegate thn_putawayProduct];
    }
}

#pragma mark - private methods
- (CGFloat)thn_getLikeButtonWidthWithLikeCount:(NSInteger)likeCount {
    NSString *countStr = likeCount > 0 ? [NSString stringWithFormat:@"+%zi", likeCount] : @"喜欢";
    
    return [countStr boundingSizeWidthWithFontSize:13];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.likeButton];
    [self addSubview:self.wishButton];
    [self addSubview:self.putawayButton];
}

- (void)updateConstraints {
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.likeCountW + 40, 29));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
    }];
    
    [self.wishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.goodsModel.isWish ? 63 : 79, 29));
        make.right.mas_equalTo(self.canPutaway ? -92 : -15);
        make.centerY.equalTo(self.likeButton);
    }];
    
    [self.putawayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(67, 29));
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.likeButton);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (THNGoodsActionButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeLikeCount)];
    }
    return _likeButton;
}

- (THNGoodsActionButton *)wishButton {
    if (!_wishButton) {
        _wishButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeWish)];
    }
    return _wishButton;
}

- (THNGoodsActionButton *)putawayButton {
    if (!_putawayButton) {
        _putawayButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypePutaway)];
        [_putawayButton addTarget:self action:@selector(putawayButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _putawayButton;
}

@end
