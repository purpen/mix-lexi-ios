//
//  THNTextCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTextCollectionView.h"
#import "UIView+Helper.h"
#import "THNGrassListCollectionViewCell.h"
#import "THNGrassListModel.h"
#import <MJExtension/MJExtension.h>
#import "THNMarco.h"

static NSString *const kUrlTextCellIdentifier = @"kUrlTextCellIdentifier";

@interface THNTextCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation THNTextCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        self.showsVerticalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:@"THNGrassListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kUrlTextCellIdentifier];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGrassListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUrlTextCellIdentifier forIndexPath:indexPath];
    cell.showTextType = self.showTextType;
    THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setGrassListModel:grassListModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    //  设置最大size
    CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
    CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
    CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
    CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
    NSDictionary *titleFont = self.showTextType == ShowTextTypeTheme?  @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]} : @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]};
    NSDictionary *contentFont = self.showTextType == ShowTextTypeTheme? @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]}   : @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:11]};      
    CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
    CGFloat contentHeight = [grassListModel.des boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
    CGFloat grassLabelHeight = titleHeight + contentHeight;
    grassListModel.grassLabelHeight = grassLabelHeight;
    return CGSizeMake((self.viewWidth - 10) / 2, 160 + grassListModel.grassLabelHeight);
}

@end
