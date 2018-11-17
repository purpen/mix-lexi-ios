//
//  THNShopWindowResultHeaderView.h
//  lexi
//
//  Created by rhp on 2018/11/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultHeaderViewBlock)(void);

@interface THNShopWindowResultHeaderView : UIView

@property (nonatomic, copy) ResultHeaderViewBlock resultHeaderViewBlock;
@property (nonatomic, strong) NSString *name;

@end
