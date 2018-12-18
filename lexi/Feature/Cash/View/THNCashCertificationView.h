//
//  THNCashCertificationView.h
//  lexi
//
//  Created by FLYang on 2018/12/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCashCertificationViewDelegate <NSObject>

// 提交身份信息
- (void)thn_cashCommitCertificationInfo:(NSDictionary *)info;
// 上传身份证图片
- (void)thn_cashUploadFrontIDCardImage;
- (void)thn_cashUploadBackIDCardImage;

@end

@interface THNCashCertificationView : UIView

@property (nonatomic, weak) id <THNCashCertificationViewDelegate> delegate;

- (void)thn_setFrontIDCardImageData:(NSData *)imageData;
- (void)thn_setBackIDCardImageData:(NSData *)imageData;

@end

