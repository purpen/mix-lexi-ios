//
//  THNBrandHallHeaderView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNBrandHallHeaderViewDelegate<NSObject>

@optional
- (void)showProduct;
- (void)showLifeRecords;
- (void)pushBrandHallStory:(NSString *)rid;

@end

@class THNOffcialStoreModel;

@interface THNBrandHallHeaderView : UIView

@property (nonatomic, strong) THNOffcialStoreModel *offcialStoreModel;
@property (nonatomic, weak) id <THNBrandHallHeaderViewDelegate> delegate;

@end
