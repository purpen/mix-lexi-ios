//
//  THNCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentTableViewCell.h"
#import "THNFirstLevelCommentTableViewCell.h"

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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (IBAction)lookComment:(id)sender {
    self.lookCommentBlock();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNFirstLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFirstLevelInCommentCellIdentifier forIndexPath:indexPath];
    cell.lineView.hidden = YES;
    if (indexPath.row == 0) {
        cell.contentlabel.text = @"dsafsakfl;lak;f";
        cell.array = @[@"",@""];
        cell.tableViewConstraint.constant = 280;
    } else {
        cell.contentlabel.text = @"dd the image referenced from a nib in the bundle with identifier image referenced from a nib in the bundle witimage referenced from a nib in the bundle wit";
        cell.tableViewConstraint.constant = 140;
        cell.array = @[@""];
    }
    
    return cell;
}

@end
