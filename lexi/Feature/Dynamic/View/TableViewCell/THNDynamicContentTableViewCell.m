//
//  THNDynamicContentTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicContentTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

static NSString *const kDynamicContentCellId = @"THNDynamicContentTableViewCellId";

@interface THNDynamicContentTableViewCell ()

@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation THNDynamicContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initDynamicContentCellWithTableView:(UITableView *)tableView {
    THNDynamicContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDynamicContentCellId];
    if (!cell) {
        cell = [[THNDynamicContentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kDynamicContentCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDynamicContentWithModel:(THNDynamicModelLines *)model {
    self.titleLabel.text = model.title;
    [self thn_setDynamicContentText:model.descriptionField];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)thn_setDynamicContentText:(NSString *)text {
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.lineSpacing = 7;
    textAtt.font = [UIFont systemFontOfSize:13];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    self.contentLabel.attributedText = textAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(17);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#25211E"];
    }
    return _titleLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
