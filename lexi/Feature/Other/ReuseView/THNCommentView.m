//
//  THNCommentView.m
//  lexi
//
//  Created by rhp on 2018/11/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentView.h"
#import "UIView+Helper.h"
#import "THNGrassListModel.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"
#import "THNLoginManager.h"

static NSString *const kUrlLifeRecordsPraises = @"/life_records/praises";

@interface THNCommentView ()

@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *commentCountButton;
@property (weak, nonatomic) IBOutlet UIButton *praisesButton;


@end

@implementation THNCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fieldBackgroundView.layer.cornerRadius = self.fieldBackgroundView.viewHeight / 2;
}

- (void)layoutPraisesButton:(NSInteger)praiseCount initWithSelect:(BOOL)isSelect {
    if (isSelect) {
        [self.praisesButton setTitleColor:[UIColor colorWithHexString:@"FF6666"] forState:UIControlStateNormal];
    } else {
        [self.praisesButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }
    NSString *praisesBtnTitle = praiseCount == 0 ? @"赞" : [NSString stringWithFormat:@"%ld", praiseCount];
    [self.praisesButton setTitle:praisesBtnTitle forState:UIControlStateNormal];
}


- (void)setGrassListModel:(THNGrassListModel *)grassListModel {
    _grassListModel = grassListModel;
    self.praisesButton.selected = grassListModel.is_praise;
    NSString *commentCountBtnTitle = grassListModel.comment_count == 0 ? @"评论" : [NSString stringWithFormat:@"%ld",grassListModel.comment_count];
    [self.commentCountButton setTitle:commentCountBtnTitle forState:UIControlStateNormal];
    [self layoutPraisesButton:grassListModel.praise_count initWithSelect:grassListModel.is_praise];
}

- (IBAction)showKeyword:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(showKeyboard)]) {
        [self.delegate showKeyboard];
    }
}

- (IBAction)lookComment:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookComment)]) {
        [self.delegate lookComment];
    }
}

- (void)addPraises {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.grassListModel.rid);
    THNRequest *request = [THNAPI postWithUrlString:kUrlLifeRecordsPraises requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.grassListModel.is_praise = YES;
        self.praisesButton.selected = YES;
        self.grassListModel.praise_count += 1;
        [self layoutPraisesButton:self.grassListModel.praise_count initWithSelect:YES];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)deletePraises {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.grassListModel.rid);
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlLifeRecordsPraises requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.grassListModel.is_praise = NO;
        self.praisesButton.selected = NO;
        self.grassListModel.praise_count -= 1;
        [self layoutPraisesButton:self.grassListModel.praise_count initWithSelect:NO];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)awesome:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    if (self.praisesButton.selected) {
        [self deletePraises];
    } else {
        [self addPraises];
    }
}

@end
