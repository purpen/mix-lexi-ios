//
//  THNFirstLevelCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFirstLevelCommentTableViewCell.h"
#import "THNSecondLevelCommentTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNMarco.h"

static NSString *const kSecondLevelCellIdentifier = @"kSecondLevelCellIdentifier";

@interface THNFirstLevelCommentTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 查看更多数据button
@property (nonatomic, strong) UIButton *expandButton;


@end

@implementation THNFirstLevelCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kSecondLevelCellIdentifier];
    self.tableView.scrollEnabled = NO;
}

- (void)loadMoreData {
    
}

- (void)setArray:(NSArray *)array {
    _array = array;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSecondLevelCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.contentLabel.text = @"我只有一行";
    } else {
        cell.contentLabel.text = @"多行打法是否哈萨克伽伽，多行打法是否哈萨克伽伽多行打法是否哈萨克伽伽多行打法是否哈萨克伽伽多行打法是否哈萨克伽伽";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.expandButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.array.count > 1) {
        return 30;
    } else {
        return 0;
    }
}

- (UIButton *)expandButton {
    if (!_expandButton) {
        _expandButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [_expandButton setTitle:@"查看4条回复" forState:UIControlStateNormal];
        [_expandButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _expandButton.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        _expandButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_expandButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
        _expandButton.imageEdgeInsets = UIEdgeInsetsMake(0, 170, 0, 0);
        _expandButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [_expandButton addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandButton;
}

@end
