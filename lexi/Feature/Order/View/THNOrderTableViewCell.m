//
//  THNOrderTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderTableViewCell.h"
#import "UIView+Helper.h"
#import "THNOrderProductTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNOrderStoreModel.h"
#import "THNOrdersModel.h"
#import "NSString+Helper.h"
#import "UIColor+Extension.h"
#import "THNOrdersItemsModel.h"
#import <MJExtension/MJExtension.h>
#import "THNMarco.h"

static NSString *const kOrderSubCellIdentifier = @"kOrderSubCellIdentifier";
CGFloat orderProductCellHeight = 75;
CGFloat orderCellLineSpacing = 10;

@interface THNOrderTableViewCell()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 订单状态Label
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
// 订单金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *borderButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderButtonRightConstraint;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString *countDownText;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payCountDownTextLabel;

@property (nonatomic, assign) BOOL isAddTimer;

@end


@implementation THNOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.storeImageView drawCornerWithType:0 radius:4];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderProductTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderSubCellIdentifier];
    [self.payView drawCornerWithType:0 radius:4];
    [self borderButtonStyle];
    [self backgroundButtonStyle];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += orderCellLineSpacing;
    frame.size.height -= orderCellLineSpacing;
    [super setFrame:frame];
}

- (void)setOrdersModel:(THNOrdersModel *)ordersModel {
    _ordersModel = ordersModel;
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:ordersModel.store.store_logo]];
    self.nameLabel.text = ordersModel.store.store_name;
    self.dateLabel.text = [NSString timeConversion:ordersModel.created_at initWithFormatterType:FormatterDay];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", ordersModel.pay_amount];
    self.payView.hidden = YES;

    switch (ordersModel.user_order_status) {
            
        case OrderStatusWaitDelivery:
            self.statusLabel.text = @"待发货";
            [self.borderButton setTitle:@"物流追踪" forState:UIControlStateNormal];
            [self.backgroundButton setTitle:@"确认收货" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 80;
            self.borderButtonRightConstraint.constant = 15;
            self.backgroundButton.hidden = NO;
            break;
        case OrderStatusReceipt:
            self.statusLabel.text = @"待收货";
            [self.borderButton setTitle:@"物流追踪" forState:UIControlStateNormal];
            [self.backgroundButton setTitle:@"确认收货" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 80;
            self.borderButtonRightConstraint.constant = 15;
            self.backgroundButton.hidden = NO;
            break;
        case OrderStatusCancel:
            self.statusLabel.text = @"交易取消";
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 0;
            self.borderButtonRightConstraint.constant = 0;
            self.backgroundButton.hidden = YES;
            break;
        case OrderStatuspayment:
            self.payView.hidden = NO;
            self.statusLabel.text = @"去付款";
            
            NSLog(@"============ %@", self.payCountDownTextLabel.text);
            if (self.payCountDownTextLabel.text.length == 0) {
                self.timeInterval = 600 - [NSString comparisonStartTimestamp:ordersModel.created_at endTimestamp:ordersModel.current_time];
                // 十分钟的倒计时显示的值
                self.countDownText = [NSString stringWithNSTimeInterval:self.timeInterval];
                self.payCountDownTextLabel.text = self.countDownText;
                [self addTimer];
            }
            
            self.borderButton.hidden = YES;
            self.backgroundButton.hidden = YES;
            break;
        case OrderStatusEvaluation:
            self.statusLabel.text = @"交易成功";
            [self.backgroundButton setTitle:@"去评价" forState:UIControlStateNormal];
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 80;
            self.borderButtonRightConstraint.constant = 15;
            self.backgroundButton.hidden = NO;
            break;
        case OrderStatusFinish:
            self.statusLabel.text = @"交易成功";
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 0;
            self.borderButtonRightConstraint.constant = 0;
            self.backgroundButton.hidden = YES;
            break;
    }
    
    [self.tableView reloadData];
}

- (void)addTimer {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)countDown {
    self.timeInterval--;
    
    if (self.timeInterval == 0) {
        self.countDownBlock(self);
        return;
    }
    
    self.countDownText = [NSString stringWithNSTimeInterval:self.timeInterval];
    self.payCountDownTextLabel.text = self.countDownText;
}

- (IBAction)pay:(id)sender {
}

// 边框按钮样式
- (void)borderButtonStyle {
    [self.borderButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.borderButton.layer.borderWidth = 1;
    self.borderButton.layer.cornerRadius = 8;
    self.borderButton.layer.borderColor = [[UIColor colorWithHexString:@"999999"]CGColor];
    self.borderButton.backgroundColor = [UIColor whiteColor];
}

// 背景色按钮样式
- (void)backgroundButtonStyle {
    [self.backgroundButton drawCornerWithType:0 radius:4];
    self.backgroundButton.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
    [self.backgroundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ordersModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    THNOrdersItemsModel *itemModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.ordersModel.items[indexPath.row]];
    [cell setItemModel:itemModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return orderProductCellHeight;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
