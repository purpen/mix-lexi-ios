//
//  THNImagesToolBar.h
//  lexi
//
//  Created by FLYang on 2018/12/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
#import <YBImageBrowser/YBImageBrowserToolBarProtocol.h>

@interface THNImagesToolBar : UIView <YBImageBrowserToolBarProtocol>

/**
 商品数据
 */
@property (nonatomic, strong) THNGoodsModel *goodsModel;

@end
