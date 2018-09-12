//
//  THNLogisticsPlaceTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLogisticsPlaceTableViewCell.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

#define kTextPlace(place) [NSString stringWithFormat:@"从%@发货", place]
///
static NSString *const kTextTitle = @"选择物流";
static NSString *const kLogisticsPlaceTableViewCellId = @"kLogisticsPlaceTableViewCellId";

@interface THNLogisticsPlaceTableViewCell ()

/// 标题
@property (nonatomic, strong) UILabel *titlelabel;
/// 发货地
@property (nonatomic, strong) UILabel *placeLabel;

@end

@implementation THNLogisticsPlaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initPlaceCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNLogisticsPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogisticsPlaceTableViewCellId];
    if (!cell) {
        cell = [[THNLogisticsPlaceTableViewCell alloc] initWithStyle:style reuseIdentifier:kLogisticsPlaceTableViewCellId];
    }
    return cell;
}

+ (instancetype)initPlaceCellWithTableView:(UITableView *)tableView {
    return [self initPlaceCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
}

- (void)setPlace:(NSString *)place {
    self.placeLabel.text = kTextPlace(place);
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.titlelabel];
    [self addSubview:self.placeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titlelabel.frame = CGRectMake(15, 0, 100, CGRectGetHeight(self.bounds));
    self.placeLabel.frame = CGRectMake(130, 0, CGRectGetWidth(self.bounds) - 145, CGRectGetHeight(self.bounds));
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds) - 1)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.font = [UIFont systemFontOfSize:14];
        _titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titlelabel.text = kTextTitle;
    }
    return _titlelabel;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.font = [UIFont systemFontOfSize:12];
        _placeLabel.textColor = [UIColor colorWithHexString:@"#949EA6"];
        _placeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _placeLabel;
}

@end
