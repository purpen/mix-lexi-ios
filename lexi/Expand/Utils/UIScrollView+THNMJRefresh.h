//
//  UIScrollView+MJRefresh.h
//  lexi
//
//  Created by FLYang on 2018/10/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@protocol THNMJRefreshDelegate <NSObject>

@optional
- (void)beginRefreshing;
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage;

@end

@interface UIScrollView (THNMJRefresh)

/**
 数据列表：当前页数
 */
@property (nonatomic, strong) NSNumber *currentPage;

/**
 刷新、加载代理回调
 */
@property (nonatomic, weak) id <THNMJRefreshDelegate> refreshDelegate;

/**
 设置刷新头部

 @param className header 刷新样式类名称
 @param beginRefresh 第一次进入的自动刷新
 @param animation 刷新回调
 @param delegate 第一次进入是否显示动画
 */
- (void)setRefreshHeaderWithClass:(NSString *)className
                     beginRefresh:(BOOL)beginRefresh
                        animation:(BOOL)animation
                         delegate:(id<THNMJRefreshDelegate>)delegate;

/**
 设置加载底部

 @param className footer 加载样式类名称
 @param automaticallyRefresh 自动加载更多
 @param delegate 加载回调
 */
- (void)setRefreshFooterWithClass:(NSString *)className
             automaticallyRefresh:(BOOL)automaticallyRefresh
                         delegate:(id<THNMJRefreshDelegate>)delegate;

/**
 刷新
 */
- (void)beginHeaderRefresh;
- (void)endHeaderRefresh;
- (void)endHeaderRefreshAndCurrentPageChange:(BOOL)change;
- (void)removeHeaderRefresh;

/**
 加载更多
 */
- (void)beginFooterRefresh;
- (void)endFooterRefresh;
- (void)endFooterRefreshAndCurrentPageChange:(BOOL)change;
- (void)removeFooterRefresh;

/**
 数据全部加载完毕，没有更多
 */
- (void)noMoreData;
- (void)resetNoMoreData;

/**
 重置当前页数
 */
- (void)resetCurrentPageNumber;

@end

