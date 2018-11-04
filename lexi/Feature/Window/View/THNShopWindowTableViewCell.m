//
//  THNShopWindowTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowTableViewCell.h"
#import "THNThreeImageStitchingView.h"
#import "THNFiveImagesStitchView.h"
#import "THNSevenImagesStitchView.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNShopWindowModel.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "UIImageView+SDWedImage.h"
#import "THNFollowUserButton+SelfManager.h"

CGFloat threeImageHeight = 250;
CGFloat fiveToGrowImageHeight = 140;
CGFloat sevenToGrowImageHeight = 90;

@interface THNShopWindowTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *ImageViewStitchingView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;
@property (weak, nonatomic) IBOutlet THNFollowUserButton *flowButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIView *keywordView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keywordViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewStitchingViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (nonatomic, strong) UILabel *keywordLabel;
@property (nonatomic, strong) THNThreeImageStitchingView *threeImageStitchingView;
@property (nonatomic, strong) THNFiveImagesStitchView *fiveImagesStitchingView;
@property (nonatomic, strong) THNSevenImagesStitchView *sevenImagesStitchingView;

@end

@implementation THNShopWindowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.flowButton setupViewUI];
    [self.flowButton drawCornerWithType:0 radius:4];
}

- (void)setShopWindowModel:(THNShopWindowModel *)shopWindowModel {
    _shopWindowModel = shopWindowModel;
    self.nameLabel.text = shopWindowModel.user_name;
    [self.avatarImageView thn_setCircleImageWithUrlString:shopWindowModel.user_avatar placeholder:[UIImage imageNamed:@"default_image_place"]];
    self.titleLabel.text = shopWindowModel.title;
    self.desLabel.text = shopWindowModel.des;
    [self createLabelWithArray:shopWindowModel.keywords FontSize:12 SpcX:5 SpcY:20];
    self.keywordViewHeightConstraint.constant = CGRectGetMaxY(self.keywordLabel.frame);
    self.likeLabel.hidden = shopWindowModel.like_count == 0 ?: NO;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld喜欢",shopWindowModel.like_count];
    self.commentLabel.hidden = shopWindowModel.comment_count == 0 ?: NO;
    self.commentLabel.text = [NSString stringWithFormat:@"%ld条评论",shopWindowModel.comment_count];
    
    if (self.likeLabel.hidden == YES && self.commentLabel.hidden == YES) {
        self.titleLabelTopConstraint.constant = -15;
    }
    
    if ([self.flag isEqualToString:@"shopWindowDetail"]) {
        [self hiddenShowWindowDetail];
    }
    
    if (shopWindowModel.is_official) {
        self.identityImageView.image = [UIImage imageNamed:@"icon_official"];
    } else {
        self.identityImageView.image = [UIImage imageNamed:@"icon_talent"];
    }
    
    switch (self.imageType) {
        case ShopWindowImageTypeThree:
            self.imageViewStitchingViewHeightConstraint.constant = threeImageHeight;
            [self.threeImageStitchingView setThreeImageStitchingView:shopWindowModel.product_covers];
            [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
            break;
        case ShopWindowImageTypeFive:
            self.imageViewStitchingViewHeightConstraint.constant = threeImageHeight + fiveToGrowImageHeight;
            [self.ImageViewStitchingView addSubview:self.fiveImagesStitchingView];
            [self.fiveImagesStitchingView setFiveImageStitchingView:shopWindowModel.product_covers];
            break;
        case ShopWindowImageTypeSeven:
            self.imageViewStitchingViewHeightConstraint.constant = threeImageHeight + sevenToGrowImageHeight;
            [self.ImageViewStitchingView addSubview:self.sevenImagesStitchingView];
            [self.sevenImagesStitchingView setSevenImageStitchingView:shopWindowModel.product_covers];
            break;
    }
    
    // 业务隐藏
    self.likeLabel.hidden = YES;
    self.commentLabel.hidden = YES;
    self.buttonView.hidden = YES;
    self.titleLabelTopConstraint.constant = -35;
    [self.flowButton selfManagerFollowUserStatus:shopWindowModel.is_follow shopWindowModel:shopWindowModel];
    
}

// 隐藏橱窗详情橱窗Cell与当前Cell不同点
- (void)hiddenShowWindowDetail {
    self.desLabel.numberOfLines = 0;
    [self.threeImageStitchingView removeFromSuperview];
    self.likeLabel.hidden = YES;
    self.commentLabel.hidden = YES;
    self.buttonView.hidden = YES;
    self.titleLabelTopConstraint.constant = -35;
}

//动态添加label方法
- (void)createLabelWithArray:(NSArray *)titleArr FontSize:(CGFloat)fontSize SpcX:(CGFloat)spcX SpcY:(CGFloat)spcY
{
    // 清空子视图
    [self.keywordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建标签位置变量
    CGFloat positionX = spcX;
    CGFloat positionY = spcY;
    
    //创建label
    for(int i = 0; i < titleArr.count; i++)
    {
        CGSize labelSize = [self getSizeByString:titleArr[i] AndFontSize:fontSize];
        CGFloat labelWidth = labelSize.width + 20;
        
        if (i == 0) {
            positionX = -10;
            positionY = 0;
        } else {
            if (positionX + labelWidth > SCREEN_WIDTH - 40) {
                positionX = 0;
                positionY += spcY;
            }
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positionX, positionY, labelWidth, 24)];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text = [NSString stringWithFormat:@"#%@",titleArr[i]];
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

#pragma mark - lazy
- (THNThreeImageStitchingView *)threeImageStitchingView {
    if (!_threeImageStitchingView) {
        _threeImageStitchingView = [THNThreeImageStitchingView viewFromXib];
        _threeImageStitchingView.frame = self.ImageViewStitchingView.bounds;
    }
    return _threeImageStitchingView;
}

- (THNFiveImagesStitchView *)fiveImagesStitchingView {
    if (!_fiveImagesStitchingView) {
        _fiveImagesStitchingView = [THNFiveImagesStitchView viewFromXib];
        _fiveImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
    }
    return _fiveImagesStitchingView;
}

- (THNSevenImagesStitchView *)sevenImagesStitchingView {
    if (!_sevenImagesStitchingView) {
        _sevenImagesStitchingView = [THNSevenImagesStitchView viewFromXib];
        _sevenImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
    }
    return _sevenImagesStitchingView;
}

@end
