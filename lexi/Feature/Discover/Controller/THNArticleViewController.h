//
//  THNArticleViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, THNArticleType) {
    THNArticleTypeDefault = 0,  // 生活志文章
    THNArticleTypeNote,         // 种草笔记文章
};

@interface THNArticleViewController : THNBaseViewController

//生活志编号
@property (nonatomic, assign) NSInteger rid;

@end
