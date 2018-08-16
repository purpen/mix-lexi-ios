//
//  THNShopWindowTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowTableViewCell.h"
#import "THNThreeImageStitchingView.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNShopWindowModel.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>
#import "UIColor+Extension.h"
#import "THNMarco.h"

@interface THNShopWindowTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *ImageViewStitchingView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;
@property (weak, nonatomic) IBOutlet UIButton *flowButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIView *keywordView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewHeightConstraint;

@end

@implementation THNShopWindowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setShopWindowModel:(THNShopWindowModel *)shopWindowModel {
    _shopWindowModel = shopWindowModel;
    self.nameLabel.text = shopWindowModel.user_name;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:shopWindowModel.user_avatar]];
    self.likeLabel.text = [NSString stringWithFormat:@"%ld喜欢",shopWindowModel.like_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%ld条评论",shopWindowModel.comment_count];
    self.titleLabel.text = shopWindowModel.title;
    self.desLabel.text = shopWindowModel.des;
    __block CGFloat labelX = 0;
    __block CGFloat labelY = 0;
    [shopWindowModel.keywords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc]init];
        label.text = obj;
        label.textColor = [UIColor colorWithHexString:@"5FE4B1"];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        CGSize labelSize = [obj sizeWithAttributes:@{NSFontAttributeName:label.font}];
        label.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
        [self.keywordView addSubview:label];
        labelX += labelSize.width + 5;
        NSLog(@"%.2f",CGRectGetMaxX(label.frame));
        if (CGRectGetMaxX(label.frame) > SCREEN_WIDTH - 40 -labelSize.width) {
            labelX = 0;
            labelY += 20;
        }
        self.buttonViewHeightConstraint.constant = CGRectGetMaxY(label.frame);
    }];
    
    THNThreeImageStitchingView *threeImageStitchingView = [THNThreeImageStitchingView viewFromXib];
    threeImageStitchingView.frame = self.ImageViewStitchingView.bounds;
    [threeImageStitchingView setThreeImageStitchingView:shopWindowModel.product_covers];
    [self.ImageViewStitchingView addSubview:threeImageStitchingView];
}


@end
