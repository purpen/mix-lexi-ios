//
//  THNLivingHallHeaderView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLivingHallHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *noProductView;

- (void)setLifeStore;
@property (nonatomic, strong) NSString *storeAvatarUrl;

@end
