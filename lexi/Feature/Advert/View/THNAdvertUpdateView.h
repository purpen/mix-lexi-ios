//
//  THNAdvertUpdateView.h
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNAdvertUpdateViewDelegate <NSObject>

- (void)thn_updateDoneAction;
- (void)thn_updateCancelAction;

@end

@interface THNAdvertUpdateView : UIView

@property (nonatomic, weak) id <THNAdvertUpdateViewDelegate> delegate;

- (void)thn_setUpdateContents:(NSArray *)contents;

@end
