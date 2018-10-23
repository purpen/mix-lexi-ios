//
//  THNLivingHallExpandView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadMoreDataBlock)(void);

@interface THNLivingHallExpandView : UIView

@property (nonatomic, copy) LoadMoreDataBlock loadMoreDateBlcok;

@end
