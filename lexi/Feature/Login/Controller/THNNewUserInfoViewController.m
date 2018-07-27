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
/// 获取七牛token
static NSString *const kURLUpToken              = @"/assets/user_upload_token";
/// 首次设置个人信息
static NSString *const kURLCompleteInfo         = @"/auth/complete_info";
static NSString *const kResultData              = @"data";

@interface THNNewUserInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, THNNewUserInfoViewDelegate>

/// 用户信息设置视图
@property (nonatomic, strong) THNNewUserInfoView *newUserInfoView;
/// 七牛服务端参数
@property (nonatomic, strong) NSDictionary *qiNiuParams;

@end

@implementation THNNewUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self networkGetQiNiuUploadToken];
}

#pragma mark - network
- (void)networkGetQiNiuUploadToken {
    THNRequest *request = [THNAPI getWithUrlString:kURLUpToken
                                 requestDictionary:nil
                                            isSign:YES
                                          delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        self.qiNiuParams = NULL_TO_NIL(result[kResultData]);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)networkPostUserCompleteInfoWithParam:(NSDictionary *)param {
    NSLog(@"用户信息：%@", param);
    THNRequest *request = [THNAPI postWithUrlString:kURLCompleteInfo
                                  requestDictionary:param
                                             isSign:YES
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSLog(@"设置个人信息成功：%@", result);
        
        if ([result[@"success"] isEqualToNumber:@1]) {
            [self dismissViewControllerAnimated:YES completion:nil];
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
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(UIImage *image) {
        [SVProgressHUD showWithStatus:@"正在上传"];
        [THNQiNiuUpload uploadQiNiuWithParams:self.qiNiuParams image:image compltion:^(NSDictionary *result) {
            NSArray *dataArray = result[@"ids"];
            [weakSelf.newUserInfoView setHeaderImage:image withIdx:[dataArray[0] integerValue]];
            [SVProgressHUD dismiss];
        }];
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
