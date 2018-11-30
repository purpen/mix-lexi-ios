//
//  THNShareActionView.h
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THNShareActionView;

typedef NS_ENUM(NSUInteger, THNShareActionViewType) {
    THNShareActionViewTypeThird = 0,    // 第三方分享
    THNShareActionViewTypeMore,         // 分享更多
    THNShareActionViewTypeImage,        // 分享更多+保存图片
};

@protocol THNShareActionViewDelegate <NSObject>

- (void)thn_shareView:(THNShareActionView *)shareView didSelectedShareActionIndex:(NSInteger)index;

@end

@interface THNShareActionView : UIView

@property (nonatomic, weak) id <THNShareActionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(THNShareActionViewType)type;

@end
