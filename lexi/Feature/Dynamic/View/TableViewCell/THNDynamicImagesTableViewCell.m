//
//  THNDynamicImagesTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicImagesTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIImageView+SDWedImage.h"
#import "UIView+Helper.h"

static NSString *const kDynamicImagesCellId = @"THNDynamicImagesTableViewCellId";

@interface THNDynamicImagesTableViewCell ()

@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) UILabel *imageCount;

@end

@implementation THNDynamicImagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initDynamicImagesCellWithTableView:(UITableView *)tableView {
    THNDynamicImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDynamicImagesCellId];
    if (!cell) {
        cell = [[THNDynamicImagesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kDynamicImagesCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDynamicImagesWithModel:(THNDynamicModelLines *)model {
    if (self.subviews.count > 2) return;
    
    [self thn_createDynamicImageViewWithImages:model.productCovers];
}

#pragma mark - private methods
- (void)thn_createDynamicImageViewWithImages:(NSArray *)images {
    NSInteger maxCount = images.count > 3 ? 3 : images.count;
    
    for (NSUInteger idx = 0 ; idx < maxCount; idx ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;

        [imageView downloadImage:[images[idx] loadImageUrlWithType:(THNLoadImageUrlTypeWindowMd)]];
        [self addSubview:imageView];
        [self bringSubviewToFront:self.imageCount];
        [self.imageViewArr addObject:imageView];
    }
    
    [self thn_setImageCountLabelWithCount:images.count];
}

- (void)thn_setImageCountLabelWithCount:(NSInteger)count {
    self.imageCount.hidden = count <= 3;
    self.imageCount.text = [[NSString alloc] initWithFormat:@"%zi图", count];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageCount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageViewArr.count) {
        [self.imageViewArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal)
                                    withFixedItemLength:[self imageWidth]
                                            leadSpacing:20
                                            tailSpacing:20];
        
        [self.imageViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self imageWidth]);
            make.centerY.equalTo(self);
        }];
    }
    
    [self.imageCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 16));
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - getters and setters
- (CGFloat)imageWidth {
    return CGRectGetHeight(self.bounds);
}

- (UILabel *)imageCount {
    if (!_imageCount) {
        _imageCount = [[UILabel alloc] init];
        _imageCount.backgroundColor = [UIColor blackColor];
        _imageCount.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
        _imageCount.textColor = [UIColor whiteColor];
        _imageCount.textAlignment = NSTextAlignmentCenter;
        _imageCount.layer.cornerRadius = 8;
        _imageCount.layer.masksToBounds = YES;
        _imageCount.hidden = YES;
    }
    return _imageCount;
}

- (NSMutableArray *)imageViewArr {
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

@end
