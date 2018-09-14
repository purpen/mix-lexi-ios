//
//  THNPreViewTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPreViewTableViewCell.h"

@interface THNPreViewTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;
@property (weak, nonatomic) IBOutlet UITextField *giftTextField;

@end

@implementation THNPreViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPreViewCell:(THNSkuModelItem *)itemModel {
    
}

- (IBAction)selectCouponButton:(id)sender {
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
