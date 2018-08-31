//
//  THNGoodsTagTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsTagTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static NSString *const kGoodsTagTableViewCellId = @"kGoodsTagTableViewCellId";

@interface THNGoodsTagTableViewCell ()

/// 商品标签
@property (nonatomic, strong) YYLabel *tagLabel;

@end

@implementation THNGoodsTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsTagTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsTagTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsTagTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView {
    return [self initGoodsCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
}

- (void)thn_setGoodsTagWithTags:(NSArray *)tags {
    NSMutableAttributedString *tagAtt = [[NSMutableAttributedString alloc] init];
    
    for (NSUInteger idx = 0; idx < tags.count; idx ++) {
        THNGoodsModelLabel *model = tags[idx];
    
        NSMutableAttributedString *symbolAtt = [[NSMutableAttributedString alloc] initWithString:@"·"];
        symbolAtt.font = [UIFont systemFontOfSize:11];
        symbolAtt.color = [UIColor colorWithHexString:idx == 0 ? @"#F5A43C" : @"#777777"];
        symbolAtt.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.name];
        att.font = [UIFont systemFontOfSize:11];
        att.color = [UIColor colorWithHexString:idx == 0 ? @"#F5A43C" : @"#777777"];
        
        if (idx != tags.count - 1) {
            [att appendAttributedString:symbolAtt];
        }
        
        [tagAtt appendAttributedString:att];
    }

    self.tagLabel.attributedText = tagAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.tagLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[YYLabel alloc] init];
    }
    return _tagLabel;
}

@end
