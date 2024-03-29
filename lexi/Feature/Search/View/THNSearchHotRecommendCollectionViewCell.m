//
//  THNSearchHotRecommendCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchHotRecommendCollectionViewCell.h"
#import "UIImageView+WebImage.h"
#import "THNSearchHotRecommendModel.h"
#import "UIView+Helper.h"

@interface THNSearchHotRecommendCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation THNSearchHotRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.brandImageView drawCornerWithType:0 radius:self.brandImageView.viewHeight / 2];
}

- (void)setHotRecommentModel:(THNSearchHotRecommendModel *)hotRecommentModel {
    _hotRecommentModel = hotRecommentModel;
    
    if (!hotRecommentModel.recommend_cover) {
        self.brandImageView.image = [UIImage imageNamed:@"icon_search_customization"];
        
    } else {
        [self.brandImageView loadImageWithUrl:[hotRecommentModel.recommend_cover loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                     circular:YES];
    }
    
    self.nameLabel.text = hotRecommentModel.recommend_title;
}

@end
