//
//  THNFunctionCollectionView.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionCollectionView.h"
#import "THNFunctionCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNCategoriesModel.h"

static NSString *const kTitleCategory   = @"分类";
static NSString *const kTitleRecommend  = @"推荐";
static NSString *const kTitleMore       = @" 可多选";
/// CELL ID
static NSString *const kCollectionViewCellId    = @"collectionViewCellId";

@interface THNFunctionCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
/// 列表
@property (nonatomic, strong) UICollectionView *collectionView;
/// 模型数据
@property (nonatomic, strong) NSMutableArray *modelArr;
/// 推荐标签数据
@property (nonatomic, strong) NSMutableArray *tagsArr;
/// 视图类型
@property (nonatomic, assign) THNFunctionCollectionViewType viewType;
/// 选中的分类
@property (nonatomic, strong) NSMutableArray *selectedArr;
/// 选中的下标
@property (nonatomic, strong) NSMutableArray *indexArr;

@end

@implementation THNFunctionCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewType:(THNFunctionCollectionViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self thn_setTitleLabelText:type == THNFunctionCollectionViewTypeCategory ? kTitleCategory : kTitleRecommend];
        self.viewType = type;
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setCollecitonViewCellData:(NSArray *)data {
    for (NSDictionary *dict in data) {
        THNCategoriesModel *model = [THNCategoriesModel mj_objectWithKeyValues:dict];
        [self.modelArr addObject:model];
    }
    
    [self.collectionView reloadData];
}

- (void)thn_setRecommandTag:(NSArray *)tags {
    self.tagsArr = [tags mutableCopy];
    
    [self.collectionView reloadData];
}

- (void)thn_resetLoad {
    for (NSIndexPath *indexPath in self.indexArr) {
        THNFunctionCollectionViewCell *cell = (THNFunctionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell thn_selectCell:NO];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    if (self.indexArr.count) {
        [self.indexArr removeAllObjects];
    }
}

#pragma mark - private methods
- (void)thn_setTitleLabelText:(NSString *)text {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    attText.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
    attText.color = [UIColor colorWithHexString:@"#333333"];
    
    NSMutableAttributedString *subAttText = [[NSMutableAttributedString alloc] initWithString:kTitleMore];
    subAttText.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
    subAttText.color = [UIColor colorWithHexString:@"#999999"];
    
    [attText appendAttributedString:subAttText];
    self.titleLabel.attributedText = attText;
}

- (CGFloat)thn_getStringWidth:(NSString *)string {
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                          options:NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}
                                          context:nil].size;
    
    return retSize.width;
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewType == THNFunctionCollectionViewTypeCategory) {
        return self.modelArr.count;
    }
    
    return self.tagsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                    forIndexPath:indexPath];
    if (self.viewType == THNFunctionCollectionViewTypeCategory) {
        if (self.modelArr.count) {
            THNCategoriesModel *model = (THNCategoriesModel *)self.modelArr[indexPath.row];
            [cell thn_setCellTitle:model.name];
        }
        
    } else if (self.viewType == THNFunctionCollectionViewTypeRecommend) {
        if (self.tagsArr.count) {
            [cell thn_setCellTitle:self.tagsArr[indexPath.row]];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == THNFunctionCollectionViewTypeCategory) {
        if (self.modelArr.count) {
            THNCategoriesModel *model = (THNCategoriesModel *)self.modelArr[indexPath.row];
            return CGSizeMake([self thn_getStringWidth:model.name] + 20, 30);
        }
    
    } else if (self.viewType == THNFunctionCollectionViewTypeRecommend) {
        if (self.tagsArr.count) {
            return CGSizeMake([self thn_getStringWidth:self.tagsArr[indexPath.row]] + 20, 30);
        }
    }
    
    return CGSizeMake(50, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionCollectionViewCell *cell = (THNFunctionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell thn_selectCell:YES];
    [self.indexArr addObject:indexPath];
    
    if (self.viewType == THNFunctionCollectionViewTypeCategory) {
        THNCategoriesModel *model = (THNCategoriesModel *)self.modelArr[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(thn_getCategoryId:selected:)]) {
            [self.delegate thn_getCategoryId:model.category_id selected:YES];
        }
    
    } else if (self.viewType == THNFunctionCollectionViewTypeRecommend) {
        if ([self.delegate respondsToSelector:@selector(thn_getRecommandTags:selected:)]) {
            [self.delegate thn_getRecommandTags:self.tagsArr[indexPath.row] selected:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNFunctionCollectionViewCell *cell = (THNFunctionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell thn_selectCell:NO];
    
    if (self.viewType == THNFunctionCollectionViewTypeCategory) {
        THNCategoriesModel *model = (THNCategoriesModel *)self.modelArr[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(thn_getCategoryId:selected:)]) {
            [self.delegate thn_getCategoryId:model.category_id selected:NO];
        }
    
    } else if (self.viewType == THNFunctionCollectionViewTypeRecommend) {
        if ([self.delegate respondsToSelector:@selector(thn_getRecommandTags:selected:)]) {
            [self.delegate thn_getRecommandTags:self.tagsArr[indexPath.row] selected:NO];
        }
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
    }];
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[THNFunctionCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _collectionView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
    }
    return _titleLabel;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (NSMutableArray *)tagsArr {
    if (!_tagsArr) {
        _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

- (NSMutableArray *)indexArr {
    if (!_indexArr) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}

@end
