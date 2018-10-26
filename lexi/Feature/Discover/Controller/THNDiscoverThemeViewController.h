//
//  THNDiscoverThemeViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//
#import "THNBaseViewController.h"



/**
 展示发现主题的类型

 - DiscoverThemeTypeCreatorStory: 创作人故事
 - DiscoverThemeTypeGrassNote: 种草笔记
 - DiscoverThemeTypeLifeRemember: 生活记事
 - DiscoverThemeTypeHandTeach: 手作教学
 */
typedef NS_ENUM(NSUInteger, DiscoverThemeType) {
    DiscoverThemeTypeCreatorStory,
    DiscoverThemeTypeGrassNote,
    DiscoverThemeTypeLifeRemember,
    DiscoverThemeTypeHandTeach
};

@interface THNDiscoverThemeViewController : THNBaseViewController

@property (nonatomic, assign) DiscoverThemeType themeType;
@property (nonatomic, strong) NSString *navigationBarViewTitle;

@end
