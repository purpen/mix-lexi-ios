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
#import "UIImageView+WebImage.h"
#import "THNOrderStoreModel.h"
#import "THNOrdersModel.h"
#import "NSString+Helper.h"
#import "UIColor+Extension.h"
#import "THNOrdersItemsModel.h"
#import <MJExtension/MJExtension.h>
#import "THNMarco.h"
#import "THNConst.h"
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"
#import "THNObtainedView.h"
#import <WXApi.h>
#import "THNOrderPayView.h"
#import "THNOrderDetailModel.h"
#import "THNPayManger.h"

static NSString *const kOrderSubCellIdentifier = @"kOrderSubCellIdentifier";
static NSString *const kUrlOrdersIsMergePay = @"/orders/app_pay/is_merge";
static NSString *const kUrlOrdersSigned = @"/orders/signed";
CGFloat kOrderProductViewHeight = 75;
CGFloat kOrderLogisticsViewHeight = 49;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundHeightConstraint;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString *countDownText;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payCountDownTextLabel;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, assign) BOOL isAddTimer;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) THNOrdersItemsModel *itemModel;
@property (nonatomic, strong) THNOrderPayView *orderPayView;

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

// 确认收货
- (void)loadOrdersSignedData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.ordersModel.rid;
    
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrdersSigned requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        [SVProgressHUD dismissWithCompletion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(confirmReceipt)]) {
                [self.delegate confirmReceipt];
            }
        }];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setOrdersModel:(THNOrdersModel *)ordersModel {
    _ordersModel = ordersModel;
    
    [self.storeImageView loadImageWithUrl:[ordersModel.store.store_logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.nameLabel.text = ordersModel.store.store_name;
    self.dateLabel.text = [NSString timeConversion:ordersModel.created_at initWithFormatterType:FormatterDay];
    self.moneyLabel.text = [NSString formatFloat:ordersModel.user_pay_amount];
    self.payView.hidden = YES;
    self.lineView.hidden = YES;
    self.backGroundHeightConstraint.constant = 30;

    switch (ordersModel.user_order_status) {
            
        case OrderStatusWaitDelivery:
            self.statusLabel.text = @"待发货";
            self.backGroundHeightConstraint.constant = 0;
            self.backgroundButton.hidden = YES;
            self.borderButton.hidden = YES;
            break;
        case OrderStatusReceipt:
            self.statusLabel.text = @"待收货";
            [self.borderButton setTitle:@"物流追踪" forState:UIControlStateNormal];
            [self.backgroundButton setTitle:@"确认收货" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 80;
            self.borderButtonRightConstraint.constant = 15;
            self.backgroundButton.hidden = NO;
            self.borderButton.hidden = NO;
            break;
        case OrderStatusCancel:
            self.statusLabel.text = @"交易取消";
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 0;
            self.borderButtonRightConstraint.constant = 0;
            self.backgroundButton.hidden = YES;
            self.borderButton.hidden = NO;
            break;
        case OrderStatuspayment:
            self.payView.hidden = NO;
            self.borderButton.hidden = YES;
            self.backgroundButton.hidden = YES;
            self.statusLabel.text = @"待付款";

            if (self.payCountDownTextLabel.text.length == 0) {
                self.timeInterval = 600 - [NSString comparisonStartTimestamp:ordersModel.created_at endTimestamp:ordersModel.current_time];
                // 十分钟的倒计时显示的值
                self.countDownText = [NSString stringWithNSTimeInterval:self.timeInterval];
                self.payCountDownTextLabel.text = self.countDownText;
                [self addTimer];
            }
            break;
        case OrderStatusEvaluation:
            self.statusLabel.text = @"交易成功";
            [self.backgroundButton setTitle:@"去评价" forState:UIControlStateNormal];
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 80;
            self.borderButtonRightConstraint.constant = 15;
            self.backgroundButton.hidden = NO;
            self.borderButton.hidden = NO;
            break;
        case OrderStatusFinish:
            self.statusLabel.text = @"交易成功";
            [self.borderButton setTitle:@"删除订单" forState:UIControlStateNormal];
            self.backgroundButtonWidthConstraint.constant = 0;
            self.borderButtonRightConstraint.constant = 0;
            self.backgroundButton.hidden = YES;
            self.borderButton.hidden = NO;
            break;
    }
    
    // 按照express排序
    NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"express" ascending:YES]];
    self.products = [self.ordersModel.items sortedArrayUsingDescriptors:sortArr];
    
    // 获取不隐藏运费模板的数量
    NSMutableArray *expressArr = [NSMutableArray array];
    for (NSDictionary *dict in self.products) {
        [expressArr addObject:dict[@"express"]];
    }
    
    self.set = [NSSet setWithArray:expressArr];
    
    [self.tableView reloadData];
}

- (void)logisticsTracking {
     [[NSNotificationCenter defaultCenter] postNotificationName:kOrderLogisticsTracking object:nil userInfo:@{@"itemModel":self.itemModel}];
}

- (void)addTimer {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)countDown {
    self.timeInterval--;
    
    if (self.timeInterval < 1) {
        [self removeTimer];
        if (self.countDownBlock) {
             self.countDownBlock(self);
        }
        return;
    }
    
    self.countDownText = [NSString stringWithNSTimeInterval:self.timeInterval];
    self.payCountDownTextLabel.text = self.countDownText;
    self.orderPayView.countDownLabel.text = [NSString stringWithFormat:@"付款 %@",self.countDownText];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)pay:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.ordersModel.rid;
    THNRequest *request = [THNAPI postWithUrlString:kUrlOrdersIsMergePay requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        THNOrderDetailModel *detailModel = [THNOrderDetailModel mj_objectWithKeyValues:result.data];
        
        if ([result.data[@"is_merge"] boolValue]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            self.orderPayView.orderLists = result.data[@"order_list"];
            
            WEAKSELF;
            self.orderPayView.payViewBlock = ^{
                [weakSelf againPay:detailModel];
            };
            
            self.orderPayView.frame = window.bounds;
            [window addSubview:self.orderPayView];
        } else {
            [self againPay:detailModel];
        }
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 再次付款
- (void)againPay:(THNOrderDetailModel *)detailModel {
    [[THNPayManger sharedManager] loadThirdPayParamsWithRid:self.ordersModel.rid withFromPaymentType:FromPaymentTypeOrderVC withPaymentType:self.ordersModel.pay_type];
    if (self.delegate && [self.delegate respondsToSelector:@selector(callBackSelectPayOrderRid:)]) {
        [self.delegate callBackSelectPayOrderRid:self.ordersModel.rid];
    }
}

- (IBAction)backGroundButton:(id)sender {
    switch (self.ordersModel.user_order_status) {
        case OrderStatusWaitDelivery:
        case OrderStatusReceipt:
            [self loadOrdersSignedData];
            break;
        case OrderStatusEvaluation:
            if (self.delegate && [self.delegate respondsToSelector:@selector(pushEvaluation:initWithRid:)]) {
                [self.delegate pushEvaluation:self.products initWithRid:self.ordersModel.rid];
            }
        default:
            break;
    }
}

- (void)showObtainedMuseumView {
    THNObtainedView *obtainedMuseumView = [THNObtainedView sharedManager];
    [obtainedMuseumView show:@"确认删除该商品吗" withRightButtonTitle:@"取消" withLeftButtonTitle:@"删除"];
    
    obtainedMuseumView.obtainedleftBlock  = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteOrder:initWithCell:)]) {
            [self.delegate deleteOrder:self.ordersModel.rid initWithCell:self];
        }
    };
}

- (IBAction)borderButton:(id)sender {
    switch (self.ordersModel.user_order_status) {
        case OrderStatusWaitDelivery:
        case OrderStatusReceipt:
            [self logisticsTracking];
            break;
        default:
            [self showObtainedMuseumView];
            break;
    }
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
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderSubCellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    THNOrdersItemsModel *itemModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    self.itemModel = itemModel;
    if (self.ordersModel.user_order_status == OrderStatusReceipt) {
        // 只有一个运费模板
        if (self.set.count == 1) {
            cell.borderButton.hidden = YES;
            self.borderButton.hidden = NO;
            self.lineView.hidden = YES;
        } else {
            // 最后一行不隐藏运费模板
            if (indexPath.row < self.products.count - 1) {
                // 该商品后面运费模板一样，隐藏选择运费模板
                if (itemModel.express == [self.products[indexPath.row + 1][@"express"] integerValue]) {
                    cell.borderButton.hidden = YES;
                    self.borderButton.hidden = NO;
                } else {
                    cell.borderButton.hidden = NO;
                    self.borderButton.hidden = YES;
                }
                
            } else {
                cell.borderButton.hidden = NO;
                self.borderButton.hidden = YES;
            }
            self.lineView.hidden = NO;
        }
    } else {
         cell.borderButton.hidden = YES;
    }
    
    [cell setItemModel:itemModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushOrderDetail:)]) {
        [self.delegate pushOrderDetail:self.ordersModel.rid];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrdersItemsModel *itemModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    
    if (self.ordersModel.user_order_status == OrderStatusReceipt) {
        if (self.set.count == 1) {
            return kOrderProductViewHeight;
        } else {
            if (indexPath.row < self.products.count - 1) {
                // 该商品后面运费模板一样，设置为商品的高度
                if (itemModel.express == [self.products[indexPath.row + 1][@"express"] integerValue]) {
                    return kOrderProductViewHeight;
                } else {
                    return kOrderProductViewHeight + kOrderLogisticsViewHeight;
                }
            } else {
                return kOrderProductViewHeight + kOrderLogisticsViewHeight;
            }
        }
    } else {
        return kOrderProductViewHeight;
    }
       
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (THNOrderPayView *)orderPayView {
    if (!_orderPayView) {
        _orderPayView = [THNOrderPayView viewFromXib];
    }
    return _orderPayView;
}

@end
