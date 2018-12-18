//
//  THNNewUserInfoViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewUserInfoViewController.h"
#import "THNNewUserInfoView.h"
#import "THNPhotoManager.h"
#import "THNQiNiuUpload.h"
#import "THNLoginManager.h"
#import "THNAdvertManager.h"

static NSString *const kActionTakePhotoTitle    = @"拍照";
static NSString *const kActionAlbumTitle        = @"我的相册";
static NSString *const kActionCancelTitle       = @"取消";

/// 首次设置个人信息
static NSString *const kURLCompleteInfo         = @"/auth/complete_info";
static NSString *const kResultData              = @"data";
static NSString *const kResultDataIds           = @"ids";
static NSString *const kParamAvatarId           = @"avatar_id";

@interface THNNewUserInfoViewController () <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    THNNewUserInfoViewDelegate
>

/// 用户信息设置视图
@property (nonatomic, strong) THNNewUserInfoView *newUserInfoView;
/// 七牛服务端参数
@property (nonatomic, strong) NSDictionary *qiNiuParams;

@end

@implementation THNNewUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)networkPostUserCompleteInfoWithParam:(NSDictionary *)param {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI postWithUrlString:kURLCompleteInfo requestDictionary:param delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
        }
        
        [self thn_loginSuccessBack];
        [THNAdvertManager checkIsNewUserBonus];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 选择头像照片
 */
- (void)thn_getSelectImage {
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [self.newUserInfoView setHeaderImageWithData:imageData];
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                    compltion:^(NSDictionary *result) {
                                                        NSArray *idsArray = result[kResultDataIds];
                                                        [self.newUserInfoView setHeaderAvatarId:[idsArray[0] integerValue]];
                                                    }];
    }];
}

- (void)thn_loginSuccessBack {
    [[THNLoginManager sharedManager] getUserProfile:^(THNResponse *result, NSError *error) {
        if (error) {
            [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
            return ;
        }
        
        if (![result isSuccess]) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showSuccessWithStatus:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLivingHallStatus object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - custom delegate
- (void)thn_setUserInfoSelectHeader {
     [self thn_getSelectImage];
}

- (void)thn_setUserInfoEditDoneWithParam:(NSDictionary *)infoParam {
    [self networkPostUserCompleteInfoWithParam:infoParam];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.newUserInfoView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    [self.navigationBarView setNavigationBackButtonHidden:YES];
}

#pragma mark - getters and setters
- (THNNewUserInfoView *)newUserInfoView {
    if (!_newUserInfoView) {
        _newUserInfoView = [[THNNewUserInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _newUserInfoView.delegate = self;
    }
    return _newUserInfoView;
}

- (NSDictionary *)qiNiuParams {
    if (!_qiNiuParams) {
        _qiNiuParams = [NSDictionary dictionary];
    }
    return _qiNiuParams;
}

@end
