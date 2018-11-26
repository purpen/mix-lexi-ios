//
//  UIScrollView+MJRefresh.m
//  lexi
//
//  Created by FLYang on 2018/10/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UIScrollView+THNMJRefresh.h"
#import <objc/runtime.h>
#import "UIImage+GIF.h"

static NSString *const kTextFooterTitle  = @"正在加载...";
static NSString *const kTextFooterNoData = @"- END -";

@implementation UIScrollView (THNMJRefresh)

- (void)setRefreshHeaderWithClass:(NSString *)className beginRefresh:(BOOL)beginRefresh animation:(BOOL)animation delegate:(id<THNMJRefreshDelegate>)delegate {
    
    __weak typeof(self) weakSelf = self;
    self.refreshDelegate = delegate;
    
    if (!className.length) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakSelf;
            
            if ([strongSelf.refreshDelegate respondsToSelector:@selector(beginRefreshing)]) {
                [strongSelf.refreshDelegate performSelector:@selector(beginRefreshing)];
            }
        }];
    
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        [header setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStateIdle];
        [header setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStatePulling];
        [header setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStateRefreshing];
        self.mj_header = header;
        
    } else {
        Class headerClass = NSClassFromString(className);
        
        MJRefreshHeader *header =(MJRefreshHeader *)[headerClass headerWithRefreshingBlock:^{
            __strong typeof(self) strongSelf = weakSelf;
            
            if ([strongSelf.refreshDelegate respondsToSelector:@selector(beginRefreshing)]) {
                [strongSelf.refreshDelegate performSelector:@selector(beginRefreshing)];
            }
        }];
        
        self.mj_header =  header;
    }
    
    if (beginRefresh && animation) {
        [self beginHeaderRefresh];
        
    } else if (beginRefresh && !animation) {
        [self.mj_header executeRefreshingCallback];
    }
}

- (void)setRefreshFooterWithClass:(NSString *)className automaticallyRefresh:(BOOL)automaticallyRefresh delegate:(id<THNMJRefreshDelegate>)delegate {
    
    __weak typeof(self) weakSelf = self;
    self.refreshDelegate = delegate;
    
    if (!className.length) {
        if (automaticallyRefresh) {
            MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                
                if ([strongSelf.refreshDelegate respondsToSelector:@selector(beginLoadingMoreDataWithCurrentPage:)]) {
                    [strongSelf.refreshDelegate performSelector:@selector(beginLoadingMoreDataWithCurrentPage:)
                                                     withObject:strongSelf.currentPage];
                }
            }];

            footer.automaticallyRefresh = automaticallyRefresh;
            [footer setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStateIdle];
            [footer setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStatePulling];
            [footer setImages:[UIImage imagesWithGifNamed:@"loading"] forState:MJRefreshStateRefreshing];
            footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
            footer.stateLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:kTextFooterNoData forState:MJRefreshStateNoMoreData];
            footer.refreshingTitleHidden = YES;
            footer.stateLabel.hidden = !self.showNoMoreDataTitle;
            
            self.mj_footer = footer;
            
        } else {
            MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                
                if([strongSelf.refreshDelegate respondsToSelector:@selector(beginLoadingMoreDataWithCurrentPage:)]) {
                    [strongSelf.refreshDelegate performSelector:@selector(beginLoadingMoreDataWithCurrentPage:)
                                                     withObject:strongSelf.currentPage];
                }
            }];
            
            footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
            footer.stateLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            [footer setTitle:kTextFooterTitle forState:MJRefreshStateRefreshing];
            [footer setTitle:kTextFooterNoData forState:MJRefreshStateNoMoreData];
            
            self.mj_footer = footer;
        }
        
    } else {
        Class headerClass = NSClassFromString(className);
        
        if (automaticallyRefresh) {
            MJRefreshAutoFooter *footer =(MJRefreshAutoFooter *)[headerClass footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                
                if ([strongSelf.refreshDelegate respondsToSelector:@selector(beginLoadingMoreDataWithCurrentPage:)]) {
                    [strongSelf.refreshDelegate performSelector:@selector(beginLoadingMoreDataWithCurrentPage:)
                                                     withObject:strongSelf.currentPage];
                }
            }];
            
            footer.automaticallyRefresh = automaticallyRefresh;
            self.mj_footer = footer;
            
        }else {
            MJRefreshFooter *footer =(MJRefreshFooter *)[headerClass footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                
                if ([strongSelf.refreshDelegate respondsToSelector:@selector(beginLoadingMoreDataWithCurrentPage:)]) {
                    [strongSelf.refreshDelegate performSelector:@selector(beginLoadingMoreDataWithCurrentPage:)
                                                     withObject:strongSelf.currentPage];
                }
                
            }];
            
            self.mj_footer = footer;
        }
    }
}

#pragma mark - 刷新
- (void)beginHeaderRefresh {
    [self resetCurrentPageNumber];
    [self.mj_header beginRefreshing];
}

- (void)endHeaderRefresh {
    [self.mj_header endRefreshing];
}

- (void)endHeaderRefreshAndCurrentPageChange:(BOOL)change {
    [self resetCurrentPageNumber];
    
    if (change) {
        self.currentPage = @(self.currentPage.integerValue + 1);
    }
    
    [self endHeaderRefresh];
}

- (void)removeHeaderRefresh {
    self.mj_header = nil;
}

#pragma mark - 加载
- (void)beginFooterRefresh {
    [self.mj_footer beginRefreshing];
}

- (void)endFooterRefresh {
    [self.mj_footer endRefreshing];
}

- (void)endFooterRefreshAndCurrentPageChange:(BOOL)change {
    if (change) {
        self.currentPage = @(self.currentPage.integerValue + 1);
    }
    
    [self endFooterRefresh];
}

- (void)removeFooterRefresh {
    self.mj_footer = nil;
}

#pragma mark -
- (void)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

- (void)resetCurrentPageNumber {
    self.currentPage = @(1);
}

#pragma mark - getters and setters
- (BOOL)showNoMoreDataTitle {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return [number boolValue];
    }
    
    return YES;
}

- (void)setShowNoMoreDataTitle:(BOOL)showNoMoreDataTitle {
    objc_setAssociatedObject(self, @selector(showNoMoreDataTitle), @(showNoMoreDataTitle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)currentPage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentPage:(NSNumber *)currentPage {
    objc_setAssociatedObject(self, @selector(currentPage), currentPage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<THNMJRefreshDelegate>)refreshDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRefreshDelegate:(id<THNMJRefreshDelegate>)refreshDelegate {
    objc_setAssociatedObject(self, @selector(refreshDelegate), refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

@end
