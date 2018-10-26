//
//  THNSearchIndexTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchIndexTableViewCell.h"
#import "THNSearchIndexModel.h"
#import "UIColor+Extension.h"
#import "THNTextTool.h"

@interface THNSearchIndexTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDesLabel;

@end

@implementation THNSearchIndexTableViewCell

- (void)setSearchIndexModel:(THNSearchIndexModel *)searchIndexModel {
    _searchIndexModel = searchIndexModel;
    NSRange range = [searchIndexModel.name rangeOfString:self.textFieldText];
    self.nameLabel.attributedText = [THNTextTool setTextColor:searchIndexModel.name initWithColor:@"5FE4B1" initWithRange:range];
    self.typeDesLabel.text = searchIndexModel.title;
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"f7f9fb"];
    self.selectedBackgroundView = backgroundView;
}

@end
