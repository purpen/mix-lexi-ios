//
//  THNGoodsListCollectionReusableView.h
//  lexi
//
//  Created by FLYang on 2018/9/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"

@interface THNGoodsListCollectionReusableView : UICollectionReusableView

- (void)thn_setShowContentWithListType:(THNGoodsListViewType)listType userData:(NSArray *)userData;

@end
