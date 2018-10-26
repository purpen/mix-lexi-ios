//
//  THNCartDefaultView.h
//  lexi
//
//  Created by FLYang on 2018/9/19.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartDefaultDiscoverBlock)(void);

@interface THNCartDefaultView : UIView

@property (nonatomic, copy) CartDefaultDiscoverBlock cartDefaultDiscoverBlock;

@end
