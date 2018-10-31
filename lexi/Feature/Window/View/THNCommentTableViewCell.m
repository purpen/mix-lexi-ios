//
//  THNCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentTableViewCell.h"
#import "THNFirstLevelCommentTableViewCell.h"
#import "THNCommentModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kFirstLevelInCommentCellIdentifier = @"kFirstLevelInCommentCellIdentifier";

@interface THNCommentTableViewCell()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THNCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNFirstLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kFirstLevelInCommentCellIdentifier];
}

- (IBAction)lookComment:(id)sender {
    self.lookCommentBlock();
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFirstLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFirstLevelInCommentCellIdentifier forIndexPath:indexPath];
    THNCommentModel *commentModel = [THNCommentModel mj_objectWithKeyValues:self.comments[indexPath.row]];
    [cell setCommentModel:commentModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
