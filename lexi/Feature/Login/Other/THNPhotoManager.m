//
//  THNPhotoManager.m
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "THNMarco.h"
#import "UIImage+Helper.h"

static NSString *const kActionTakePhotoTitle    = @"拍照";
static NSString *const kActionAlbumTitle        = @"我的相册";
static NSString *const kActionCancelTitle       = @"取消";
static NSString *const kActionDoneTitle         = @"确认";

@interface THNPhotoManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, copy) void (^SelectImageBlock)(NSData *imageData);

@end

@implementation THNPhotoManager

#pragma mark - public methods

- (void)getPhotoOfAlbumOrCameraWithController:(UIViewController *)controller completion:(void (^)(NSData *))completion {
    self.viewController = controller;
    self.SelectImageBlock = completion;
    
    [self thn_popupAlertControllerActionSheet];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];

    if (!editedImage) {
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.SelectImageBlock) {
            self.SelectImageBlock([UIImage compressImageToData:editedImage]);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
- (void)thn_presentPickerViewController {
    self.imagePicker.sourceType = self.sourceType;
    [self.viewController presentViewController:self.imagePicker animated:YES completion:nil];
}

/**
 弹出操作表单
 */
- (void)thn_popupAlertControllerActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:kActionTakePhotoTitle
                                                              style:(UIAlertActionStyleDefault)
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self thn_getAlertActionType:(UIImagePickerControllerSourceTypeCamera)];
                                                            }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:kActionAlbumTitle
                                                          style:(UIAlertActionStyleDefault)
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self thn_getAlertActionType:(UIImagePickerControllerSourceTypePhotoLibrary)];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kActionCancelTitle
                                                           style:(UIAlertActionStyleCancel)
                                                         handler:nil];
    
    [self thn_isSourceTypeAvailableToCamera] ? [alertController addAction:takePhotoAction] : nil;
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 是否支持拍照
 */
- (BOOL)thn_isSourceTypeAvailableToCamera {
    return [UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)];
}

/**
 获取操作的类型
 */
- (void)thn_getAlertActionType:(UIImagePickerControllerSourceType)type {
    [self thn_getImagePickerSourceType:type];
}

/**
 获取多媒体的类型
 */
- (void)thn_getImagePickerSourceType:(UIImagePickerControllerSourceType)type {
    self.sourceType = type;
    
    NSInteger grantedStatus = [self thn_getAvAuthorizationIsGrantedStatus];
    if (grantedStatus == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"请到设置-隐私-相机/相册中打开授权设置"
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:kActionDoneTitle
                                                             style:(UIAlertActionStyleDefault)
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self thn_openSystemSetup];
                                                           }];
        
        [alertController addAction:doneAction];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        
    } else if (grantedStatus == 1) {
        [self thn_presentPickerViewController];
    }
}

/**
 打开系统设置
 */
- (void)thn_openSystemSetup {
    NSURL *setupUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:setupUrl]) {
        [[UIApplication sharedApplication] openURL:setupUrl];
    }
}

/**
 获取授权状态
 */
- (NSInteger)thn_getAvAuthorizationIsGrantedStatus  {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];
    NSInteger authStatus = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? authStatusAlbm : authStatusVedio;
    
    switch (authStatus) {
        case 0: {
            if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self thn_presentPickerViewController];
                    }
                }];
                
            } else {
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self thn_presentPickerViewController];
                    }
                }];
            }
        }
            // 不提示
            return 2;
            
        case 1:
            // 还未授权
            return 0;
            
        case 2:
            // 主动拒绝授权
            return 0;
            
        case 3:
            // 已授权
            return 1;
    }
    
    return 0;
}

#pragma mark - getters and setters
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = self.sourceType;
    }
    return _imagePicker;
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
