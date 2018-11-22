//
//  THNOrderPayView.m
//  lexi
//
//  Created by HongpingRao on 2018/10/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderPayView.h"
#import "THNOrderPayTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNOrderPayModel.h"
#import "UIView+Helper.h"

static NSString *const kOrderPayCellIdentifier = @"kOrderPayCellIdentifier";

@interface THNOrderPayView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation THNOrderPayView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderPayTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderPayCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 63;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.payButton drawCornerWithType:0 radius:4];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}


- (void)setOrderLists:(NSArray *)orderLists {
    _orderLists = orderLists;
    [self.tableView reloadData];
}

- (IBAction)pay:(id)sender {
    [self removeFromSuperview];
    if (self.payViewBlock) {
        self.payViewBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderPayCellIdentifier forIndexPath:indexPath];
    THNOrderPayModel *orderPayModel = [THNOrderPayModel mj_objectWithKeyValues:self.orderLists[indexPath.row]];
    [cell setOrderPayModel:orderPayModel];
    return cell;
}

@end
