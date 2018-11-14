//
//  THNDynamicHeaderView.h
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNDynamicModel.h"

typedef NS_ENUM(NSUInteger, THNDynamicHeaderViewType) {
    THNDynamicHeaderViewTypeDefault = 0,   // 自己的动态
    THNDynamicHeaderViewTypeOther,         // 别人的动态
};


@protocol THNDynamicHeaderViewDelegate <NSObject>

@required
- (void)thn_createWindow;

@end

@interface THNDynamicHeaderView : UIView

@property (nonatomic, assign) THNDynamicHeaderViewType viewType;
@property (nonatomic, weak) id <THNDynamicHeaderViewDelegate> delegate;

- (void)thn_setDynamicUserModel:(THNDynamicModel *)model;

@end
