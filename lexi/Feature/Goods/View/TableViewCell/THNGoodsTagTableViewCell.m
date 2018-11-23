//
//  THNGoodsTagTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsTagTableViewCell.h"
#import <YYKit/YYKit.h>

static NSString *const kGoodsTagTableViewCellId = @"kGoodsTagTableViewCellId";

@interface THNGoodsTagTableViewCell ()

@property (nonatomic, assign) CGFloat tagW;

@end

@implementation THNGoodsTagTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsTagTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsTagTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsTagTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setGoodsTagWithTags:(NSArray *)tags {
    if (self.subviews.count > 1) return;
    
    for (NSUInteger idx = 0; idx < tags.count; idx ++) {
        THNGoodsModelLabels *model = tags[idx];
        NSString *hexColor = idx == 0 ? @"#F5A43C" : @"#777777";
        
        [self thn_creatTagLabelWithText:model.name textColor:hexColor];
        
        if (idx != tags.count - 1) {
            [self thn_creatSymbolLabelTextColor:hexColor];
        }
    }
}

#pragma mark - private methods
- (void)thn_creatTagLabelWithText:(NSString *)text textColor:(NSString *)color {
    NSMutableAttributedString *tagAtt = [[NSMutableAttributedString alloc] initWithString:text];
    tagAtt.font = [UIFont systemFontOfSize:11];
    tagAtt.color = [UIColor colorWithHexString:color];
    
    YYTextLayout *tagLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAXFLOAT, MAXFLOAT) text:tagAtt];
    CGFloat textW = tagLayout.textBoundingSize.width;
    
    YYLabel *tagLabel = [[YYLabel alloc] initWithFrame:CGRectMake(self.tagW, 0, textW, 13)];
    tagLabel.attributedText = tagAtt;
    
    self.tagW += textW;
    [self addSubview:tagLabel];
}

- (void)thn_creatSymbolLabelTextColor:(NSString *)color {
    NSMutableAttributedString *symbolAtt = [[NSMutableAttributedString alloc] initWithString:@"·"];
    symbolAtt.font = [UIFont systemFontOfSize:26];
    symbolAtt.color = [UIColor colorWithHexString:color];
    symbolAtt.alignment = NSTextAlignmentCenter;
    
    YYLabel *symbolLabel = [[YYLabel alloc] initWithFrame:CGRectMake(self.tagW, 2, 10, 13)];
    symbolLabel.attributedText = symbolAtt;
    
    self.tagW += 12;
    [self addSubview:symbolLabel];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.tagW = 15.0;
}

@end
