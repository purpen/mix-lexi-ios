//
//  THNFunctionCollectionView.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNFunctionCollectionViewDelegate <NSObject>

- (void)thn_getCategoryId:(NSInteger)cid selected:(BOOL)selected;
- (void)thn_getRecommandTags:(NSString *)selectTag selected:(BOOL)selected;

@end

typedef NS_ENUM(NSUInteger, THNFunctionCollectionViewType) {
    THNFunctionCollectionViewTypeCategory = 0,  //  分类
    THNFunctionCollectionViewTypeRecommend,     //  推荐
};

@interface THNFunctionCollectionView : UIView

@property (nonatomic, weak) id <THNFunctionCollectionViewDelegate> delegate;

- (void)thn_resetLoad;

/**
 设置分类数据

 @param data 分类数据
 */
- (void)thn_setCollecitonViewCellData:(NSArray *)data;

/**
 设置推荐标签

 @param tags 标签
 */
- (void)thn_setRecommandTag:(NSArray *)tags;

- (instancetype)initWithFrame:(CGRect)frame viewType:(THNFunctionCollectionViewType)type;

@end
