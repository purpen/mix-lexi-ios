//
//  THNLogisticsViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLogisticsViewController.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNOrdersItemsModel.h"
#import "THNLogisticsTableViewCell.h"
#import "THNNoLogisticsView.h"
#import "UIView+Helper.h"
#import "UIViewController+THNHud.h"

static NSString *const kUrlLogisticsInformation = @"/logistics/information";
static NSString *const kLogisticsCellIdentifier = @"kLogisticsCellIdentifier";

@interface THNLogisticsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *waybillNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logisticsStatusImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *traces;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
// 没有物流信息View
@property (nonatomic, strong) THNNoLogisticsView *noLogisticsView;

@end

@implementation THNLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadLogisticsInformationData];
}

- (void)setupUI {
    self.topConstraint.constant = STATUS_BAR_HEIGHT;
    self.navigationBarView.backgroundColor = [UIColor colorWithHexString:@"2D343A"];
    self.navigationBarView.title = @"物流跟踪";
    self.navigationBarView.titleColor = [UIColor whiteColor];
    self.waybillNumberLabel.text = self.itemsModel.express_no;
    self.deliveryMethodLabel.text = self.itemsModel.express_name;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNLogisticsTableViewCell" bundle:nil] forCellReuseIdentifier:kLogisticsCellIdentifier];
}

- (void)loadLogisticsInformationData {
    [self showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logistic_code"] = self.itemsModel.express_no;
    params[@"kdn_company_code"] = self.itemsModel.express_code;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLogisticsInformation requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        // 物流状态：2-在途中,3-签收,4-问题件
        NSInteger logisticsStatus = [result.data[@"State"]integerValue];
        if (logisticsStatus == 2) {
            self.logisticsStatusLabel.text = @"配送中";
            self.logisticsStatusImageView.image = [UIImage imageNamed:@"icon_logistics_distribution"];
        } else if (logisticsStatus == 3) {
            self.logisticsStatusLabel.text = @"已签收";
            self.logisticsStatusImageView.image = [UIImage imageNamed:@"icon_logistics_finish"];
        } else {
            self.logisticsStatusLabel.text = @"配送中";
            
        }
        
        
        NSMutableArray *tracesMuableArray = result.data[@"Traces"];
        
        // 倒序排列
        self.traces = [[tracesMuableArray reverseObjectEnumerator] allObjects];
        
        if (self.traces.count > 0) {
            self.tableView.hidden = NO;
            self.noLogisticsView.hidden = YES;
           [self.tableView reloadData];
        } else {
            self.tableView.hidden = YES;
            [self.view insertSubview:self.noLogisticsView belowSubview:self.logisticsStatusImageView];
        }
        
        
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.traces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogisticsCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.logisticsImageView.image = [UIImage imageNamed:@"icon_green_dot"];
        cell.topLineView.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        cell.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        cell.topLineView.hidden = YES;
        cell.bottomLineView.hidden = NO;
       
    } else if (indexPath.row == self.traces.count - 1){
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = YES;
        cell.topLineView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        cell.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        cell.logisticsImageView.image = [UIImage imageNamed:@"icon_gray_dot"];
    } else if (indexPath.row == 1){
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = NO;
        cell.topLineView.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        cell.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        cell.logisticsImageView.image = [UIImage imageNamed:@"icon_gray_dot"];
    } else {
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = NO;
        cell.topLineView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        cell.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
        cell.logisticsImageView.image = [UIImage imageNamed:@"icon_gray_dot"];
    }
    
    cell.informationLabel.text = self.traces[indexPath.row][@"AcceptStation"];
    cell.timeLabel.text = self.traces[indexPath.row][@"AcceptTime"];
    return cell;
}

#pragma mark - lazy
- (THNNoLogisticsView *)noLogisticsView {
    if (!_noLogisticsView) {
        _noLogisticsView = [THNNoLogisticsView viewFromXib];
        _noLogisticsView.orderNumberTextField.text = self.itemsModel.express_no;
        _noLogisticsView.frame = CGRectMake(0, 210, SCREEN_WIDTH, SCREEN_HEIGHT - 180);
    }
    return _noLogisticsView;
}

@end
