//
//  THNDidcoverSetView.h
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DiscoverSetBlcok)(NSInteger selectIndex, NSString *title);

@interface THNDidcoverSetView : UIView

@property (nonatomic, copy) DiscoverSetBlcok discoverSetBlcok;

@end
