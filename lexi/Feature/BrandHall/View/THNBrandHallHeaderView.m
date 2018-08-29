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

@interface THNBrandHallHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *designHallButton;

@end

@implementation THNBrandHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.followButton.layer.cornerRadius = self.followButton.viewHeight / 2;
    self.designHallButton.layer.cornerRadius = self.designHallButton.viewHeight / 2;
    [self drwaShadow];
}

- (void)setOffcialStoreModel:(THNOffcialStoreModel *)offcialStoreModel {
    _offcialStoreModel = offcialStoreModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:offcialStoreModel.bgcover]];
    self.productLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.product_count];
    self.articleLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.life_record_count];
    self.fanLabel.text = [NSString stringWithFormat:@"%ld",offcialStoreModel.fans_count];
    self.addressLabel.text = offcialStoreModel.city;
    self.desLabel.text = offcialStoreModel.tag_line;
}

- (IBAction)productButton:(id)sender {
    
}
- (IBAction)articleButton:(id)sender {
    
}

@end
