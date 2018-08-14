//
//  THNLivingHallMuseumView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallMuseumView.h"
#import "UIView+Helper.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import "THNLoginManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *const kUrlEditStore = @"/store/edit_store";

@interface THNLivingHallMuseumView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *nameCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation THNLivingHallMuseumView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.saveButton drawCornerWithType:0 radius:4];
    [self.backGroundView drawCornerWithType:0 radius:4];
    [self layotuTextViewStyle:self.introductionTextView];
    [self layotuTextViewStyle:self.nameTextView];
    self.nameTextView.delegate = self;
    self.introductionTextView.delegate = self;
    self.nameTextView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)layotuTextViewStyle:(UITextView *)textView {
    textView.layer.cornerRadius = 4;
    textView.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.alpha = 1;
}

- (void)editStore {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = [THNLoginManager sharedManager].storeRid;
    params[@"name"] = self.nameTextView.text;
    params[@"description"] =  self.introductionTextView.text;
    THNRequest *request = [THNAPI postWithUrlString:kUrlEditStore requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
         self.reloadLivingHallBlock();
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)save:(id)sender {
    [self editStore];
    [self removeFromSuperview];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isKindOfClass:self.nameTextView.class]) {
        if (textView.text.length > 16) {
            textView.editable = NO;
            [SVProgressHUD showInfoWithStatus:@"不得超过16字"];
        }
    } else {
        if (textView.text.length > 40) {
            textView.editable = NO;
            [SVProgressHUD showInfoWithStatus:@"不得超过40字"];
        }
    }
    
}

@end
