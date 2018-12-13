//
//  THNLivingHallHeaderView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeHeaderViewBlock)(void);
typedef void(^PushProductCenterBlock)(void);
typedef void(^EditStoreLogoBlock)(void);
typedef void(^LivingHallShareBlock)(void);
typedef void(^LoadLifeStoreDataSuccessBlock)(BOOL isHaveRecommendData);

@interface THNLivingHallHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *noProductView;

- (void)setLifeStore;
- (void)loadLifeStoreData:(LoadLifeStoreDataSuccessBlock)lifeStoreDataSuccess;
@property (nonatomic, strong) NSString *storeAvatarUrl;
@property (nonatomic, copy) ChangeHeaderViewBlock changeHeaderViewBlock;
@property (nonatomic, copy) PushProductCenterBlock pushProductCenterBlock;
@property (nonatomic, copy) EditStoreLogoBlock storeLogoBlock;
@property (nonatomic, copy) LivingHallShareBlock livingHallShareBlock;
@property (weak, nonatomic) IBOutlet UIView *promptView;
- (void)setHeaderImageWithData:(NSData *)imageData;
- (void)setHeaderAvatarId:(NSInteger)idx;

@end
