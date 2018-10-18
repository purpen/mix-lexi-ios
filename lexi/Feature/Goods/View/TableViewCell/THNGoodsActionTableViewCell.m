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

static NSString *const kGoodsActionTableViewCellId = @"kGoodsActionTableViewCellId";

@interface THNGoodsActionTableViewCell () {
    BOOL _isStatus;
}

/// 喜欢按钮
@property (nonatomic, strong) THNGoodsActionButton *likeButton;
/// 加入心愿单按钮
@property (nonatomic, strong) THNGoodsActionButton *wishButton;
/// 喜欢按钮
@property (nonatomic, strong) THNGoodsActionButton *putawayButton;
/// 是否可以上架商品
@property (nonatomic, assign) BOOL canPutaway;
/// 是否已加入心愿单
@property (nonatomic, assign) BOOL isWish;
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

- (void)thn_setActionButtonWithGoodsModel:(THNGoodsModel *)model canPutaway:(BOOL)putaway {
    if (_isStatus) return;
    
    _isStatus = YES;
    
    self.canPutaway = putaway;
    self.isWish = model.isWish;
    self.likeCountW = [self thn_getLikeButtonWidthWithLikeCount:model.likeCount];
    
    WEAKSELF;
    
    [self.likeButton selfManagerLikeGoodsStatus:model.isLike count:model.likeCount goodsId:model.rid];
    self.likeButton.likeGoodsCompleted = ^(NSInteger count) {
        weakSelf.likeCountW = [weakSelf thn_getLikeButtonWidthWithLikeCount:count];
        weakSelf.baseCell.selectedCellBlock(@"");
    };
    
    [self.wishButton selfManagerWishGoodsStatus:model.isWish goodsId:model.rid];
    self.wishButton.wishGoodsCompleted = ^(BOOL isWish) {
        weakSelf.isWish = isWish;
    };
    
    [self.putawayButton setPutawayGoodsStauts:putaway];
    
    [self layoutIfNeeded];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.likeCountW + 40, 29));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
    }];

    [self.wishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.isWish ? 63 : 79, 29));
        make.right.mas_equalTo(self.canPutaway ? -92 : -15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
    
    self.putawayButton.hidden = !self.canPutaway;
    if (self.canPutaway) {
        [self.putawayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.canPutaway ? 67 : 0, 29));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.likeButton);
        }];
    }
}

#pragma mark - getters and setters
- (THNGoodsActionButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeLikeCount)];
        _likeButton.currentController = self.currentController;
    }
    return _likeButton;
}

- (THNGoodsActionButton *)wishButton {
    if (!_wishButton) {
        _wishButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeWish)];
        _wishButton.currentController = self.currentController;
    }
    return _wishButton;
}

- (THNGoodsActionButton *)putawayButton {
    if (!_putawayButton) {
        _putawayButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypePutaway)];
    }
    return _putawayButton;
}

@end
