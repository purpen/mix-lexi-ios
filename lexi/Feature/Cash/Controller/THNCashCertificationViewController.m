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
#import "THNCertificationStatusViewController.h"

static NSString *const kTitleCertification = @"实名认证";

static NSString *const kURLIdCard = @"/users/cash_id_card";

@interface THNCashCertificationViewController () <THNCashCertificationViewDelegate>

@property (nonatomic, strong) THNCashCertificationView *certificationView;
@property (nonatomic, strong) NSString *idCardFront;
@property (nonatomic, strong) NSString *idCardBack;

@end

@implementation THNCashCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - network
- (void)requestCommitIDCardWithParams:(NSDictionary *)params {
    THNRequest *request = [THNAPI postWithUrlString:kURLIdCard requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self thn_openStatusController];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - custom delegate
- (void)thn_cashCommitCertificationInfo:(NSDictionary *)info {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:info];
    [params setObject:self.idCardFront forKey:@"id_card_front"];
    [params setObject:self.idCardBack forKey:@"id_card_back"];
    
    [self requestCommitIDCardWithParams:params];
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
                self.idCardFront = idsArray[0];
            } else {
                NSLog(@"上传到七牛的背面图片id === %@", idsArray);
                self.idCardBack = idsArray[0];
            }
            
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)thn_openStatusController {
    THNCertificationStatusViewController *statusVC = [[THNCertificationStatusViewController alloc] init];
    [self.navigationController pushViewController:statusVC animated:YES];
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
