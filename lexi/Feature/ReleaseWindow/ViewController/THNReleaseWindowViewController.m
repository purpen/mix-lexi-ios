//
//  THNReleaseWindowViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/11/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNReleaseWindowViewController.h"
#import "UIView+Helper.h"
#import <YYKit/YYTextView.h>
#import <Masonry/Masonry.h>
#import "THNShopWindowTableViewCell.h"
#import "THNThreeImageStitchingView.h"
#import "THNFiveImagesStitchView.h"
#import "THNSevenImagesStitchView.h"

@interface THNReleaseWindowViewController () <YYTextViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collageButtons;
@property (weak, nonatomic) IBOutlet UIView *postContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postContenViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *ImageViewStitchingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewStitchViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *keywordView;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightConstraint;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) THNThreeImageStitchingView *threeImageStitchingView;
@property (nonatomic, strong) THNFiveImagesStitchView *fiveImagesStitchingView;
@property (nonatomic, strong) THNSevenImagesStitchView *sevenImagesStitchingView;

@end

@implementation THNReleaseWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.title = @"发布橱窗";
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share"];
    [self.addTagButton drawCornerWithType:0 radius:13];
    self.scrollViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    self.scrollViewContentHeightConstraint.constant = SCREEN_HEIGHT;
    
    [self.collageButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn drawCornerWithType:0 radius:4];
        if (idx == 0) {
            btn.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            btn.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
            [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        }
    }];
    
    [self.postContentView addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.trailing.equalTo(self.postContentView);
        make.top.equalTo(self.postContentView).with.offset(40);
        make.height.equalTo(@(100));
    }];
    self.imageViewStitchViewHeightConstraint.constant = threeImageHeight;
    [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [self.view addGestureRecognizer:tableViewGesture];
}

- (void)tableViewTouchInSide{
    // ------结束编辑，隐藏键盘
    [self.view endEditing:YES];
}

- (IBAction)collage:(UIButton *)button {
    for (UIButton *btn in self.collageButtons) {
        btn.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    
    
    self.imageType = [self.collageButtons indexOfObject:button];
    button.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    switch (self.imageType) {
        case ShopWindowImageTypeThree:
            self.fiveImagesStitchingView.hidden = YES;
            self.sevenImagesStitchingView.hidden = YES;
            self.threeImageStitchingView.hidden = NO;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight;
//            [self.threeImageStitchingView setThreeImageStitchingView:shopWindowModel.product_covers];
            [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
            break;
        case ShopWindowImageTypeFive:
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = NO;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + fiveToGrowImageHeight;
            [self.ImageViewStitchingView addSubview:self.fiveImagesStitchingView];
//            [self.fiveImagesStitchingView setFiveImageStitchingView:shopWindowModel.product_covers];
            break;
        case ShopWindowImageTypeSeven:
            self.sevenImagesStitchingView.hidden = NO;
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = YES;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + sevenToGrowImageHeight;
            [self.ImageViewStitchingView addSubview:self.sevenImagesStitchingView];
//            [self.sevenImagesStitchingView setSevenImageStitchingView:shopWindowModel.product_covers];
            break;
    }
}

- (IBAction)addTag:(id)sender {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(YYTextView *)textView {
    CGFloat fltTextHeight = textView.textLayout.textBoundingSize.height;
    textView.scrollEnabled = NO; //必须设置为NO
    
    [UIView performWithoutAnimation:^{
        textView.height = fltTextHeight;
        self.postContenViewHeightConstraint.constant = textView.height + 56;
        self.scrollViewContentHeightConstraint.constant = SCREEN_HEIGHT + textView.height;
    }];
}

#pragma mark - lazy

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.textColor = [UIColor colorWithHexString:@"333333"];
        _textView.placeholderText = @"每个人都是生活美学家，分享你的搭配灵感与故事";
        _textView.delegate = self;
    }
    return _textView;
}

#pragma mark - lazy
- (THNThreeImageStitchingView *)threeImageStitchingView {
    if (!_threeImageStitchingView) {
        _threeImageStitchingView = [THNThreeImageStitchingView viewFromXib];
        _threeImageStitchingView.frame = self.ImageViewStitchingView.bounds;
        _threeImageStitchingView.isContentModeCenter = YES;
        
    }
    return _threeImageStitchingView;
}

- (THNFiveImagesStitchView *)fiveImagesStitchingView {
    if (!_fiveImagesStitchingView) {
        _fiveImagesStitchingView = [THNFiveImagesStitchView viewFromXib];
        _fiveImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
        _fiveImagesStitchingView.isContentModeCenter = YES;
    }
    return _fiveImagesStitchingView;
}

- (THNSevenImagesStitchView *)sevenImagesStitchingView {
    if (!_sevenImagesStitchingView) {
        _sevenImagesStitchingView = [THNSevenImagesStitchView viewFromXib];
        _sevenImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
        _sevenImagesStitchingView.isContentModeCenter = YES;
    }
    return _sevenImagesStitchingView;
}

@end
