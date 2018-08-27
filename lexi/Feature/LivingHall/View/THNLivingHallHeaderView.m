//
//  THNLivingHallHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeaderView.h"
#import "THNBannnerCollectionViewCell.h"
#import "UIView+Helper.h"
#import "THNAPI.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNSetModel.h"
#import "THNMarco.h"
#import "UIImageView+WebCache.h"
#import "THNLoginManager.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNUserPartieModel.h"
#import "UIColor+Extension.h"
#import "THNProductModel.h"
#import "THNLivingHallMuseumView.h"
#import "THNSaveTool.h"
#import "THNConst.h"

static NSString *const kAvatarCellIdentifier = @"kAvatarCellIdentifier";
// 商家生活馆的信息
static NSString *const kUrlLifeStore = @"/store/life_store";
// 选品中心
static NSString *const kUrlSelectProductCenter= @"/fx_distribute/choose_center";

@interface THNLivingHallHeaderView()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *browseCountLabel;
// 浏览最大显示人数显示999+
@property (weak, nonatomic) IBOutlet UILabel *browseMaxShowLabel;
@property (weak, nonatomic) IBOutlet UIView *livingHallView;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tintLabels;
// 选品中心的头像
@property (weak, nonatomic) IBOutlet UIImageView *insideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outsideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionTitleConstraint;
@property (nonatomic, strong) THNLoginManager *loginManger;
@property (nonatomic, strong) NSArray *userPartieArray;
@property (nonatomic, strong) NSArray *selectProductArray;

@end

@implementation THNLivingHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 添加阴影
    [self.livingHallView drwaShadow];
    self.livingHallView.layer.borderWidth = 0;
    self.avatarCollectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:-5 initWithWidth:29 initwithHeight:29];
    self.avatarCollectionView.scrollEnabled = NO;   
    [self.avatarCollectionView setCollectionViewLayout:flowLayout];
    [self.avatarCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kAvatarCellIdentifier];
    [self.storeAvatarImageView drawCornerWithType:0 radius:4];
    [self.insideImageView drawCornerWithType:0 radius:4];
    [self.middleImageView drawCornerWithType:0 radius:4];
    [self.outsideImageView drawCornerWithType:0 radius:4];
    [self.insideImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg"]];
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg"]];
    [self.outsideImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"]];
    
    // 适配5S的样式
    if (SCREEN_WIDTH == 320) {
        for (UILabel *label in self.tintLabels) {
            label.font = [UIFont systemFontOfSize:9];
        }
        self.selectionTitleConstraint.constant = 3;
    }
    
    if ([THNSaveTool objectForKey:kIsCloseLivingHallView]) {
        self.promptViewHeightConstraint.constant = 0;
        self.promptView.hidden = YES;
    }
}

- (void)setLifeStore {
    THNLoginManager *loginManger = [THNLoginManager sharedManager];
    self.loginManger = loginManger;
    [self loadLifeStoreData];
    [self loadLifeStoreVisitorData];
    [self loadSelectProductCenterData];
}

- (void)loadLifeStoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.loginManger.storeRid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSString *storeName = result.data[@"name"];
        self.desLabel.text = result.data[@"description"];
        self.storeAvatarUrl = result.data[@"logo"];
        [self.storeAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.storeAvatarUrl]];
        self.storeNameLabel.text = [NSString stringWithFormat:@"设计师%@的生活馆",storeName];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)loadLifeStoreVisitorData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.loginManger.storeRid;
    NSString *requestUrl = [NSString stringWithFormat:@"/store/%@/app_visitor",self.loginManger.storeRid];
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.userPartieArray = result.data[@"users"];
        NSInteger baroseCount = [result.data[@"count"]integerValue];
        
        if (baroseCount > 999) {
            self.browseMaxShowLabel.text = @"999+";
        } else {
            self.browseMaxShowLabel.text = [NSString stringWithFormat:@"%ld",baroseCount];
        }
        
        NSString *browseCountText = [NSString stringWithFormat:@"%ld 人浏览过生活馆",baroseCount];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:browseCountText];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(browseCountText.length - 6, 6)];
        self.browseCountLabel.attributedText = attributeStr;
        
        [self.avatarCollectionView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)loadSelectProductCenterData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"per_page"] = @3;
    THNRequest *request = [THNAPI getWithUrlString:kUrlSelectProductCenter requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.selectProductArray = result.data[@"products"];
        __weak typeof(self)weakSelf = self;
        
        [self.selectProductArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:obj];
            switch (idx) {
                case 0:
                    [weakSelf.outsideImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
                    break;
                case 1:
                    [weakSelf.middleImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
                default:
                    [weakSelf.insideImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
                    break;
            }
        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)edit:(id)sender {
    THNLivingHallMuseumView *hallMuseumView = [THNLivingHallMuseumView viewFromXib];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    hallMuseumView.frame = window.bounds;
    [window addSubview:hallMuseumView];
    
    __weak typeof(self)weakSelf = self;
    hallMuseumView.reloadLivingHallBlock = ^{
        [weakSelf loadLifeStoreData];
    };
}

- (IBAction)close:(id)sender {
    self.promptViewHeightConstraint.constant = 0;
    self.promptView.hidden = YES;
    [THNSaveTool setBool:YES forKey:kIsCloseLivingHallView];
    self.changeHeaderViewBlock();
}

- (IBAction)goSelection:(id)sender {
    self.pushProductCenterBlock();
}

- (IBAction)copyWechat:(id)sender {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger maxShowAvatarCount = (SCREEN_WIDTH -  94.5) / 24;
    
    if (self.userPartieArray.count > maxShowAvatarCount) {
        return maxShowAvatarCount;
    } else {
        return self.userPartieArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAvatarCellIdentifier forIndexPath:indexPath];
    THNUserPartieModel *model = [THNUserPartieModel mj_objectWithKeyValues:self.userPartieArray[indexPath.row]];
    [cell setUserPartieModel:model];
    return cell;
}

@end
