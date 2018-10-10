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
static NSInteger maxShowPhotoCount = 4;

@interface THNEvaluationTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>

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


@end

@implementation THNEvaluationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.evaluationView addSubview:self.textView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPhotoCellIdentifier];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - (maxShowPhotoCount - 1) * 20 - 15 * 2) / maxShowPhotoCount , 40);
    [self.collectionView setCollectionViewLayout:layout];
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

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    return cell;
}


#pragma mark - lazy
- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 30, 100)];
        _textView.placeholderText = @" 我们希望收到你的建议，优化我们的不足。长度在100字以内";
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"B2B2B2"];
    }
    return _textView;
}

@end
