//
//  THNEvaluationViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNEvaluationViewController.h"
#import "THNEvaluationTableViewCell.h"
#import "THNOrdersItemsModel.h"
#import "THNMarco.h"
#import "THNPhotoManager.h"
#import "THNQiNiuUpload.h"
#import "UIView+Helper.h"

static NSString *const kEvaluationCellIdentifier = @"kEvaluationCellIdentifier";
static NSString *const kCreateComment = @"/orders/user_comment/create";

@interface THNEvaluationViewController () <UITableViewDelegate, UITableViewDataSource, THNEvaluationTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (nonatomic, strong) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation THNEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setCommentParams];
    
}

// 设置提交订单的参数
- (void)setCommentParams {
    for (NSDictionary *dict in self.products) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        itemDict[@"sku_rid"] = dict[@"rid"];
        [self.items addObject:itemDict];
    }
}

- (IBAction)commitOrder:(id)sender {
    [SVProgressHUD thn_show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (NSMutableDictionary *itemDict in self.items) {
        [itemDict removeObjectForKey:@"imageDatas"];
    }
    
    params[@"order_rid"] = self.rid;
    params[@"items"] = self.items;
    THNRequest *request = [THNAPI postWithUrlString:kCreateComment requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showSuccessWithStatus:@"评价成功"];
        [SVProgressHUD dismissWithCompletion:^{
            
            if (self.ealuationBlock) {
                self.ealuationBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.navigationBarView.title = @"评价";
    self.tableTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    // 抖动闪动漂移等问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNEvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:kEvaluationCellIdentifier];
    [self.commitButton drawCornerWithType:0 radius:4];
    self.commitButton.alpha = 0.5;
    self.commitButton.enabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEvaluationCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNOrdersItemsModel *itemModel = [THNOrdersItemsModel mj_objectWithKeyValues:self.products[indexPath.row]];
    [cell setItemsModel:itemModel];
    [cell reloadPhoto:self.items[indexPath.row][@"imageDatas"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imageArray = self.items[indexPath.row][@"imageDatas"];
    NSInteger showRows = imageArray.count / 4 + 1;
    return 370 + (SCREEN_WIDTH - 15 * 2) / 4 * showRows;
}

// 隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - THNEvaluationTableViewCellDelegate
- (void)commentStart:(NSInteger)startCount initWithTag:(NSInteger)tag {
    NSMutableDictionary *dict = self.items[tag];
    dict[@"score"] = @(startCount);
    
    if (dict.count > 2) {
        self.commitButton.enabled = YES;
    }
    
    for (NSDictionary *itemDict in self.items) {
        if (itemDict.count > 2) {
            self.commitButton.enabled = YES;
            self.commitButton.alpha = 1;
        } else {
            self.commitButton.enabled = NO;
            self.commitButton.alpha = 0.5;
        }
    }
}

- (void)comment:(NSString *)commentText initWithTag:(NSInteger)tag {
    NSMutableDictionary *dict = self.items[tag];
    dict[@"content"] = commentText;
    
    if (commentText.length == 0) {
        [dict removeObjectForKey:@"content"];
    }
    
    for (NSDictionary *itemDict in self.items) {
        if (itemDict.count > 2) {
            self.commitButton.enabled = YES;
            self.commitButton.alpha = 1;
        } else {
            self.commitButton.enabled = NO;
            self.commitButton.alpha = 0.5;
        }
    }
   
}

- (void)selectPhoto:(NSInteger)tag {
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                       compltion:^(NSDictionary *result) {
                                                           NSMutableDictionary *dict = self.items[tag];
                                                           
                                                           NSMutableArray *imageIDMutableArray = [NSMutableArray arrayWithArray:dict[@"asset_ids"]];
                                                           NSInteger assetID = [result[@"ids"][0] integerValue];
                                                           [imageIDMutableArray addObject:@(assetID)];
                                                           dict[@"asset_ids"] = imageIDMutableArray;
                                                           NSMutableArray *imageMutableArray = [NSMutableArray arrayWithArray:dict[@"imageDatas"]];
                                                           [imageMutableArray addObject:imageData];
                                                           dict[@"imageDatas"] = imageMutableArray;
                                                           [self.tableView reloadData];
                                                       }];
        
    }];
}

- (void)deleteProductTag:(NSInteger)productTag initWithPhotoTag:(NSInteger)photoTag {
    NSMutableDictionary *dict = self.items[productTag];
     NSMutableArray *imageIDMutableArray = [NSMutableArray arrayWithArray:dict[@"asset_ids"]];
    
    if (imageIDMutableArray.count == 0) {
        return;
    }
    
    [imageIDMutableArray removeObjectAtIndex:photoTag];
    dict[@"asset_ids"] = imageIDMutableArray;
}

#pragma mark - lazy
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
