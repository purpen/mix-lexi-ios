//
//  THNSearchIndexTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNSearchIndexModel;

@interface THNSearchIndexTableViewCell : UITableViewCell

@property (nonatomic, strong) THNSearchIndexModel *searchIndexModel;
@property (nonatomic, strong) NSMutableString *textFieldText;

@end
