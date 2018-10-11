//
//  THNUserDataModel.h
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNUserDataModel : NSObject

@property (nonatomic, assign) NSInteger master_uid;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *about_me;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *last_seen;
@property (nonatomic, strong) NSDictionary *avatar;

@end
