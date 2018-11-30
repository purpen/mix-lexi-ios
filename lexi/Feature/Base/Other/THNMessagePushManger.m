//
//  THNMessagePushManger.m
//  lexi
//
//  Created by HongpingRao on 2018/11/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMessagePushManger.h"
#import "THNBrandHallViewController.h"
#import "THNLogisticsViewController.h"
#import "THNOrdersItemsModel.h"
#import <MJExtension/MJExtension.h>
#import "THNShopWindowDetailViewController.h"

typedef NS_ENUM(NSUInteger, MessagePushType) {
    MessagePushTypeExpress = 1,
    MessagePushTypeBrandHall,
    MessagePushTypeShowWindow,
};

@implementation THNMessagePushManger

+ (void)pushMessageTypeWithNavigationVC:(THNBaseNavigationController *)navi
                       initWithUserInfo:(NSDictionary *)userInfo {
    MessagePushType type = [userInfo[@"type"] integerValue];
    switch (type) {

        case MessagePushTypeExpress:{
            THNOrdersItemsModel *itemsModel = [THNOrdersItemsModel mj_objectWithKeyValues:userInfo];
            THNLogisticsViewController *logisticsVC = [[THNLogisticsViewController alloc] init];
            logisticsVC.orderRid = userInfo[@"order_rid"];
            logisticsVC.itemsModel = itemsModel;
            [navi pushViewController:logisticsVC animated:YES];
            break;
        }
           
        case MessagePushTypeBrandHall: {
            THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc] init];
            brandHallVC.rid = userInfo[@"store_rid"];
            [navi pushViewController:brandHallVC animated:YES];
            break;
        }
        
        case MessagePushTypeShowWindow:{
            THNShopWindowDetailViewController *showWindowDetailVC = [[THNShopWindowDetailViewController alloc] init];
            showWindowDetailVC.rid = [NSString stringWithFormat:@"%ld",[userInfo[@"show_window_rid"] integerValue]];
            [navi pushViewController:showWindowDetailVC animated:YES];
            break;
        }
            
    }
}

@end
