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
    textView.returnKeyType = UIReturnKeyDone;
}

- (void)editStore {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = [THNLoginManager sharedManager].storeRid;
    params[@"name"] = self.nameTextView.text;
    params[@"description"] =  self.introductionTextView.text;
    THNRequest *request = [THNAPI postWithUrlString:kUrlEditStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }
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
    if (textView.viewHeight == 44) {
        [self layoutTextView:textView initShowLenthLabel:self.nameCountLabel initWithMaxLenth:16];
    } else {
        [self layoutTextView:textView initShowLenthLabel:self.introductionCountLabel initWithMaxLenth:40];
    }
}

- (void)layoutTextView:(UITextView *)textView initShowLenthLabel:(UILabel *)label initWithMaxLenth:(NSInteger)lenth {
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) { // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            label.text = [NSString stringWithFormat:@"%ld",textView.text.length];
            if (toBeString.length > lenth) {
                textView.text = [toBeString substringToIndex:lenth];
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多输入%ld个字符",lenth]];
                label.text = [NSString stringWithFormat:@"%ld",lenth];
            }
        }
    } else {
        if (toBeString.length > lenth) {
            textView.text = [toBeString substringToIndex:lenth];
        }
    }
}

// 点击Return 隐藏键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
}


@end
