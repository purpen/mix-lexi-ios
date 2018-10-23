//
//  THNLifeOrderDataModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeOrderDataModel : NSObject

@property (nonatomic, assign) NSInteger shipment_not_read;
@property (nonatomic, assign) NSInteger finish_not_read;
@property (nonatomic, assign) NSInteger pending_shipment_not_read;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *orders;

@end
