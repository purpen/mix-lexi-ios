//
//  THNShelfViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShelfViewController.h"
#import <YYKit/YYTextView.h>
#import "UIColor+Extension.h"
#import "THNCenterProductTableViewCell.h"
#import "UIView+Helper.h"
#import "THNProductModel.h"
#import "THNSaveTool.h"
#import "THNLoginManager.h"

static NSString *const kUrlPublishProduct = @"/core_platforms/fx_distribute/publish";

@interface THNShelfViewController () <YYTextViewDelegate>

@property (nonatomic, strong) UIView *recommendTintView;
@property (nonatomic, strong) THNCenterProductTableViewCell *centerProductCell;
@property (nonatomic, strong) UIButton *shelfButton;
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation THNShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

// 确认上架
-  (void)sureShelf {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"stick_text"] = self.textView.text;
    params[@"rid"] = self.productModel.rid;
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI postWithUrlString:kUrlPublishProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"上架成功"];
        
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
//            self.shelfPopBlock();
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shelfSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}


- (void)setupUI {   
    [self.view addSubview:self.recommendTintView];
    [self.view addSubview:self.centerProductCell];
    [self.view addSubview:self.shelfButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
}

#pragma mark - YYTextViewDelegate

// 点击Return 隐藏键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]){

        [textView resignFirstResponder];

        return NO;

    }

    return YES;
}


- (UIView *)recommendTintView {
    if (!_recommendTintView) {
        _recommendTintView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 240)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 60, 20)];
        label.text = @"推荐语";
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 20 , SCREEN_WIDTH - 55, 240 - CGRectGetMaxY(label.frame) + 20)];
        textView.placeholderText = @"一个出色的推荐语，除了精简的描述商品的优势亮点外应对消费者具有吸引点，促进销售140字以内";
        textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        textView.placeholderTextColor = [UIColor colorWithHexString:@"B2B2B2"];
        self.textView = textView;
        _recommendTintView.backgroundColor = [UIColor whiteColor];
        [_recommendTintView addSubview:label];
        [_recommendTintView addSubview:textView];
    }
    return _recommendTintView;
}

- (THNCenterProductTableViewCell *)centerProductCell {
    if (!_centerProductCell) {
        _centerProductCell = [THNCenterProductTableViewCell viewFromXib];
        [_centerProductCell setProductModel:self.productModel];
        _centerProductCell.buttonView.hidden = YES;
        _centerProductCell.frame = CGRectMake(0, CGRectGetMaxY(self.recommendTintView.frame) + 10, SCREEN_WIDTH, 129);
        _centerProductCell.backgroundColor = [UIColor whiteColor];
    }
    return _centerProductCell;
}

- (UIButton *)shelfButton {
    if (!_shelfButton) {
        _shelfButton = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.centerProductCell.frame) + 30, SCREEN_WIDTH - 40, 40)];
        _shelfButton.layer.cornerRadius = 4;
        _shelfButton.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        [_shelfButton setTitle:@"确认上架" forState:UIControlStateNormal];
        [_shelfButton addTarget:self action:@selector(sureShelf) forControlEvents:UIControlEventTouchUpInside];
        [_shelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _shelfButton;
}


@end
