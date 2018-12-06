//
//  THNShareActionView.m
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareActionView.h"
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "UIView+Helper.h"
#import "THNShareActionCollectionViewCell.h"

/// text
static NSString *const kTitleSave = @"保存海报";
/// id
static NSString *const kShareActionCollectionViewCellId = @"THNShareActionCollectionViewCellId";

@interface THNShareActionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *actionCollectionView;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) NSArray *imagesArr;

@end

@implementation THNShareActionView

- (instancetype)initWithFrame:(CGRect)frame type:(THNShareActionViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArr = [self thn_getTitlesWithType:type];
        self.imagesArr = [self thn_getImagesWithType:type];
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)hiddenSaveImageButton {
    
}

#pragma mark - private methods
- (NSArray *)thn_getTitlesWithType:(THNShareActionViewType)type {
    NSArray *titles = @[@[@"微信", @"朋友圈", @"微博", @"QQ", @"QQ空间"],
                        @[@"更多分享"],
                        @[kTitleSave, @"更多分享"]];
    
    return titles[(NSUInteger)type];
}

- (NSArray *)thn_getImagesWithType:(THNShareActionViewType)type {
    NSArray *images = @[@[@"icon_share_wechat", @"icon_share_timeline", @"icon_share_weibo", @"icon_share_qq", @"icon_share_qq_space"],
                        @[@"icon_share_more"],
                        @[@"icon_share_image", @"icon_share_more"]];
    
    return images[(NSUInteger)type];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.actionCollectionView];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UICollectionView *)actionCollectionView {
    if (!_actionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/5, CGRectGetHeight(self.frame));
        
        _actionCollectionView = [[UICollectionView alloc] initWithFrame: \
                                 CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                                                   collectionViewLayout:flowLayout];
        _actionCollectionView.delegate = self;
        _actionCollectionView.dataSource = self;
        _actionCollectionView.backgroundColor = [UIColor whiteColor];
        _actionCollectionView.showsHorizontalScrollIndicator = NO;
        [_actionCollectionView registerClass:[THNShareActionCollectionViewCell class] forCellWithReuseIdentifier:kShareActionCollectionViewCellId];
    }
    return _actionCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titlesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNShareActionCollectionViewCell *actionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kShareActionCollectionViewCellId
                                                                                             forIndexPath:indexPath];
    [actionCell thn_setActionImageNamed:self.imagesArr[indexPath.row] title:self.titlesArr[indexPath.row]];
    
    return actionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(thn_shareView:didSelectedShareActionIndex:)]) {
        [self.delegate thn_shareView:self didSelectedShareActionIndex:indexPath.row];
    }
}

@end
