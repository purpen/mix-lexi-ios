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
    [self thn_setContentData:model.dealContent];
}

- (void)thn_setContentData:(NSArray *)content {
    if (self.subviews.count > 1) return;
    
    self.originY = 0;
    
    for (THNGoodsModelDealContent *contentModel in content) {    
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
    if (!imageUrl.length) return;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:imageView];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        YYImageType imageType = YYImageDetectType((__bridge CFDataRef _Nonnull)(imageData));
        
        if (imageType == YYImageTypeJPEG || imageType == YYImageTypePNG || imageData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_image_place"]];
                
                YYImage *contentImage = [YYImage imageWithData:imageData];
                CGSize contentImageSize = [self thn_getContentImageSizeWithImage:contentImage];
                
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(contentImageSize);
                    make.left.mas_equalTo(15);
                    make.top.mas_equalTo(self.originY);
                }];
                
                self.originY += (contentImageSize.height + 10);
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 210));
                    make.left.mas_equalTo(15);
                    make.top.mas_equalTo(self.originY);
                }];
                
                self.originY += 220;
            });
        }
    });
}

/**
 调整图片的尺寸
 */
- (CGSize)thn_getContentImageSizeWithImage:(UIImage *)image {
    CGFloat image_scale = (kScreenWidth - 30) / image.size.width;
    CGFloat image_w = kScreenWidth - 30;
    CGFloat image_h = image.size.height * image_scale;
    
    return CGSizeMake(image_w, image_h);
}

- (void)dealloc {
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

@end
