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
#import "UIImageView+WebImage.h"
#import "THNLoginManager.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNUserPartieModel.h"
#import "UIColor+Extension.h"
#import "THNProductModel.h"
#import "THNLivingHallMuseumView.h"
#import "THNSaveTool.h"
#import "THNConst.h"
#import "THNLifeStoreModel.h"
#import "SVProgressHUD+Helper.h"

static NSString *const kAvatarCellIdentifier = @"kAvatarCellIdentifier";
// 商家生活馆的信息
static NSString *const kUrlLifeStore = @"/store/life_store";
// 选品中心
static NSString *const kUrlSelectProductCenter = @"/core_platforms/fx_distribute/latest";
// 编辑生活馆头像
static NSString *const kUrlEditLifeStoreLogo = @"/store/update_life_store_logo";

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionTitleConstraint;
@property (nonatomic, strong) THNLoginManager *loginManger;
@property (nonatomic, strong) NSArray *userPartieArray;
@property (nonatomic, strong) NSArray *selectProductArray;
@property (nonatomic, strong) NSArray *selectProductNewArray;
@property (weak, nonatomic) IBOutlet UIImageView *livingHallStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *promptTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptSecondContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *promptWechatButton;
@property (nonatomic, strong) THNLifeStoreModel *storeModel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation THNLivingHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 添加阴影
    [self.livingHallView drawShadow:1.0];
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
    
    // 适配5S的样式
    if (SCREEN_WIDTH == 320) {
        for (UILabel *label in self.tintLabels) {
            label.font = [UIFont systemFontOfSize:9];
        }
        self.selectionTitleConstraint.constant = 3;
    }
}

- (void)setLifeStore {
    THNLoginManager *loginManger = [THNLoginManager sharedManager];
    self.loginManger = loginManger;
    
    if (self.loginManger.storeRid.length == 0) {
        return;
    }
    
    [self loadLifeStoreVisitorData];
    [self loadSelectProductCenterData];
}

- (void)loadLifeStoreData:(LoadLifeStoreDataSuccessBlock)lifeStoreDataSuccess {
    
    if (self.loginManger.storeRid.length == 0) {
        if (lifeStoreDataSuccess) {
            lifeStoreDataSuccess(NO);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.loginManger.storeRid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        THNLifeStoreModel *storeModel = [THNLifeStoreModel mj_objectWithKeyValues:result.data];
        self.storeModel = storeModel;
        NSString *storeName = storeModel.name;
        self.storeAvatarUrl = storeModel.logo;
        self.desLabel.text = storeModel.des;
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:storeModel.bgcover]];
        [self.storeAvatarImageView loadImageWithUrl:[storeModel.logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
        self.storeNameLabel.text = storeName;
        // 生活馆阶段: 1、实习馆主  2、达人馆主
        if (storeModel.phases == 1) {
            if ([THNSaveTool objectForKey:kIsCloseLivingHallView]) {
                self.promptViewHeightConstraint.constant = 0;
                self.promptView.hidden = YES;
            } else {
                if ([THNSaveTool objectForKey:kIsCloseOpenedPromptView]) {
                    [self layoutPracticePromptView:self.storeModel];
                } else {
                    [self layoutOpenedPromptView];
                }
            }
        } else {
            [THNSaveTool setBool:YES forKey:kIsCloseLivingHallView];
            if (self.changeHeaderViewBlock) {
               self.changeHeaderViewBlock();
            }
            self.promptViewHeightConstraint.constant = 0;
            self.promptView.hidden = YES;
        }
        
        self.noProductView.hidden = storeModel.has_product ?: NO;
        
        if (lifeStoreDataSuccess) {
            lifeStoreDataSuccess(storeModel.has_product);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
        if (lifeStoreDataSuccess) {
            lifeStoreDataSuccess(NO);
        }
        
    }];
}

- (IBAction)share:(id)sender {
    if (self.livingHallShareBlock) {
        self.livingHallShareBlock();
    }
}

// 实习状态生活馆提示样式
- (void)layoutPracticePromptView:(THNLifeStoreModel *)storeModel {
    self.promptView.hidden = NO;
    self.promptTitleLabel.text = @"当前为实习馆主";
    self.promptContentLabel.text = storeModel.phases_description;
    self.promptSecondContentLabel.hidden = YES;
    self.promptWechatButton.hidden = YES;
    self.promptTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.promptTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.promptContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.livingHallStatusImageView.image = [UIImage imageNamed:@"icon_livingHall_practice"];
}

// 开馆提示状态
- (void)layoutOpenedPromptView {
    self.promptView.hidden = NO;
    self.promptTitleLabel.text = @"恭喜你拥有了生活馆";
    self.promptSecondContentLabel.hidden = NO;
    self.promptSecondContentLabel.text = @"添加乐喜辅导员微信，加入生活馆店主群。";
    self.promptContentLabel.text = @"如何快速成交订单获取攻略，请搜索关注乐喜官网公众号";
    self.promptWechatButton.hidden = NO;
    self.promptTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.promptTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.promptContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.livingHallStatusImageView.image = [UIImage imageNamed:@"icon_selected_main"];
}

// 生活馆头像
- (void)loadLifeStoreVisitorData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.loginManger.storeRid;
    NSString *requestUrl = [NSString stringWithFormat:@"/store/%@/app_visitor",self.loginManger.storeRid];
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showWithStatus:result.statusMessage];
            return;
        }
        
        self.userPartieArray = result.data[@"users"];
        NSInteger baroseCount = [result.data[@"browse_number"] integerValue];
        NSInteger count = [result.data[@"count"] integerValue];
        
        if (count > 999) {
            self.browseMaxShowLabel.text = @"999+";
        } else {
            self.browseMaxShowLabel.text = [NSString stringWithFormat:@"%ld",count];
        }
        
        NSString *browseCountText = [NSString stringWithFormat:@"生活馆被浏览过%ld次",baroseCount];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:browseCountText];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, 7)];
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
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showWithStatus:result.statusMessage];
            return;
        }
        
        self.selectProductArray = result.data[@"products"];
        __weak typeof(self)weakSelf = self;
        
        [self.selectProductArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:obj];
            switch (idx) {
                case 0:
                    [weakSelf.outsideImageView loadImageWithUrl:[productModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
                    break;
                case 1:
                    [weakSelf.middleImageView loadImageWithUrl:[productModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
                    break;
                default:
                    [weakSelf.insideImageView loadImageWithUrl:[productModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
                    break;
            }
        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - public methods
- (void)setHeaderImageWithData:(NSData *)imageData {
    self.storeAvatarImageView.image = [UIImage imageWithData:imageData];
    self.storeAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
}

// 编辑生活馆头像
- (void)setHeaderAvatarId:(NSInteger)idx {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"logo_id"] = @(idx);
    params[@"rid"] = self.loginManger.storeRid;
    THNRequest *request = [THNAPI putWithUrlString:kUrlEditLifeStoreLogo requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)edit:(id)sender {
    THNLivingHallMuseumView *hallMuseumView = [THNLivingHallMuseumView viewFromXib];
    [hallMuseumView setLivingHallMuseumViewWithTitle:self.storeNameLabel.text withContent:self.desLabel.text];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    hallMuseumView.frame = window.bounds;
    [window addSubview:hallMuseumView];
    
    __weak typeof(self)weakSelf = self;
    hallMuseumView.reloadLivingHallBlock = ^{
        [weakSelf loadLifeStoreData:nil];
    };
}

- (IBAction)close:(id)sender {
    if ([THNSaveTool objectForKey:kIsCloseOpenedPromptView]) {
        self.promptViewHeightConstraint.constant = 0;
        self.promptView.hidden = YES;
        [THNSaveTool setBool:YES forKey:kIsCloseLivingHallView];
        self.changeHeaderViewBlock();
    } else {
        [self layoutPracticePromptView:self.storeModel];
        [THNSaveTool setBool:YES forKey:kIsCloseOpenedPromptView];
    }
}

- (IBAction)goSelection:(id)sender {
    self.pushProductCenterBlock();
}

- (IBAction)copyWechat:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"737373"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:@"lexixiaoduo"];
    if (pab == nil) {
        [SVProgressHUD thn_showInfoWithStatus:@"复制失败"];
        
    } else {
        [SVProgressHUD thn_showSuccessWithStatus:@"复制成功,去微信搜索添加"];
    }

    [SVProgressHUD dismissWithDelay:2.0 completion:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    }];
}

- (IBAction)editAvatar:(id)sender {
    if (self.storeLogoBlock) {
        self.storeLogoBlock();
    }
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
