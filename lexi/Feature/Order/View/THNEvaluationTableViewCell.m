//
//  THNEvaluationTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNEvaluationTableViewCell.h"
#import <YYKit/YYKit.h>
#import "THNMarco.h"
#import <MJExtension/MJExtension.h>
#import "THNOrdersItemsModel.h"
#import "UIImageView+WebCache.h"
#import "THNTextTool.h"
#import "THNPhotoCollectionViewCell.h"

static NSString *const kPhotoCellIdentifier = @"kPhotoCellIdentifier";
// 每行最多展示图片数量
static NSInteger maxShowPhotoLineCount = 4;
// 总共最多展示图片数量
static NSInteger maxShowPhotoCount = 9;

@interface THNEvaluationTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *startButtons;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageMutableArray;

@end

@implementation THNEvaluationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.evaluationView addSubview:self.textView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPhotoCellIdentifier];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 * 2) / maxShowPhotoLineCount , (SCREEN_WIDTH - 15 * 2) / maxShowPhotoLineCount);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setItemsModel:(THNOrdersItemsModel *)itemsModel {
    _itemsModel = itemsModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:itemsModel.cover]];
    self.productNameLabel.text = itemsModel.product_name;

    if (itemsModel.sale_price == 0) {
        self.saleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",itemsModel.price];
        self.originalMoneyLabel.hidden = YES;
    } else {
        self.originalMoneyLabel.hidden = NO;
        self.saleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",itemsModel.sale_price];
        self.originalMoneyLabel.attributedText = [THNTextTool setStrikethrough:itemsModel.price];
    }

    self.modeLabel.text = itemsModel.mode;
    self.storeNameLabel.text = itemsModel.store_name;
}

- (IBAction)didClickMark:(id)sender {
    NSInteger index = [self.startButtons indexOfObject:sender];

    for (UIButton *btn in self.startButtons) {
        btn.selected = NO;
    }

    for (NSInteger i = 0; i <= index; i++) {

        UIButton *enableButton = self.startButtons[i];

        enableButton.selected = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentStart:initWithTag:)]) {
        [self.delegate commentStart:index + 1 initWithTag:self.tag];
    }

}

- (void)reloadPhoto:(NSMutableArray *)imageMutableArray {
    self.imageMutableArray = imageMutableArray;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageMutableArray.count == maxShowPhotoCount ? maxShowPhotoCount : self.imageMutableArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    THNPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    WEAKSELF
    
    cell.photoBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectPhoto:)]) {
            [weakSelf.delegate selectPhoto:weakSelf.tag];
        }
    };
    
    cell.deletePhotoBlock = ^(NSInteger tag) {
        [weakSelf.imageMutableArray removeObjectAtIndex:tag];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteProductTag:initWithPhotoTag:)]) {
            [weakSelf.delegate deleteProductTag:self.tag initWithPhotoTag:tag];
        }
        [weakSelf.collectionView reloadData];
        
    };
    
    if (indexPath.row == self.imageMutableArray.count && self.imageMutableArray.count != maxShowPhotoCount) {
        [cell.photoButton setImage:[UIImage imageNamed:@"icon_add_photo"] forState:UIControlStateNormal];
        cell.deleteButton.hidden = YES;
        cell.photoButton.enabled = YES;
    } else {
        cell.deleteButton.hidden = NO;
        [cell setImageData:self.imageMutableArray[indexPath.row]];
    }
    
    return cell;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comment:initWithTag:)]) {
        [self.delegate comment:textView.text initWithTag:self.tag];
    }
}


#pragma mark - lazy
- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 30, 100)];
        _textView.placeholderText = @"我们希望收到你的建议，优化我们的不足。长度在100字以内";
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"B2B2B2"];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

@end
