//
//  THNPaySuccessTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/11/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPaySuccessTableViewCell.h"
#import "THNOrderDetailTableViewCell.h"
#import "THNLifeOrderStoreModel.h"
#import <MJExtension/MJExtension.h>
#import "THNOrderDetailModel.h"
#import "NSString+Helper.h"
#import "THNOrdersItemsModel.h"

static NSString *const kOrderPaySuccessProductCellIdentifier = @"kOrderPaySuccessProductCellIdentifier";

@interface THNPaySuccessTableViewCell() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THNPaySuccessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderPaySuccessProductCellIdentifier];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setDetailModel:(THNOrderDetailModel *)detailModel {
    _detailModel = detailModel;
     THNLifeOrderStoreModel *storeModel = [THNLifeOrderStoreModel mj_objectWithKeyValues:detailModel.store];
    self.storeNameLabel.text = storeModel.store_name;
    
    if (detailModel.freight == 0) {
        self.freightLabel.text = @"包邮";
    } else {
       self.freightLabel.text = [NSString formatFloat:detailModel.freight];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderPaySuccessProductCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.detailModel.items[indexPath.row]];
    [cell setPaySuccessProductView:itemsModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

@end
