//
//  THNSearchView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 搜索显示样式

 - SearchViewTypeDefautl: 显示取消按钮
 - SearchViewTypeNoCancel: 不显示取消按钮
 */
typedef NS_ENUM(NSUInteger, SearchViewType) {
    SearchViewTypeDefault,
    SearchViewTypeNoCancel
};

@protocol THNSearchViewDelegate<NSObject>

@optional
- (void)back;
/**
 加载历史记录列表

 @param historyShowSearchArr 历史记录数组
 */
- (void)loadSearchHistory:(NSArray *)historyShowSearchArr;

/**
 加载索引列表数据

 @param textFieldText 输入框的内容
 */
- (void)loadSearchIndex:(NSString *)textFieldText;
// 移除索引列表
- (void)removeSearchIndexView;
- (void)pushSearchDetailVC;

@end

@interface THNSearchView : UIView

- (void)readHistorySearch;
- (void)addHistoryModelWithText:(NSString *)text;
- (void)layoutSearchView:(SearchViewType)searchViewType withSearchKeyword:(NSString *)searchKeyword;
@property (nonatomic, weak) id <THNSearchViewDelegate> delegate;
@property (nonatomic, strong) NSString *searchWord;

@end
