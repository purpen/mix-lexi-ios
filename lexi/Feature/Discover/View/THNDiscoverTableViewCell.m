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
#import <Masonry/Masonry.h>

@implementation THNDiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(67);
        make.leading.equalTo(self).with.offset(20);
        make.trailing.equalTo(self).with.offset(-20);
        make.bottom.equalTo(self);
    }];
}

- (THNTextCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[THNTextCollectionView alloc]initWithFrame:CGRectMake(20, 67, SCREEN_WIDTH - 40, 431) collectionViewLayout:layout];
        _collectionView.showTextType = ShowTextTypeTheme;
    }
    return _collectionView;
}


@end
