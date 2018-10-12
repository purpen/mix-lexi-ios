//
//  THNGrassListModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNGrassListModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_avator;
@property (nonatomic, strong) NSString *channel_name;
@property (nonatomic, assign) CGFloat grassLabelHeight;

@end
