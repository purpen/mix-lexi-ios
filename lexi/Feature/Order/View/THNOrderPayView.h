//
//  THNOrderPayView.h
//  lexi
//
//  Created by HongpingRao on 2018/10/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderPayViewBlock)(void);

@interface THNOrderPayView : UIView

@property (nonatomic, strong) NSArray *orderLists;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (nonatomic, copy) OrderPayViewBlock payViewBlock;

@end
