//
//  THNAdvertManager.h
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNAdvertManager : NSObject <NSCoding>

/**
 是否领取过新人红包
 */
@property (nonatomic, assign) BOOL isGrant;

/**
 是否可以领取红包
 */
+ (BOOL)canGetBonus;

/**
 清除信息
 */
- (void)clearAdvertInfo;

/**
 检查是否领取过新人红包
 */
+ (void)checkIsNewUserBonus;

/**
 更新领取状态信息
 */
- (void)updateGrantStatus:(BOOL)status;

+ (instancetype)sharedManager;

@end
