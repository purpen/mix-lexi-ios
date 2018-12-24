//
//  THNLivingHallRecommendTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNProductModel;

typedef void(^DeleteProductBlock)(UITableViewCell *cell);
typedef void(^ShareProductBlock)(THNProductModel *)productModel;

@class THNProductModel;

@interface THNLivingHallRecommendTableViewCell : UITableViewCell

@property (nonatomic, strong) THNProductModel *productModel;
- (void)setCurtorAvatar:(NSString *)storeAvatarUrl;
- (void)loadLikeProductUserData:(NSString *)rid;
@property (nonatomic, copy) DeleteProductBlock deleteProductBlock;
@property (nonatomic, copy) ShareProductBlock shareProductBlock;
@property (weak, nonatomic) IBOutlet UIButton *changeLikeStatuButton;

@end
