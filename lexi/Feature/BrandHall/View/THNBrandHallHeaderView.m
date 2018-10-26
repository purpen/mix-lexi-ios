//
//  THNBrandHallHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallHeaderView.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNOffcialStoreModel.h"
#import "UIColor+Extension.h"
#import "THNFollowStoreButton+SelfManager.h"

@interface THNBrandHallHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTintLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleTintLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet THNFollowStoreButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *designHallButton;

@end

@implementation THNBrandHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.productImageView drawCornerWithType:0 radius:4];
    self.followButton.layer.cornerRadius = self.followButton.viewHeight / 2;
    self.designHallButton.layer.cornerRadius = self.designHallButton.viewHeight / 2;
    [self.followButton setupViewUI];
    [self drwaShadow];
}

- (void)setOffcialStoreModel:(THNOffcialStoreModel *)offcialStoreModel {
    _offcialStoreModel = offcialStoreModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:offcialStoreModel.logo] placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.productLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.product_count];
    self.articleLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.life_record_count];
    self.fanLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.fans_count];
    self.addressLabel.text = offcialStoreModel.city;
    self.desLabel.text = offcialStoreModel.tag_line;
    self.nameLabel.text = offcialStoreModel.name;
    [self.followButton selfManagerFollowStoreStatus:offcialStoreModel.is_followed storeRid:offcialStoreModel.rid];
}

- (IBAction)productButton:(id)sender {
    self.productLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
    self.productTintLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
    self.articleLabel.textColor = [UIColor colorWithHexString:@"949EA6"];
    self.articleTintLabel.textColor = [UIColor colorWithHexString:@"949EA6"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showProduct)]) {
        [self.delegate showProduct];
    }
}
- (IBAction)articleButton:(id)sender {
    self.articleLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
    self.articleTintLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
    self.productLabel.textColor = [UIColor colorWithHexString:@"949EA6"];
    self.productTintLabel.textColor = [UIColor colorWithHexString:@"949EA6"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLifeRecords)]) {
        [self.delegate showLifeRecords];
    }
}

- (IBAction)lookBrandHallStory:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushBrandHallStory:)]) {
        [self.delegate pushBrandHallStory:self.offcialStoreModel.rid];
    }
}

@end
