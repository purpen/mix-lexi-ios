//
//  THNLifeOrderProductTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLifeOrderProductTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showEearnings;

- (void)thn_setLifeOrderProductData:(NSDictionary *)data;

@end
