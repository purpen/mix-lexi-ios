//
//  THNNewUserInfoView.h
//  lexi
//
//  Created by FLYang on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

@protocol THNNewUserInfoViewDelegate <NSObject>

@required
/**
 确认用户信息

 @param infoParam 信息数据
 */
- (void)thn_setUserInfoEditDoneWithParam:(NSDictionary *)infoParam;

/**
 选择头像图片
 */
- (void)thn_setUserInfoSelectHeader;

@end

@interface THNNewUserInfoView : THNLoginBaseView

@property (nonatomic, weak) id <THNNewUserInfoViewDelegate> delegate;

/**
 设置头像

 @param imageData 图片数据
 */
- (void)setHeaderImageWithData:(NSData *)imageData;

/**
 上传七牛后的id

 @param idx 图片id
 */
- (void)setHeaderAvatarId:(NSInteger)idx;

@end