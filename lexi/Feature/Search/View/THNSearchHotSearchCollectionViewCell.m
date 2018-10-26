//
//  THNSearchHotSearchCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchHotSearchCollectionViewCell.h"

@interface THNSearchHotSearchCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *hotSearchWordLabel;

@end

@implementation THNSearchHotSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codetest
}

- (void)setHotSerarchStr:(NSString *)hotSerarchStr {
    self.hotSearchWordLabel.text = hotSerarchStr;
}

@end
