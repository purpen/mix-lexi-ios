//
//  THNNewShippingAddressViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNAddressModel.h"

@interface THNNewShippingAddressViewController : THNBaseViewController

/**
 地址
 */
@property (nonatomic, strong) THNAddressModel *addressModel;
// 后台是否保存海关信息
@property (nonatomic, assign) BOOL isSaveCustom;

@end
