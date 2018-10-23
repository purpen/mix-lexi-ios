//
//  THNSearchDetailViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef void(^SearchDetailBlock)(NSString *searchWord, NSInteger selectButtonIndex, BOOL isClickTextFiled);

typedef NS_ENUM(NSUInteger, SearchChildVCType) {
    SearchChildVCTypeProduct,
    SearchChildVCTypeStore,
    SearchChildVCTypeUser
};

@interface THNSearchDetailViewController : THNBaseViewController

@property (nonatomic, assign) SearchChildVCType childVCType;
@property (nonatomic, copy) SearchDetailBlock searchDetailBlock;

@end
