//
//  THNMyCenterMenuView.h
//  lexi
//
//  Created by FLYang on 2018/10/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNMyCenterMenuViewDelegate <NSObject>

- (void)thn_didSelectedMenuButtonIndex:(NSInteger)index;

@end

@interface THNMyCenterMenuView : UIView

@property (nonatomic, weak) id <THNMyCenterMenuViewDelegate> delegate;

@end
