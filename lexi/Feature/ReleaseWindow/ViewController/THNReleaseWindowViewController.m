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
#import "IQKeyboardManager.h"
#import "THNToolBarView.h"
#import "WBStatusHelper.h"
#import "WBEmoticonInputView.h"
#import "THNSelectWindowProductViewController.h"
#import "THNAddShowWindowViewController.h"

static NSString *const kUrlShopWindows = @"/shop_windows";

@interface THNReleaseWindowViewController () <
YYTextViewDelegate,
YYTextKeyboardObserver,
THNToolBarViewDelegate,
WBStatusComposeEmoticonViewDelegate,
UITextFieldDelegate,
THNNavigationBarViewDelegate
>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collageButtons;
@property (weak, nonatomic) IBOutlet UIView *postContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postContenViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *ImageViewStitchingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewStitchViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *keywordView;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) THNThreeImageStitchingView *threeImageStitchingView;
@property (nonatomic, strong) THNFiveImagesStitchView *fiveImagesStitchingView;
@property (nonatomic, strong) THNSevenImagesStitchView *sevenImagesStitchingView;
@property (nonatomic, strong) THNToolBarView *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
// 点击选择添加照片的位置
@property (nonatomic, assign) NSInteger selectIndex;
// 点击输入框类型
@property (nonatomic, assign) BOOL isClickTextField;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *keywords;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keywordViewHeightConstraint;
@property (nonatomic, strong) NSString *windowTitle;
@property (nonatomic, strong) NSString *windowContent;
@property (nonatomic, strong) NSMutableArray *productItems;

@end

@implementation THNReleaseWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [self.view addSubview:self.toolbar];
    self.titleTextField.delegate = self;
    self.toolbar.delegate = self;
    self.navigationBarView.title = @"发布橱窗";
    self.navigationBarView.rightButtonTrailing = -20;
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        [weakSelf releaseWindow];
    }];
    
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_release_green"];
    [self.addTagButton drawCornerWithType:0 radius:13];
    self.scrollViewBottomConstraint.constant = kDeviceiPhoneX ? 34 : 0;
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
        make.left.trailing.equalTo(self.postContentView).with.offset(-3);
        make.top.equalTo(self.postContentView).with.offset(30);
        make.height.equalTo(@(100));
    }];
    
    self.imageViewStitchViewHeightConstraint.constant = threeImageHeight;
    [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
    
    self.threeImageStitchingView.threeImageBlock = ^(NSInteger index) {
        weakSelf.selectIndex = index;
        [weakSelf pushSelectWindowProductVC];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 设置键盘距textView的间距
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.keyboardDistanceFromTextField = 50;
}

- (void)releaseWindow {
    [SVProgressHUD thn_show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"title"] = self.windowTitle;
    params[@"description"] = self.windowContent;
    params[@"product_items"] = self.productItems;
    params[@"keywords"] = self.keywords;
    THNRequest *request = [THNAPI postWithUrlString:kUrlShopWindows requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showInfoWithStatus:@"发布成功"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.toolbar.hidden = YES;
}

- (void)layoutInputView {
    WBEmoticonInputView *inputView = [WBEmoticonInputView sharedView];
    inputView.delegate = self;
    if (self.isClickTextField) {
        self.titleTextField.inputView = inputView;
        [self layoutTextField];
    } else {
        _textView.inputView = inputView;
        [self layoutTextView];
    }
}

- (void)layoutTextView {
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)layoutTextField {
    [self.titleTextField reloadInputViews];
    [self.titleTextField becomeFirstResponder];
}

- (void)pushSelectWindowProductVC {
    WEAKSELF;
    THNSelectWindowProductViewController *selectProductVC = [[THNSelectWindowProductViewController alloc]init];
    
    selectProductVC.selectWindowBlock = ^(NSString *cover, NSInteger coverID, NSString *productRid) {
        switch (self.imageType) {
            case ShopWindowImageTypeThree:
                [weakSelf.threeImageStitchingView setCLickImageView:cover withSelectIndex:weakSelf.selectIndex];
                break;
            case ShopWindowImageTypeFive:
                [weakSelf.fiveImagesStitchingView setCLickImageView:cover withSelectIndex:weakSelf.selectIndex];
                break;
            case ShopWindowImageTypeSeven:
                [weakSelf.sevenImagesStitchingView setCLickImageView:cover withSelectIndex:weakSelf.selectIndex];
                break;
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"rid"] = productRid;
        params[@"cover_id"] = @(coverID);
        [self.productItems addObject:params];
        
    };
    
    [weakSelf.navigationController pushViewController:selectProductVC animated:YES];
}

- (IBAction)collage:(UIButton *)button {
    WEAKSELF;
    
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
        case ShopWindowImageTypeFive:{
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = NO;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + fiveToGrowImageHeight;
            self.fiveImagesStitchingView.fiveImageBlock = ^(NSInteger index) {
                weakSelf.selectIndex = index;
                [weakSelf pushSelectWindowProductVC];
            };
            
            [self.ImageViewStitchingView addSubview:self.fiveImagesStitchingView];
            //            [self.fiveImagesStitchingView setFiveImageStitchingView:shopWindowModel.product_covers];
            break;
        }
        case ShopWindowImageTypeSeven:{
            self.sevenImagesStitchingView.hidden = NO;
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = YES;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + sevenToGrowImageHeight;
            
            self.sevenImagesStitchingView.sevenImageBlock = ^(NSInteger index) {
                weakSelf.selectIndex = index;
                [weakSelf pushSelectWindowProductVC];
            };
            
            [self.ImageViewStitchingView addSubview:self.sevenImagesStitchingView];
            //            [self.sevenImagesStitchingView setSevenImageStitchingView:shopWindowModel.product_covers];
            break;
        }
            
    }
}

- (IBAction)addTag:(id)sender {
    THNAddShowWindowViewController *addShowWindowVC = [[THNAddShowWindowViewController alloc]init];
    
    addShowWindowVC.addShowWindowBlock = ^(NSString *name) {
        [self.keywords addObject:name];
        [self createLabelWithArray:self.keywords FontSize:12 SpcX:5 SpcY:20];
        //        self.keywordViewHeightConstraint.constant =  shopWindowModel.keywords.count > 0 ? CGRectGetMaxY(self.keywordLabel.frame) : 0;
    };
    
    [self.navigationController pushViewController:addShowWindowVC animated:YES];
}

- (void)deleteKeyword:(UIButton *)button {
    [self.keywords removeObjectAtIndex:button.tag];
    [self createLabelWithArray:self.keywords FontSize:12 SpcX:5 SpcY:20];
}

//动态添加label方法
- (void)createLabelWithArray:(NSMutableArray *)titleArr FontSize:(CGFloat)fontSize SpcX:(CGFloat)spcX SpcY:(CGFloat)spcY
{
    // 清空子视图
    [self.keywordView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建标签位置变量
    CGFloat positionX = spcX;
    CGFloat positionY = spcY;
    
    //创建label
    for(int i = 0; i < titleArr.count; i++)
    {
        CGSize labelSize = [self getSizeByString:titleArr[i] AndFontSize:fontSize];
        CGFloat labelWidth = labelSize.width + 45;
        
        if (i == 0) {
            positionX = 0;
            positionY = 0;
        } else {
            if (positionX + labelWidth > SCREEN_WIDTH - 140) {
                positionX = 0;
                positionY += 35;
            }
        }
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(positionX, positionY, labelWidth, 24)];
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        backgroundView.layer.cornerRadius = backgroundView.viewHeight / 2;
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(backgroundView.viewWidth - 25, 5, 13, 13)];
        deleteButton.tag = i;
        [deleteButton setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteKeyword:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:deleteButton];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text = [NSString stringWithFormat:@"#%@",titleArr[i]];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.frame = CGRectMake(10, 5, labelWidth, labelSize.height);
        positionX += (labelWidth + 5);
        [backgroundView addSubview:label];
        self.backgroundView = backgroundView;
        [self.keywordView addSubview:backgroundView];
    }
    
    self.keywordViewHeightConstraint.constant =  titleArr.count > 0 ? CGRectGetMaxY(self.backgroundView.frame) : 0;
}

//获取字符串长度的方法
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.isClickTextField = NO;
    self.toolbar.hidden = NO;
    [self layoutTextView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.isClickTextField = YES;
    self.toolbar.hidden = NO;
    [self layoutTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.windowTitle = textField.text;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.windowContent = textView.text;
}


// 动态改变TextView的高度
- (void)textViewDidChange:(YYTextView *)textView {
    CGFloat fltTextHeight = textView.textLayout.textBoundingSize.height;
    textView.scrollEnabled = NO; //必须设置为NO
    
    [UIView performWithoutAnimation:^{
        textView.height = fltTextHeight;
        self.postContenViewHeightConstraint.constant = textView.height + 24;
    }];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - THNToolBarViewDelegate
- (void)changeKeyboardType:(UIButton *)button {
    BOOL isRemoveEmoticonInputView;
    if (self.isClickTextField) {
        isRemoveEmoticonInputView = self.titleTextField.inputView;
    } else {
        isRemoveEmoticonInputView = self.textView.inputView;
    }
    
    if (isRemoveEmoticonInputView) {
        if (self.isClickTextField) {
            self.titleTextField.inputView = nil;
            [self layoutTextField];
            
        } else {
            self.textView.inputView = nil;
            [self layoutTextView];
        }
        
        [button setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [button setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self layoutInputView];
        [button setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [button setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (void)addComment:(NSString *)text {
    [self.view endEditing:YES];
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        if (self.isClickTextField) {
            [self.titleTextField replaceRange:self.titleTextField.selectedTextRange withText:text];
        } else {
            [self.textView replaceRange:self.textView.selectedTextRange withText:text];
        }
        
    }
}

- (void)emoticonInputDidTapBackspace {
    if (self.isClickTextField) {
        [self.titleTextField deleteBackward];
    } else {
        [self.textView deleteBackward];
    }
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

- (THNToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [THNToolBarView viewFromXib];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.frame = CGRectMake(0, 1000, self.view.width, 50);
        _toolbar.isNoNeedAddTextView = YES;
    }
    return _toolbar;
}

- (NSMutableArray *)keywords {
    if (!_keywords) {
        _keywords = [NSMutableArray array];
    }
    return _keywords;
}

- (NSMutableArray *)productItems {
    if (!_productItems) {
        _productItems = [NSMutableArray array];
    }
    return _productItems;
}

@end
