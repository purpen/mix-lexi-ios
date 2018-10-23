//
//  THNArticleProductTableViewCell.h
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ArticleProductBlcok)(NSString *rid);

@interface THNArticleProductTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) ArticleProductBlcok articleProductBlcok;

@end
