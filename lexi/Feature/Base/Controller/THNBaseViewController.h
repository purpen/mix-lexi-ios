//
//  THNBaseViewController.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNNavigationBarView.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"
#import "UIView+LayoutMethods.h"
#import "UIView+HandyAutoLayout.h"
#import "SVProgressHUD+Helper.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "THNTextConst.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIScrollView+THNMJRefresh.h"
#import "UIViewController+THNHud.h"

@interface THNBaseViewController : UIViewController

/**
 自定义导航栏
 */
@property (nonatomic, strong) THNNavigationBarView *navigationBarView;

@end
