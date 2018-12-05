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

@protocol THNImagesToolBarDelegate <NSObject>

@required
- (void)thn_goodsImageBuyGoodsAction;
- (void)thn_goodsImageShareGoodsAction;

@end

@interface THNImagesToolBar : UIView <YBImageBrowserToolBarProtocol>

@property (nonatomic, weak) id <THNImagesToolBarDelegate> delegate;

- (instancetype)initWithGoodsModel:(THNGoodsModel *)model;

@end
