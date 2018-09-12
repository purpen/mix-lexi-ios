//
//  THNGoodsSkuCollecitonView.m
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsSkuCollecitonView.h"
#import "UIColor+Extension.h"
#import "THNGoodsSkuCollectionViewCell.h"
#import "THNSkuModelColor.h"
#import "NSString+Helper.h"
#import <Masonry/Masonry.h>

static NSString *const kGoodsSkuCollectionViewCellId = @"kGoodsSkuCollectionViewCellId";

@interface THNGoodsSkuCollecitonView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 文本列表
@property (nonatomic, strong) UICollectionView *textCollecitonView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 名称
@property (nonatomic, strong) NSMutableArray *nameArr;
/// 选中的下标
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation THNGoodsSkuCollecitonView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.text = title;
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setSkuNameData:(NSArray *)data {
    if (self.nameArr.count) {
        [self.nameArr removeAllObjects];
    }
    
    for (THNSkuModelColor *model in data) {
        [self.nameArr addObject:model.name];
    }

    [self.textCollecitonView reloadData];
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textCollecitonView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 24));
    }];
    
    [self.textCollecitonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(15);
        make.top.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nameArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = self.nameArr[indexPath.row];
    
    return CGSizeMake([name boundingSizeWidthWithFontSize:12] + 12, 24);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGoodsSkuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGoodsSkuCollectionViewCellId
                                                                                    forIndexPath:indexPath];
    if (self.nameArr.count) {
        [cell thn_setSkuName:self.nameArr[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - getters and setters
- (UICollectionView *)textCollecitonView {
    if (!_textCollecitonView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _textCollecitonView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _textCollecitonView.delegate = self;
        _textCollecitonView.dataSource = self;
        _textCollecitonView.showsVerticalScrollIndicator = NO;
        _textCollecitonView.backgroundColor = [UIColor whiteColor];
        [_textCollecitonView registerClass:[THNGoodsSkuCollectionViewCell class] forCellWithReuseIdentifier:kGoodsSkuCollectionViewCellId];
    }
    return _textCollecitonView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightLight)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (NSMutableArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSMutableArray array];
    }
    return _nameArr;
}


@end
