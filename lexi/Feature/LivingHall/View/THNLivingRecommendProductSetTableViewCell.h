//
//  THNLivingRecommendProductSetTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecommendCellBlcok)(NSString *rid);
typedef void(^LookMoreRecommenDataBlock)(void);

@interface THNLivingRecommendProductSetTableViewCell : UITableViewCell

@property (nonatomic, copy) RecommendCellBlcok recommendCellBlock;
@property (nonatomic, copy) LookMoreRecommenDataBlock lookMoreRecommenDataBlock;
@property (nonatomic, strong) NSString *storeAvatarUrl;
- (void)loadCuratorRecommendedData;
@property (nonatomic, assign) BOOL isMergeRecommendData;

@end
