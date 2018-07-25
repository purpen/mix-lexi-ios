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

static NSString *const kActionTakePhotoTitle    = @"拍照";
static NSString *const kActionAlbumTitle        = @"我的相册";
static NSString *const kActionCancelTitle       = @"取消";
static NSString *const kURLUpToken              = @"/assets/up_token";

@interface THNNewUserInfoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// 用户信息设置视图
@property (nonatomic, strong) THNNewUserInfoView *newUserInfoView;

@end

@implementation THNNewUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self networkGetQiNiuUploadToken];
}

#pragma mark - network
- (void)networkGetQiNiuUploadToken {
    THNRequest *request = [THNAPI getWithUrlString:kURLUpToken requestDictionary:nil isSign:NO delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, id result) {
        NSLog(@"=== %@", result);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
/**
 功能选择表
 */
- (void)thn_popupAlertControllerActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:kActionTakePhotoTitle
                                                              style:(UIAlertActionStyleDefault)
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                            }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:kActionAlbumTitle
                                                          style:(UIAlertActionStyleDefault)
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kActionCancelTitle
                                                           style:(UIAlertActionStyleCancel)
                                                         handler:nil];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)thn_getSelectImage {
    WEAKSELF;
    
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(UIImage *image) {
        [weakSelf.newUserInfoView setHeaderImage:image];
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

/**
 设置导航栏
 */
- (void)setNavigationBar {
    self.navigationBarView.hidden = YES;
}

#pragma mark - getters and setters
- (THNNewUserInfoView *)newUserInfoView {
    if (!_newUserInfoView) {
        _newUserInfoView = [[THNNewUserInfoView alloc] init];
        
        WEAKSELF;
        
        _newUserInfoView.NewUserInfoEditDoneBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        _newUserInfoView.NewUserInfoSelectHeaderBlock = ^{
            [weakSelf thn_getSelectImage];
        };
    }
    return _newUserInfoView;
}

@end
