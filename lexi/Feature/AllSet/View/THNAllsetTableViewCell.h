//
//  THNAllsetTableViewCell.h
//  lexi
//
//  Created by rhp on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCollectionModel;
typedef void(^AllsetBlock)(NSString *rid);
typedef void(^PushSetDetailBlock)(NSInteger collectionRid);

@interface THNAllsetTableViewCell : UITableViewCell

@property (nonatomic, strong) THNCollectionModel *collectionModel;
@property (nonatomic, copy) AllsetBlock allsetBlcok;
@property (nonatomic, copy) PushSetDetailBlock pushDetailBlock;

@end
