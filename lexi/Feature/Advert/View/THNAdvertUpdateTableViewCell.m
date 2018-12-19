//
//  THNAdvertUpdateTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertUpdateTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static NSString *const kTextHint = @"【新版本更新】";

@interface THNAdvertUpdateTableViewCell ()

@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation THNAdvertUpdateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setUpdateContent:(NSString *)content {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:content];
    if ([content isEqualToString:kTextHint]) {
        att.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
        
    } else {
        att.font = [UIFont systemFontOfSize:13];
    }
    att.color = [UIColor colorWithHexString:@"#333333"];
    att.lineSpacing = 5;
    
    self.contentLabel.attributedText = att;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.contentLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

@end
