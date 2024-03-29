//
//  THNOrderDetailLogisticsView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailLogisticsView.h"
#import "THNOrderDetailModel.h"
#import "THNAddressModel.h"

@interface THNOrderDetailLogisticsView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation THNOrderDetailLogisticsView

- (void)setDetailModel:(THNOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    self.nameLabel.text = detailModel.buyer_name;
    self.addressLabel.text = detailModel.buyer_address;
    
    if (detailModel.buyer_country.length == 0 || [detailModel.buyer_country isEqualToString:@"中国"]) {
        self.countyLabel.text = detailModel.buyer_province;
    } else {
        self.countyLabel.text = [NSString stringWithFormat:@"%@,%@",detailModel.buyer_country,detailModel.buyer_province];
    }
    
    self.cityLabel.text = detailModel.buyer_city;
    self.numberLabel.text = detailModel.buyer_phone;
    self.areaCodeLabel.text = detailModel.buyer_zipcode;
}

- (void)setAddressModel:(THNAddressModel *)addressModel {
    _addressModel = addressModel;
    self.nameLabel.text = addressModel.firstName;
    self.addressLabel.text = addressModel.streetAddress;
    
    if (addressModel.countryName.length == 0 || [addressModel.countryName isEqualToString:@"中国"]) {
        self.countyLabel.text = addressModel.province;
    } else {
        self.countyLabel.text = [NSString stringWithFormat:@"%@,%@",addressModel.countryName,addressModel.province];
    }
    
    self.cityLabel.text = addressModel.city;
    self.numberLabel.text = addressModel.mobile;
    self.areaCodeLabel.text = addressModel.zipcode;
}


@end
