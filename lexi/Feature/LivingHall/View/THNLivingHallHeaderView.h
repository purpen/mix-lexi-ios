//
//  THNLivingHallHeaderView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeHeaderViewBlock)(void);
typedef void(^PushProductCenterBlock)(void);

@interface THNLivingHallHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *noProductView;

- (void)setLifeStore;
@property (nonatomic, strong) NSString *storeAvatarUrl;
@property (nonatomic, copy) ChangeHeaderViewBlock changeHeaderViewBlock;
@property (nonatomic, copy) PushProductCenterBlock pushProductCenterBlock;

@end
