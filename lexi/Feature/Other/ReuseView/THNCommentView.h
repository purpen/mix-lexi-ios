//
//  THNCommentView.h
//  lexi
//
//  Created by rhp on 2018/11/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNGrassListModel;

@protocol THNCommentViewDelegate <NSObject>

@optional
- (void)showKeyboard;
- (void)lookComment;

@end

@interface THNCommentView : UIView

@property (nonatomic, weak) id <THNCommentViewDelegate> delegate;

@property (nonatomic, strong) THNGrassListModel *grassListModel;

@end
