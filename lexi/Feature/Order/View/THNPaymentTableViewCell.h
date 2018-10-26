//
//  THNPaymentTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, THNPaymentType) {
    THNPaymentTypeWechat = 0,   // 微信支付
    THNPaymentTypeAlipay,       // 支付宝
    THNPaymentTypeHuabei,       // 花呗
};

@interface THNPaymentTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelectedPayment;

- (void)thn_setPaymentTypeWithType:(THNPaymentType)type;

+ (instancetype)initPaymentCellWithTableView:(UITableView *)tableView;

@end
