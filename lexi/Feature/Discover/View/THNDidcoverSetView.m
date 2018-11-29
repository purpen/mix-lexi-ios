//
//  THNDidcoverSetView.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDidcoverSetView.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNDiscoverSetCollectionViewCell.h"

static NSString *const kDiscoverSetCellIdentifier = @"kDiscoverSetCellIdentifier";

@interface THNDidcoverSetView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation THNDidcoverSetView

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] initWithLineSpacing:10
                                                                                   initWithWidth:105
                                                                                  initwithHeight:130];
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNDiscoverSetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDiscoverSetCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverSetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDiscoverSetCellIdentifier forIndexPath:indexPath];
    
    cell.desLabel.text = self.titles[indexPath.row];
    cell.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_discover_%ld",indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.discoverSetBlcok) {
        self.discoverSetBlcok(indexPath.row, self.titles[indexPath.row]);
    }
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"创作人故事", @"种草笔记", @"生活记事", @"手作教学"];
    }
    return _titles;
}

@end
