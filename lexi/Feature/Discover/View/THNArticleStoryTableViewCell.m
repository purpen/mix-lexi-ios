//
//  THNArticleStoryTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleStoryTableViewCell.h"

@implementation THNArticleStoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.showTextType = ShowTextTypeTheme;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView initWithFrame:CGRectZero collectionViewLayout:layout];
}


@end
