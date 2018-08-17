//
//  THNLikedWindowTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedWindowTableViewCell.h"
#import "THNMarco.h"
#import "THNLikedWindowCollectionViewCell.h"

static NSString *const kCollectionViewCellId = @"THNLikedWindowCollectionViewCellId";
static NSString *const kTableViewCellId = @"THNLikedWindowTableViewCellId";

@interface THNLikedWindowTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/// 橱窗列表
@property (nonatomic, strong) UICollectionView *windowCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 橱窗数据
@property (nonatomic, strong) NSMutableArray *windowArray;

@end

@implementation THNLikedWindowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initWindowCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNLikedWindowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId];
    if (!cell) {
        cell = [[THNLikedWindowTableViewCell alloc] initWithStyle:style reuseIdentifier:kTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

#pragma mark - public methods
- (void)thn_setWindowData:(NSDictionary *)data {
    
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.contentView addSubview:self.windowCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.windowCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.flowLayout.itemSize = CGSizeMake(244, CGRectGetHeight(self.frame));
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.windowArray.count;
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedWindowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                      forIndexPath:indexPath];
    if (self.windowArray.count) {
//        [cell thn_setwindowModel:self.windowArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell.selectedCellBlock([NSString stringWithFormat:@"%zi", indexPath.row]);
}

#pragma mark - getters and setters
- (UICollectionView *)windowCollectionView {
    if (!_windowCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout = flowLayout;
        
        _windowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _windowCollectionView.showsHorizontalScrollIndicator = NO;
        _windowCollectionView.backgroundColor = [UIColor whiteColor];
        _windowCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _windowCollectionView.delegate = self;
        _windowCollectionView.dataSource = self;
        [_windowCollectionView registerClass:[THNLikedWindowCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _windowCollectionView;
}

- (NSMutableArray *)windowArray {
    if (!_windowArray) {
        _windowArray = [NSMutableArray array];
    }
    return _windowArray;
}

@end
