//
//  THNLoginBaseView.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "THNConst.h"
#import "THNTextConst.h"

@interface THNLoginBaseView : UIView

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 副标题
 */
@property (nonatomic, strong) NSString *subTitle;

@end
