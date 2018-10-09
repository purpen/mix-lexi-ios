//
//  THNLifeHintView.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNLifeHintViewDelegate <NSObject>

- (void)thn_checkWechatInfo;

@end

@interface THNLifeHintView : UIView

@property (nonatomic, weak) id <THNLifeHintViewDelegate> delegate;

@end
