//
//  THNNewUserInfoView.h
//  lexi
//
//  Created by FLYang on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

@protocol THNNewUserInfoViewDelegate <NSObject>

@optional
- (void)thn_setUserInfoEditDoneWithParam:(NSDictionary *)infoParam;
- (void)thn_setUserInfoSelectHeader;

@end

@interface THNNewUserInfoView : THNLoginBaseView

@property (nonatomic, weak) id <THNNewUserInfoViewDelegate> delegate;

/**
 设置头像
 */
- (void)setHeaderImageWithData:(NSData *)imageData;

/**
 上传七牛后的图片id
 */
- (void)setHeaderAvatarId:(NSInteger)idx;

@end
