//
//  THNSettingInfoTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNUserDataModel.h"

typedef NS_ENUM(NSUInteger, THNSettingInfoType) {
    THNSettingInfoTypeName = 0, // 昵称
    THNSettingInfoTypeSlogan,   // 个人介绍
    THNSettingInfoTypeEmail,    // 邮箱
    THNSettingInfoTypeLocation, // 位置
    THNSettingInfoTypeDate,     // 生日
    THNSettingInfoTypeSex,      // 性别
};

@interface THNSettingInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) THNSettingInfoType type;

- (void)thn_setUserInfoData:(THNUserDataModel *)model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView tyep:(THNSettingInfoType)type;

@end
