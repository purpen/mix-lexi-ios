//
//  THNUserModel.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNUserModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger fans_counts;
@property (nonatomic, assign) NSInteger followed_status;
@property (nonatomic, assign) NSInteger followed_stores_counts;
@property (nonatomic, assign) NSInteger followed_users_counts;
@property (nonatomic, assign) NSInteger store_phases;
@property (nonatomic, assign) NSInteger user_like_counts;
@property (nonatomic, assign) NSInteger wish_list_counts;
@property (nonatomic, assign) NSInteger has_order;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *about_me;
@property (nonatomic, copy) NSString *avatar;

@end
