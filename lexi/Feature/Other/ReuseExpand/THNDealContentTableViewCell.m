//
//  THNDealContentTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDealContentTableViewCell.h"
#import "THNDealContentModel.h"
#import "UIImageView+WebImage.h"
#import "UIImage+Helper.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import "SVProgressHUD+Helper.h"
#import "NSString+Helper.h"

static NSString *const kDealContentTableViewCellId = @"kDealContentTableViewCellId";

@interface THNDealContentTableViewCell ()

/// 间隔 Y
@property (nonatomic, assign) CGFloat originY;
/// 创建类型
@property (nonatomic, assign) THNDealContentType type;

@end

@implementation THNDealContentTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNDealContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDealContentTableViewCellId];
    if (!cell) {
        cell = [[THNDealContentTableViewCell alloc] initWithStyle:style reuseIdentifier:kDealContentTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDealContentData:(NSArray *)dealContent {
    return [self thn_setDealContentData:dealContent type:(THNDealContentTypeArticle)];
}

- (void)thn_setDealContentData:(NSArray *)dealContent type:(THNDealContentType)type {
    if (self.subviews.count > 1) return;
    
    self.type = type;
    self.originY = 0;
    
    for (THNDealContentModel *model in dealContent) {
        if ([model.type isEqualToString:@"text"]) {
            [self thn_creatAttributedStringWithText:[NSString filterHTML:model.content]];
            
        } else if ([model.type isEqualToString:@"image"]) {
            if (model.width > 0 && model.height > 0) {
                [self thn_creatContentImageWithImageUrl:model.content width:model.width height:model.height];
                
            } else {
                [self thn_creatContentImageWithImageUrl:model.content];
            }
        }
    }
}

#pragma mark - private methods
/**
 文字内容
 */
- (void)thn_creatAttributedStringWithText:(NSString *)text {
    [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    YYLabel *textLabel = [YYLabel new];
    textLabel.numberOfLines = 0;
    textLabel.displaysAsynchronously = YES; // 开启异步绘制
    textLabel.ignoreCommonProperties = YES; // 忽略除了 textLayout 之外的其他属性
    
    [self addSubview:textLabel];
    
    CGFloat textOrigin = self.type == THNDealContentTypeGrassNote ? 40 : 30;
    CGFloat textW = kScreenWidth - textOrigin;
    
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    textAtt.lineSpacing = 7;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(textW, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
        
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:textAtt];
    
    textLabel.size = layout.textBoundingSize;
    textLabel.textLayout = layout;
    
    textLabel.frame = CGRectMake(textOrigin / 2, self.originY, textW, layout.textBoundingSize.height);
    self.originY += (layout.textBoundingSize.height + 10);
}

/**
 图片内容
 */
- (void)thn_creatContentImageWithImageUrl:(NSString *)imageUrl {
    if (!imageUrl.length) return;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    UIImage *image = [UIImage getImageFormDiskCacheForKey:imageUrl];
    imageView.image = image;
    
    CGSize contentImageSize = [self thn_getContentImageSizeWithImage:image];
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(contentImageSize);
        make.left.mas_equalTo([self thn_imageOriginX]);
        make.top.mas_equalTo(self.originY);
    }];
    
    self.originY += (contentImageSize.height + 10);
}

- (void)thn_creatContentImageWithImageUrl:(NSString *)imageUrl width:(CGFloat)width height:(CGFloat)height {
    if (!imageUrl.length) return;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    
    CGSize contentImageSize = [self thn_getContentImageSizeWithWidth:width height:height];
    
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(contentImageSize);
        make.left.mas_equalTo([self thn_imageOriginX]);
        make.top.mas_equalTo(self.originY);
    }];
    
    self.originY += (contentImageSize.height + 10);
    
    [imageView loadImageWithUrl:[imageUrl loadImageUrlWithType:(THNLoadImageUrlTypeDealContent)]];
}

/**
 调整图片的尺寸
 */
- (CGSize)thn_getContentImageSizeWithImage:(UIImage *)image {
    CGFloat image_w = [self thn_imageWidth];
    CGFloat image_scale = image_w / image.size.width;
    CGFloat image_h = image.size.height * image_scale;
    
    return CGSizeMake(image_w, image_h);
}

- (CGSize)thn_getContentImageSizeWithWidth:(CGFloat)width height:(CGFloat)height {
    if (width > 0 && height > 0) {
        CGFloat image_w = [self thn_imageWidth];
        CGFloat image_scale = image_w / width;
        CGFloat image_h = height * image_scale;
        
        return CGSizeMake(image_w, image_h);
    }
    
    return CGSizeMake(0, 0);
}

#pragma mark - getters and setters
- (CGFloat)thn_imageOriginX {
    NSDictionary *originDict = @{@(THNDealContentTypeArticle)   : @(0),
                                 @(THNDealContentTypeGoodsInfo) : @(15),
                                 @(THNDealContentTypeBrandHall) : @(15),
                                 @(THNDealContentTypeGrassNote) : @(20)};
    
    CGFloat originX = [originDict[@(self.type)] floatValue];
    
    return originX;
}

- (CGFloat)thn_imageWidth {
    CGFloat imageW = kScreenWidth - ([self thn_imageOriginX] * 2);
    
    return imageW;
}

#pragma mark -
- (void)dealloc {
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
