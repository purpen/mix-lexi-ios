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
- (void)loadSearchHistory:(NSArray *)historyShowSearchArr;
- (void)loadSearchIndex:(NSString *)searchWord;
- (void)removeSearchIndexView;

@end

@interface THNSearchView : UIView

- (void)readHistorySearch;
@property (nonatomic, weak) id <THNSearchViewDelegate> delegate;

- (void)layoutSearchView:(SearchViewType)searchViewType;

@end
