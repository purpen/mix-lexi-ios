//
//  THNDiscoverViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"
#import "THNDiscoverThemeViewController.h"
#import "THNAPI.h"
#import "THNDiscoverTableViewCell.h"
#import "THNTextCollectionView.h"
#import "THNGrassListModel.h"

static NSString *const kUrGuessLikes = @"/life_records/guess_likes";
static NSString *const kUrWonderfulStories = @"/life_records/wonderful_stories";
static NSString *const kDiscoverCellIdentifier = @"kDiscoverCellIdentifier";

@interface THNDiscoverViewController ()

@property (nonatomic, strong) NSArray *guessLikes;
@property (nonatomic, strong) NSArray *wonderfulStories;

@end

@implementation THNDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWonderfulStoriesData];
    [self loadGuessLikesData];
    [self setupUI];
}

- (void)psuhNext {
    THNDiscoverThemeViewController *theme = [[THNDiscoverThemeViewController alloc]init];
    [self.navigationController pushViewController:theme animated:YES];
}

// 猜你喜欢
- (void)loadGuessLikesData {
    THNRequest *request = [THNAPI getWithUrlString:kUrGuessLikes requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.guessLikes = result.data[@"life_records"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 精彩故事
- (void)loadWonderfulStoriesData {
    THNRequest *request = [THNAPI getWithUrlString:kUrWonderfulStories requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.wonderfulStories = result.data[@"life_records"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.navigationBarView.title = kTitleDiscover;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNDiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:kDiscoverCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDiscoverCellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.collectionView.dataArray = self.guessLikes;
            break;
            
        default:
            cell.collectionView.dataArray = self.wonderfulStories;
            break;
    }
    [cell.collectionView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return [self getCellHeight:self.guessLikes];
            break;
            
        default:
            return [self getCellHeight:self.wonderfulStories];
            break;
    }
    
}

- (CGFloat)getCellHeight:(NSArray *)array {
    __block CGFloat firstRowMaxtitleHeight = 0;
    __block CGFloat firstRowMaxcontentHeight = 0;
    __block CGFloat secondRowMaxtitleHeight = 0;
    __block CGFloat secondRowMaxcontentHeight = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:obj];
        //  设置最大size
        CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
        CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
        CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
        CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
        NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]};
        NSDictionary *contentFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:11]};
        CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
        CGFloat contentHeight = [grassListModel.content boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
        
        // 取出第一列最大的titleLabel和contentLabel的高度
        if (idx <= 1) {
            
            if (titleHeight > firstRowMaxtitleHeight) {
                firstRowMaxtitleHeight = titleHeight;
            }
            
            if (contentHeight > secondRowMaxtitleHeight ) {
                firstRowMaxcontentHeight = contentHeight;
            }
            // 取出第二列最大的titleLabel和contentLabel的高度
        } else {
            
            if (titleHeight > secondRowMaxtitleHeight) {
                secondRowMaxtitleHeight = titleHeight;
            }
            
            if (contentHeight > secondRowMaxcontentHeight) {
                secondRowMaxcontentHeight = titleHeight;
            }
            
        }
    }];
    
    CGFloat customGrassCellHeight = firstRowMaxtitleHeight + secondRowMaxtitleHeight + firstRowMaxcontentHeight + secondRowMaxcontentHeight;
    return 158 * 2 + customGrassCellHeight + 20 + 90;
}


@end
