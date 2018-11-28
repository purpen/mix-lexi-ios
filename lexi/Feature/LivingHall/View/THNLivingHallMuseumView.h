//
//  THNLivingHallMuseumView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadLivingHallBlock)(void);

@interface THNLivingHallMuseumView : UIView

@property (nonatomic, copy) ReloadLivingHallBlock reloadLivingHallBlock;
- (void)setLivingHallMuseumViewWithTitle:(NSString *)title withContent:(NSString *)content;

@end
