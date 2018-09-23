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
- (void)networkPostUserCompleteInfoWithParam:(NSDictionary *)param completion:(void (^)(void))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLCompleteInfo requestDictionary:param delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result isSuccess]) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
        }
        
        if (completion) {
            completion();
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 选择头像照片
 */
- (void)thn_getSelectImage {
    WEAKSELF;
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [weakSelf.newUserInfoView setHeaderImageWithData:imageData];
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                    compltion:^(NSDictionary *result) {
                                                        NSArray *idsArray = result[kResultDataIds];
                                                        [weakSelf.newUserInfoView setHeaderAvatarId:[idsArray[0] integerValue]];
                                                    }];
    }];
}

#pragma mark - custom delegate
- (void)thn_setUserInfoSelectHeader {
     [self thn_getSelectImage];
}

- (void)thn_setUserInfoEditDoneWithParam:(NSDictionary *)infoParam {
    [self networkPostUserCompleteInfoWithParam:infoParam completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
        _newUserInfoView = [[THNNewUserInfoView alloc] init];
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
