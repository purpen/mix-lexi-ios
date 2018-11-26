//
//  THNLifeActionView.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNLifeActionType) {
    THNLifeActionTypeText = 0,  //  提示文字
    THNLifeActionTypeImage,     //  展示图片
    THNLifeActionTypeCash,      //  提现
};

@protocol THNLifeActionViewDelegate <NSObject>

@optional
- (void)thn_lifeStoreSaveImage:(UIImage *)image;
- (void)thn_lifeStoreCashMoney;
- (void)thn_lifeStoreDismissView;

@end

@interface THNLifeActionView : UIView

@property (nonatomic, weak) id <THNLifeActionViewDelegate> delegate;

// 提现金额
- (void)thn_setCashMoney:(CGFloat)cashMoney serviceMoney:(CGFloat)serviceMoney;

- (void)showViewWithType:(THNLifeActionType)type;

@end
