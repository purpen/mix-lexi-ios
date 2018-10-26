//
//  THNNewShippingAddressTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYTextView.h>

@class THNAddressModel;

typedef NS_ENUM(NSUInteger, AddressSelectType) {
    AddressSelectTypeDefault,
    AddressSelectTypeImageView,
    AddressSelectTypeButtonWithImageView
};

@interface THNNewShippingAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *placeholderText;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) YYTextView *areaCodeTextView;

@property (nonatomic, strong) THNAddressModel *addressModel;

@end
