//
//  THNDiscoverTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverTableViewCell.h"
#import "THNTextCollectionView.h"
#import "THNMarco.h"
#import "UIView+Helper.h"

@implementation THNDiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.collectionView];
}

- (THNTextCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[THNTextCollectionView alloc]initWithFrame:CGRectMake(20, 67, SCREEN_WIDTH - 40, 431) collectionViewLayout:layout];
    }
    return _collectionView;
}


@end
