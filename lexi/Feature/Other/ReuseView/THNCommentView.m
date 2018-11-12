//
//  THNCommentView.m
//  lexi
//
//  Created by rhp on 2018/11/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentView.h"
#import "UIView+Helper.h"

@interface THNCommentView ()

@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;


@end

@implementation THNCommentView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fieldBackgroundView.layer.cornerRadius = self.fieldBackgroundView.viewHeight / 2;
}

- (IBAction)showKeyword:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showKeyboard)]) {
        [self.delegate showKeyboard];
    }
}

- (IBAction)lookComment:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookComment)]) {
        [self.delegate lookComment];
    }
}

@end
