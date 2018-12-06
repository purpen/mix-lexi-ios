//
//  THNShareActionCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/12/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareActionCollectionViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"

@interface THNShareActionCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textlabel;

@end

@implementation THNShareActionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setActionImageNamed:(NSString *)imageNamed title:(NSString *)title {
    self.iconImageView.image = [UIImage imageNamed:imageNamed];
    self.textlabel.text = title;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.textlabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self);
    }];
    
    [self.textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 14));
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView drawCornerWithType:(UILayoutCornerRadiusAll) radius:50/2];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)textlabel {
    if (!_textlabel) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.font = [UIFont systemFontOfSize:12];
        _textlabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _textlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textlabel;
}

@end
