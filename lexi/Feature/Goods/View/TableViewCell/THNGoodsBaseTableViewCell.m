//
//  THNGoodsBaseTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

static NSString *const kGoodsBaseTabelViewCellId = @"kGoodsBaseTabelViewCellId";

@implementation THNGoodsBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsBaseTabelViewCellId];
    if (!cell) {
        cell = [[THNGoodsBaseTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsBaseTabelViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView {
    return [self initGoodsCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
}

- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
}

@end
