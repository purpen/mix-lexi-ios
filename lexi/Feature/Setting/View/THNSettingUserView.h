//
//  THNSettingUserView.h
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNUserDataModel.h"

@interface THNSettingUserView : UIView

@property (nonatomic, copy) NSString *headId;

- (void)thn_setUserInfoData:(THNUserDataModel *)model;
- (void)thn_setHeaderImageWithData:(NSData *)imageData;

@end
