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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keywordViewHeightConstraint;
@property (nonatomic, strong) UILabel *keywordLabel;

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
    [self createLabelWithArray:shopWindowModel.keywords FontSize:12 SpcX:5 SpcY:20];
    self.keywordViewHeightConstraint.constant = CGRectGetMaxY(self.keywordLabel.frame) + 10;
    THNThreeImageStitchingView *threeImageStitchingView = [THNThreeImageStitchingView viewFromXib];
    threeImageStitchingView.frame = self.ImageViewStitchingView.bounds;
    [threeImageStitchingView setThreeImageStitchingView:shopWindowModel.product_covers];
    [self.ImageViewStitchingView addSubview:threeImageStitchingView];
}

//动态添加label方法
- (void)createLabelWithArray:(NSArray *)titleArr FontSize:(CGFloat)fontSize SpcX:(CGFloat)spcX SpcY:(CGFloat)spcY
{
    //创建标签位置变量
    CGFloat positionX = spcX;
    CGFloat positionY = spcY;
    
    //创建label
    for(int i = 0; i < titleArr.count; i++)
    {
        CGSize labelSize = [self getSizeByString:titleArr[i] AndFontSize:fontSize];
        CGFloat labelWidth = labelSize.width;
        
        if (i == 0) {
            positionX = 0;
            positionY = 0;
        } else {
            if (positionX + labelWidth > SCREEN_WIDTH - 40) {
                positionX = 0;
                positionY += spcY;
            }
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positionX, positionY, labelWidth, 24)];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"5FE4B1"];
        positionX += (labelWidth + 5);
        self.keywordLabel = label;
        [self.keywordView addSubview:label];
    }
   
}

//获取字符串长度的方法
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}

- (IBAction)content:(id)sender {
    self.contentBlock();
}

@end
