//
//  THNGoodsContentTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsContentTableViewCell.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import "THNGoodsModelDealContent.h"

static NSString *const kGoodsContentTableViewCellId = @"kGoodsContentTableViewCellId";

@interface THNGoodsContentTableViewCell ()

/// 间隔 Y
@property (nonatomic, assign) CGFloat originY;

@end

@implementation THNGoodsContentTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsContentTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsContentTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsContentTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setContentWithGoodsModel:(THNGoodsModel *)model {
    if (self.subviews.count > 1) return;
    
    self.originY = 0;
    
    for (THNGoodsModelDealContent *contentModel in model.dealContent) {
        if ([contentModel.type isEqualToString:@"text"]) {
            [self thn_creatAttributedStringWithText:contentModel.content];
            
        } else if ([contentModel.type isEqualToString:@"image"]) {
            [self thn_creatAttributedStringWithImage:contentModel.content];
        }
    }
}

#pragma mark - private methods
/**
 文字内容
 */
- (void)thn_creatAttributedStringWithText:(NSString *)text {
    [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    YYLabel *textLabel = [[YYLabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.displaysAsynchronously = YES;
    textLabel.ignoreCommonProperties = YES;
    
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    textAtt.lineSpacing = 7;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textAtt];
    
    textLabel.size = layout.textBoundingSize;
    textLabel.textLayout = layout;
    
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(layout.textBoundingSize);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.originY);
    }];
    
    self.originY += (layout.textBoundingSize.height + 10);
}

/**
 图片内容
 */
- (void)thn_creatAttributedStringWithImage:(NSString *)imageUrl {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholder:[UIImage imageNamed:@"default_goods_place"]
                       options:(YYWebImageOptionSetImageWithFadeAnimation)
                      progress:nil
                     transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                         image = [image imageByResizeToSize:CGSizeMake(kScreenWidth - 30, (kScreenWidth - 30) * 0.66)
                                                contentMode:UIViewContentModeScaleAspectFill];
                         return image;
                     }
                    completion:nil];
    
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, (kScreenWidth - 30) * 0.66));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.originY);
    }];
    
    self.originY += ((kScreenWidth - 30) * 0.66 + 10);
}

@end
