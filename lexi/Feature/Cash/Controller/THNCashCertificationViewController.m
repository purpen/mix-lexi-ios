//
//  THNCashCertificationViewController.m
//  lexi
//
//  Created by FLYang on 2018/12/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashCertificationViewController.h"
#import "THNCashCertificationView.h"
#import "THNQiNiuUpload.h"
#import "THNPhotoManager.h"

static NSString *const kTitleCertification = @"实名认证";

@interface THNCashCertificationViewController () <THNCashCertificationViewDelegate>

@property (nonatomic, strong) THNCashCertificationView *certificationView;

@end

@implementation THNCashCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_cashCommitCertificationInfo:(NSDictionary *)info {
    [SVProgressHUD thn_showInfoWithStatus:@"提交的信息"];
}

- (void)thn_cashUploadFrontIDCardImage {
    [self openImageControllerOfFrontImage:YES];
}

- (void)thn_cashUploadBackIDCardImage {
    [self openImageControllerOfFrontImage:NO];
}

#pragma mark - private methods
- (void)openImageControllerOfFrontImage:(BOOL)isFront {
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [SVProgressHUD thn_show];
        
        if (isFront) {
            [self.certificationView thn_setFrontIDCardImageData:imageData];
            
        } else {
            [self.certificationView thn_setBackIDCardImageData:imageData];
        }
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData compltion:^(NSDictionary *result) {
            NSArray *idsArray = result[@"ids"];
            if (isFront) {
                NSLog(@"上传到七牛的正面图片id === %@", idsArray);
            } else {
                NSLog(@"上传到七牛的背面图片id === %@", idsArray);
            }
            
            [SVProgressHUD dismiss];
        }];
    }];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.certificationView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCertification;
    self.navigationBarView.bottomLine = YES;
}

#pragma mark - getters and setters
- (THNCashCertificationView *)certificationView {
    if (!_certificationView) {
        CGFloat originY = kDeviceiPhoneX ? 88 : 64;
        _certificationView = [[THNCashCertificationView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY)];
        _certificationView.delegate = self;
    }
    return _certificationView;
}

@end
