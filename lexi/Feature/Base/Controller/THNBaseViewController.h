//
//  THNBaseViewController.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIView+LayoutMethods.h"
#import "UIView+HandyAutoLayout.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SVProgressHUD+Helper.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "THNTextConst.h"
#import "THNNavigationBarView.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>

@interface THNBaseViewController : UIViewController

/**
 自定义导航栏
 */
@property (nonatomic, strong) THNNavigationBarView *navigationBarView;

@end
