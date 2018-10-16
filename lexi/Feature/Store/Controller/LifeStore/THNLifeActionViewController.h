//
//  THNLifeActionViewController.h
//  lexi
//
//  Created by FLYang on 2018/10/15.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNLifeActionType) {
    THNLifeActionTypeText = 0,  //  提示文字
    THNLifeActionTypeImage,     //  展示图片
    THNLifeActionTypeCash,      //  提现
};

@interface THNLifeActionViewController : THNBaseViewController

// 提示文字
@property (nonatomic, strong) NSString *hintText;
// 展示图片
@property (nonatomic, strong) UIImage *showImage;
// 提现金额
- (void)thn_setCashMoney:(CGFloat)cashMoney serviceMoney:(CGFloat)serviceMoney;

- (instancetype)initWithType:(THNLifeActionType)type;

@end
