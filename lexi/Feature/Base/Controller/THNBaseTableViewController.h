//
//  THNBaseTableViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import "UIColor+Extension.h"
#import "UIView+LayoutMethods.h"
#import "UIView+HandyAutoLayout.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "THNTextConst.h"
#import "THNAPI.h"
#import "THNTableViewSections.h"
#import "THNTableViewCells.h"
#import "THNNavigationBarView.h"
@class THNTableViewFooterView;

typedef NS_ENUM(NSUInteger, THNTableViewCellSeparatorStyle) {
    THNTableViewCellSeparatorStyleDefault = 0,  // 默认分隔线
    THNTableViewCellSeparatorStyleNone,         // 没有分隔线
    THNTableViewCellSeparatorStyleFull,         // cell 宽度的分隔线
    THNTableViewCellSeparatorStyleMargin        // 左边带间距
};

@interface THNBaseTableViewController : UITableViewController

/**
 自定义导航栏
 */
@property (nonatomic, strong) THNNavigationBarView *navigationBarView;

/**
 分割线样式
 */
@property (nonatomic, assign) THNTableViewCellSeparatorStyle separatorStyle;

/**
 组
 */
@property (nonatomic, strong) NSMutableArray *dataSections;

/**
 对显示的组重新排序
 */
- (void)thn_sortDataSecitons;

/**
 设置数据缺省时的视图
 */
- (void)thn_setTableViewFooterView:(THNTableViewFooterView *)view;

@end
