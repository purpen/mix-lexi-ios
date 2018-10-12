//
//  THNArticleViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleViewController.h"
#import "THNGoodsContentTableViewCell.h"
#import "YYLabel+Helper.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import "THNGrassListModel.h"
#import "THNGoodsModelDealContent.h"
#import "THNArticleHeaderView.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const kArticleContentCellIdentifier = @"kArticleContentCellIdentifier";
static NSString *const kUrlLifeRecordsDetail = @"/life_records/detail";

@interface THNArticleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) THNGrassListModel *grassListModel;
@property (nonatomic, strong) NSMutableArray *contentModels;
@property (nonatomic, strong) THNArticleHeaderView *articleHeaderView;

@end

@implementation THNArticleViewController {
    CGFloat tableViewY;
    CGFloat articleHeaderViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableViewY = kDeviceiPhoneX ? -44 : -22;
    articleHeaderViewHeight =  kDeviceiPhoneX ? 340 + 88 + 44 : 340 + 64 + 22;
    [self loadLifeRecordsDetailData];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.transparent = YES;
    [self.navigationBarView setNavigationCloseButton];
    [self.navigationBarView setNavigationCloseButtonHidden:YES];
    [self.view addSubview:self.tableView];
//    self.tableView.hidden = YES;
}

- (void)loadLifeRecordsDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    [SVProgressHUD showInfoWithStatus:@""];
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
//        self.tableView.hidden = NO;
        self.grassListModel = [THNGrassListModel mj_objectWithKeyValues:result.data];
        
        for (NSDictionary *dict in self.grassListModel.deal_content) {
            THNGoodsModelDealContent *contenModel = [THNGoodsModelDealContent mj_objectWithKeyValues:dict];
            [self.contentModels addObject:contenModel];
        }
        
        [self.tableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

/**
 获取图文详情的高度
 */
- (CGFloat)thn_getGoodsDealContentHeightWithContent:(NSArray *)content {
    CGFloat contentH = 0.0;
    
    for (THNGoodsModelDealContent *model in content) {
        if ([model.type isEqualToString:@"text"]) {
            CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:model.content
                                                                 fontSize:14
                                                              lineSpacing:7
                                                                  fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
            contentH += (textH + 10);
            
        } else if ([model.type isEqualToString:@"image"]) {
            UIImage *contentImage = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.content]]];
            CGFloat image_scale = (kScreenWidth - 30) / contentImage.size.width;
            CGFloat image_h = contentImage.size.height * image_scale;
            
            contentH += (image_h + 10);
        }
    }
    
    return contentH + 20;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNGoodsContentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[THNGoodsContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kArticleContentCellIdentifier];
    }
    
    [cell thn_setContentData:self.contentModels];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self thn_getGoodsDealContentHeightWithContent:self.contentModels];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.grassListModel) {
        [self.articleHeaderView setGrassListModel:self.grassListModel];
    }
   
    return self.articleHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize titleSize = CGSizeMake(SCREEN_WIDTH - 40, 56);
    NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]};
    CGFloat titleHeight = [self.grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
    return articleHeaderViewHeight + titleHeight;
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"THNGoodsContentTableViewCell" bundle:nil] forCellReuseIdentifier:kArticleContentCellIdentifier];
    }
    return _tableView;
}

- (THNArticleHeaderView *)articleHeaderView {
    if (!_articleHeaderView) {
        _articleHeaderView = [THNArticleHeaderView viewFromXib];
    }
    return _articleHeaderView;
}

- (NSMutableArray *)contentModels {
    if (!_contentModels) {
        _contentModels = [NSMutableArray array];
    }
    return _contentModels;
}

@end
