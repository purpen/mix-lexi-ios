//
//  THNEvaluationTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrdersItemsModel;

@protocol THNEvaluationTableViewCellDelegate<NSObject>

@optional
- (void)commentStart:(NSInteger)startCount initWithTag:(NSInteger)tag;
- (void)comment:(NSString *)commentText initWithTag:(NSInteger)tag;
- (void)selectPhoto:(NSInteger)tag;
- (void)deleteProductTag:(NSInteger)productTag initWithPhotoTag:(NSInteger)photoTag;

@end

@interface THNEvaluationTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersItemsModel *itemsModel;
- (void)reloadPhoto:(NSMutableArray *)imageMutableArray;
@property (nonatomic, weak) id <THNEvaluationTableViewCellDelegate> delegate;

@end
