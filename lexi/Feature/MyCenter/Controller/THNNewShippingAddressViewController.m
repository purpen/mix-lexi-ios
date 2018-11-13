//
//  THNNewShippingAddressViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewShippingAddressViewController.h"
#import "THNNewShippingAddressTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "THNAddressIDCardView.h"
#import "THNQiNiuUpload.h"
#import "UIViewController+THNHud.h"

static NSString *const kAddressCellIdentifier = @"kAddressCellIdentifier";
static CGFloat const addressPickerViewHeight = 255;
static CGFloat const pickerViewHeight = 215;
static CGFloat const deleteAdderssViewHeight = 64;
static CGFloat const cardViewHeight = 257;
static CGFloat const defaultAdderssViewHeight = 64;
static CGFloat const lineHeight = 16;
static NSString *const kUrlPlaces = @"/places/provinces_cities";
static NSString *const kUrlAreaCode = @"/auth/area_code";
static NSString *const kUrlAddress = @"/address";
static NSString *const kUrlGetaddressCustoms = @"/address/custom";
static NSString *const kName = @"name";
static NSString *const kOid = @"oid";


@interface THNNewShippingAddressViewController () <
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDataSource,
UIPickerViewDelegate,
YYTextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UITableView *tableView;
// textView默认提示文字数组
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) UIView *footerView;
// 选择器所在的View
@property (nonatomic, strong) UIView *addressPickerView;
// 选择器
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *citys;
@property (nonatomic, strong) NSArray *towns;
// 手机区号编码 + 国家id 名字的字典数组
@property (nonatomic, strong) NSArray *areaCodes;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) NSDictionary *resultDict;
// 选择器列数
@property (nonatomic, assign) NSInteger numberOfComponents;
// 保存View
@property (nonatomic, strong) UIView *saveView;
@property (nonatomic, strong) THNAddressIDCardView *cardView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
// 身份证照片类型
@property (nonatomic, assign) PhotoType photoTyoe;
// 身份证正面照片Data数据
@property (nonatomic, strong) NSData *positiveImageData;
@property (nonatomic, assign) NSInteger positiveImageID;
// 身份证反面照片Data数据
@property (nonatomic, strong) NSData *negativeImageData;
@property (nonatomic, assign) NSInteger negativeImageID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
// 邮编
@property (nonatomic, strong) NSString *zipcode;
// 是否默认地址
@property (nonatomic, assign) BOOL isDefaultAddress;
@property (nonatomic, strong) UIView *defaultAddressView;
@property (nonatomic, strong) UIView *deleteAdderssView;
// 详细地址
@property (nonatomic, assign) NSString *streetAddress;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, assign) NSInteger countryID;
@property (nonatomic, assign) NSInteger provinceID;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, assign) NSInteger townID;
// 是否隐藏身份证所在的View
@property (nonatomic, assign) BOOL isShowCardView;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation THNNewShippingAddressViewController
{
    NSInteger _countryIndex;    // 国家选择 记录
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
    NSInteger _areacodeIndex;   // 手机区号选择 记录
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAreaCodeData];
    [self initData];
    [self setupUI];
    
    if (self.addressModel) {
        self.isDefaultAddress = self.addressModel.isDefault;
        [self loadGetaddressCustomData];
        self.navigationBarView.title = @"编辑收货地址";
        
    } else {
        self.navigationBarView.title = @"新增收货地址";
        self.isShowCardView = self.isSaveCustom;
    }
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNNewShippingAddressTableViewCell" bundle:nil] forCellReuseIdentifier:kAddressCellIdentifier];
    [self.view addSubview:self.saveView];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    //跳转动画效果
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
    self.saveButton.enabled = NO;
    self.saveButton.alpha = 0.5;
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [self.tableView addGestureRecognizer:tableViewGesture];
}

- (void)tableViewTouchInSide{
    // ------结束编辑，隐藏键盘
    [self.view endEditing:YES];
}

- (void)initData {
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

// 获取区号,国家ID 等等
- (void)loadAreaCodeData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlAreaCode requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.areaCodes = result.data[@"area_codes"];
        [self.tableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 获取所有地址
- (void)loadPlacesDataCountryID:(NSInteger)countryID {
    [SVProgressHUD thn_show];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_id"] =  @(countryID);
    THNRequest *request = [THNAPI getWithUrlString:kUrlPlaces requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.provinces = result.data[@"k_1_0"];
        self.resultDict = result.data;
        [self.pickerView reloadAllComponents];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

// 删除收货地址
- (void)deleteAddress {
    NSString *requestUrl = [NSString stringWithFormat:@"/address/%@",self.addressModel.rid];
    THNRequest *request = [THNAPI deleteWithUrlString:requestUrl requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [SVProgressHUD thn_showSuccessWithStatus:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

// 获取海关信息
- (void)loadGetaddressCustomData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_name"] = self.addressModel.firstName;
    params[@"mobile"] = self.addressModel.mobile;
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlGetaddressCustoms requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.data.count == 0 && !self.isSaveCustom) {
            self.isShowCardView = NO;
            
        } else {
            self.isShowCardView = YES;
            self.cardView.cardTextField.text = result.data[@"id_card"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *positiveImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:result.data[@"id_card_back"][@"view_url"]]]];
                UIImage *negativeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:result.data[@"id_card_front"][@"view_url"]]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if (positiveImage) {
                        [self.cardView.positiveButton setImage:positiveImage forState:UIControlStateNormal];
                    }
                    
                    if (negativeImage) {
                        [self.cardView.negativeButton setImage:negativeImage forState:UIControlStateNormal];
                    }
                   
                    
                });
            });
            
            [self.tableView reloadData];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 点击完成
- (void)finish {
    if (self.textView.tag == 2) {
        self.countryName = self.areaCodes[_countryIndex][kName] ? : @"";
        self.textView.text = self.countryName;
        self.countryID = [self.areaCodes[_countryIndex][@"id"]integerValue];
        [self loadPlacesDataCountryID:self.countryID];
        [self.textView resignFirstResponder];
        
    } else if (self.textView.tag == 3) {
        self.provinceID = [self.provinces[_provinceIndex][kOid]integerValue];
        self.cityID = [self.citys[_cityIndex][kOid]integerValue];
        self.townID = [self.towns[_districtIndex][kOid]integerValue];
        self.textView.text = [NSString stringWithFormat:@"%@ %@ %@",self.provinces[_provinceIndex][kName] ? : @"", self.citys[_cityIndex][kName] ? : @"" , self.towns[_districtIndex][kName] ? : @""];
        [self.textView resignFirstResponder];
        
    } else {
        self.textView.text = self.areaCodes[_areacodeIndex][@"areacode"] ? : @"";
        [self.textView resignFirstResponder];
    }
}

// 保存
- (void)save {
    if (self.countryName.length == 0) {
        [SVProgressHUD thn_showErrorWithStatus:@"请选择国家"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"first_name"] = self.name;
    params[@"mobile"] = self.mobile;
    params[@"country_id"] = @(self.countryID);
    params[@"country_name"] = self.countryName;
    params[@"province_id"] = @(self.provinceID);
    params[@"city_id"] = @(self.cityID);
    params[@"town_id"] = @(self.townID);
    params[@"street_address"] = self.streetAddress;
    params[@"zipcode"] = self.zipcode;
    params[@"is_default"] = @(self.isDefaultAddress);
    params[@"id_card_front"] = @(self.positiveImageID);
    params[@"id_card_back"] = @(self.negativeImageID);
    params[@"is_overseas"] = @(self.isSaveCustom);
    params[@"id_card"] = self.cardView.cardTextField.text;
    
    [SVProgressHUD thn_show];
    
    if (self.addressModel.rid) {
        params[@"rid"] = self.addressModel.rid;
        THNRequest *request = [THNAPI putWithUrlString:kUrlAddress requestDictionary:params delegate:nil];
        [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
            [SVProgressHUD dismiss];
            if (!result.success) {
                [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(THNRequest *request, NSError *error) {
            
        }];
    } else {
        THNRequest *request = [THNAPI postWithUrlString:kUrlAddress requestDictionary:params delegate:nil];
        [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
            [SVProgressHUD dismiss];
            if (!result.success) {
                [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(THNRequest *request, NSError *error) {
            
        }];
    }
}

//  设置默认地址
- (void)setDefaultAddress:(UISwitch *)swich {
    self.isDefaultAddress = swich.on;
    
    if (self.addressModel.rid) {
        NSString *requestUrl = [NSString stringWithFormat:@"/address/%@/set_default",self.addressModel.rid];
        THNRequest *request = [THNAPI putWithUrlString:requestUrl requestDictionary:nil delegate:nil];
        [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
            
            if (!result.success) {
                [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
                return;
            }
            
        } failure:^(THNRequest *request, NSError *error) {
            
        }];
    }
}

#pragma mark 上传身份证
//打开相机
- (void)openCamera {
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else{
        NSLog(@"没有摄像头");
    }
}

// 打开相册
- (void)openPhotoLibrary {
    
    // 进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:^{
            NSLog(@"打开相册");
        }];
    }else{
        NSLog(@"不能打开相册");
    }
}


#pragma mark - UIImagePickerControllerDelegate
// 照片完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!editedImage) {
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.photoTyoe == PhotoTypePositive) {
           self.positiveImageData = UIImagePNGRepresentation(editedImage);
            [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:self.positiveImageData
                                                           compltion:^(NSDictionary *result) {
                                                             self.positiveImageID = [result[@"ids"][0]integerValue];
                                                           }];
           [self.cardView.positiveButton setImage:editedImage forState:UIControlStateNormal];
        } else {
           self.negativeImageData = UIImagePNGRepresentation(editedImage);
           [self.cardView.negativeButton setImage:editedImage forState:UIControlStateNormal];
            [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:self.negativeImageData
                                                           compltion:^(NSDictionary *result) {
                                                              self.negativeImageID = [result[@"ids"][0]integerValue];
                                                           }];
        }
        
    }];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.placeholders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNNewShippingAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.returnKeyType = UIReturnKeyDone;
    if (indexPath.row == 1) {
        if (self.mobile) {
            cell.textView.text = self.mobile;
        } else {
            cell.textView.text = self.addressModel.mobile;
            self.mobile = self.addressModel.mobile;
        }

        [cell addSubview:cell.areaCodeTextView];
        cell.areaCodeTextView.inputView = self.addressPickerView;
        cell.areaCodeTextView.text = self.areaCodes[0][@"areacode"];
        cell.areaCodeTextView.delegate = self;
        cell.areaCodeTextView.viewWidth = 60;
        cell.areaCodeTextView.tintColor = [UIColor clearColor];
        // 业务需要，暂时隐藏区号
        cell.areaCodeTextView.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.row == 2) {
        if (self.countryName) {
            cell.textView.text = self.countryName;
        } else {
            cell.textView.text = self.addressModel.countryName;
            self.countryName = self.addressModel.countryName;
        }
        self.countryID = self.addressModel.countryId;
        cell.rightImageView.hidden = NO;
        cell.areaCodeTextView.viewWidth = 0;
        cell.textView.inputView = self.addressPickerView;
        cell.textView.tintColor = [UIColor clearColor];
    }else if (indexPath.row == 3) {
        
        if (self.addressModel.province.length > 0) {

            cell.textView.text = [NSString stringWithFormat:@"%@ %@ %@",self.addressModel.province ?: @"", self.addressModel.city ?: @"", self.addressModel.town ?: @""];
            self.provinceID = self.addressModel.provinceId;
            self.cityID = self.addressModel.cityId;
            self.townID = self.addressModel.townId;
        }
        
        cell.rightImageView.hidden = NO;
        cell.areaCodeTextView.viewWidth = 0;
        cell.textView.inputView = self.addressPickerView;
        cell.textView.tintColor = [UIColor clearColor];
    }else if (indexPath.row == 4) {
        if (self.streetAddress) {
            cell.textView.text = self.streetAddress;
        } else {
            cell.textView.text = self.addressModel.streetAddress;
            self.streetAddress = self.addressModel.streetAddress;
        }

        cell.areaCodeTextView.viewWidth = 0;
        cell.rightImageView.hidden = YES;
    }else if (indexPath.row == 5) {
        if (self.zipcode) {
            cell.textView.text = self.zipcode;
        } else {
            cell.textView.text = self.addressModel.zipcode;
            self.zipcode = self.addressModel.zipcode;
        }
        cell.areaCodeTextView.viewWidth = 0;
        cell.rightImageView.hidden = YES;
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.row == 0) {
        if (self.name) {
            cell.textView.text = self.name;
        } else {
            cell.textView.text = self.addressModel.firstName;
            self.name = self.addressModel.firstName;
        }
        cell.areaCodeTextView.viewWidth = 0;
        cell.rightImageView.hidden = YES;
    }
    
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.row;
    [cell setPlaceholderText:self.placeholders[indexPath.row]];

    if (self.name.length > 0 && self.mobile.length > 0 && self.streetAddress.length > 0 && self.zipcode.length > 0) {
        self.saveButton.enabled = YES;
        self.saveButton.alpha = 1;
    } else {
        self.saveButton.enabled = NO;
        self.saveButton.alpha = 0.5;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        return 69;
    } else {
        return 48;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WEAKSELF;
    
    if (self.addressModel) {
        [self.footerView addSubview:self.deleteAdderssView];
        [self.deleteAdderssView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf.footerView);
            make.bottom.equalTo(weakSelf.footerView);
            make.height.equalTo(@(deleteAdderssViewHeight));
        }];
    }
    
    if (self.isShowCardView) {
        [self.footerView addSubview:self.cardView];
        [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf.footerView);
            make.top.equalTo(weakSelf.footerView);
            make.height.equalTo(@(cardViewHeight));
        }];
    }
    
    [self.footerView addSubview:self.defaultAddressView];
    [self.defaultAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.footerView);
        if (self.addressModel) {
            make.bottom.equalTo(weakSelf.deleteAdderssView.mas_top);
        } else {
            make.bottom.equalTo(weakSelf.footerView);
        }
        make.height.equalTo(@(defaultAdderssViewHeight));
    }];
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isShowCardView && self.addressModel) {
        return cardViewHeight + defaultAdderssViewHeight + deleteAdderssViewHeight;
    } else if (self.addressModel) {
        return deleteAdderssViewHeight + defaultAdderssViewHeight;
    } else if (self.isShowCardView) {
        return cardViewHeight + defaultAdderssViewHeight;
    } else {
        return defaultAdderssViewHeight;
    }
 }

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    
    if (textView.tag == 3 && !self.countryID) {
        [self loadPlacesDataCountryID:[self.areaCodes[0][@"id"]integerValue]];
    }
    
    if (textView.tag == 3) {
         [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    } else if (textView.tag == 2) {
        [self.pickerView selectRow:_countryIndex inComponent:0 animated:YES];
    } else {
        [self.pickerView selectRow:_areacodeIndex inComponent:0 animated:YES];
    }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.textView = textView;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    switch (textView.tag) {
        case 0:
            self.name = textView.text;
            break;
        case 1:
            self.mobile = textView.text;
            break;
        case 4:
            self.streetAddress = textView.text;
            break;
        case 5:
            self.zipcode = textView.text;
            break;
        default:
            break;
    }
    
    if (self.name.length > 0 && self.mobile.length > 0 && self.streetAddress.length > 0 && self.zipcode.length > 0 ) {
        self.saveButton.enabled = YES;
        self.saveButton.alpha = 1;
    } else {
        self.saveButton.enabled = NO;
        self.saveButton.alpha = 0.5;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

#pragma mark - PickerView Delegate
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.textView.tag == 3) {
        self.numberOfComponents = 3;
    } else {
        self.numberOfComponents = 1;
    }
    
    return self.numberOfComponents;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.textView.tag == 3) {
        
        if (component == 0) {
            
            return self.provinces.count;
            
        } else if (component == 1) {
            
            NSString *cityKey = [NSString stringWithFormat:@"k_2_%ld",[self.provinces[_provinceIndex][kOid]integerValue]];
            self.citys = self.resultDict[cityKey];
            return self.citys.count;
            
        } else {
            
            NSString *townKey = [NSString stringWithFormat:@"k_3_%ld",[self.citys[_cityIndex][kOid]integerValue]];
            self.towns = self.resultDict[townKey];
            return self.towns.count;
            
        }
    } else {
        
         return self.areaCodes.count;
        
    }
    
}

// 每行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.textView.tag == 3) {
        
        if (component == 0) {
            
            return self.provinces[row][kName];
            
        } else if (component == 1) {
            
            return self.citys[row][kName];
            
        } else {
            
            return self.towns[row][kName];
            
        }
        
    } else if (self.textView.tag == 2) {
        
        return self.areaCodes[row][kName];
        
    } else {
        
        return self.areaCodes[row][@"areacode"];
    }
}

// 滑动或点击选择，确认pickerView选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    if (self.textView.tag == 2) {
         _countryIndex = row;
    } else if (self.textView.tag == 3) {
        if (component == 0) {
            _provinceIndex = row;
            _cityIndex = 0;
            _districtIndex = 0;
            
            if (self.numberOfComponents > 2) {
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
            }
            
        } else if (component == 1) {
            _cityIndex = row;
            _districtIndex = 0;
            
            if (self.numberOfComponents > 2) {
                [self.pickerView reloadComponent:2];
            }
            
        } else {
            _districtIndex = row;
        }
    } else {
         _areacodeIndex = row;
    }
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ADDRESS_TOP, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.separatorColor = [UIColor colorWithHexString:@"e9e9e9"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHexString:@"e9e9e9"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    return _tableView;
}

- (NSArray *)placeholders {
    if (!_placeholders) {
        _placeholders = @[@"收件人真实姓名", @"手机号", @"选择国家/地区", @"选择地区", @"详细地址", @"邮政编码"];
    }
    return _placeholders;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    return _footerView;
}

- (UIView *)defaultAddressView {
    if (!_defaultAddressView) {
        _defaultAddressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, defaultAdderssViewHeight)];
        UILabel *label = [[UILabel alloc]init];
        [_defaultAddressView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.text = @"设为默认地址";
        UISwitch *addressSwitch = [[UISwitch alloc]init];
        [addressSwitch setOn:self.addressModel.isDefault animated:YES];
        [addressSwitch addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
        [_defaultAddressView addSubview:addressSwitch];
      
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        [_defaultAddressView addSubview:view];
        WEAKSELF;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(weakSelf.defaultAddressView);
            make.height.equalTo(@(lineHeight));
        }];
        
        [addressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.defaultAddressView).with.offset(-15);
            make.bottom.equalTo(weakSelf.defaultAddressView.mas_bottom).with.offset(-8);
            make.height.equalTo(@(30));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.defaultAddressView).with.offset(15);
            make.centerY.equalTo(addressSwitch);
        }];
    }
    return _defaultAddressView;
}

- (UIView *)deleteAdderssView {
    if (!_deleteAdderssView) {
        WEAKSELF;
        _deleteAdderssView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, deleteAdderssViewHeight)];
        UIButton *btn = [[UIButton alloc]init];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [btn setTitleColor:[UIColor colorWithHexString:@"FF6666"] forState:UIControlStateNormal];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteAddress) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        [_deleteAdderssView addSubview:view];
        [_deleteAdderssView addSubview:btn];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(weakSelf.deleteAdderssView);
            make.height.equalTo(@(lineHeight));
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(weakSelf.deleteAdderssView);
            make.top.equalTo(view.mas_bottom);
        }];
    }
    return _deleteAdderssView;
}

- (THNAddressIDCardView *)cardView {
    if (!_cardView) {
        _cardView = [THNAddressIDCardView viewFromXib];
        _cardView.cardTextField.delegate = self;
        
        __weak typeof(self)weakSelf = self;
        
        _cardView.openCameraBlcok = ^(PhotoType photoType) {
            weakSelf.photoTyoe = photoType;
            
            UIAlertController *alertCtl =[[UIAlertController alloc]init];
            
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *camaraAction =[UIAlertAction actionWithTitle:@"拍摄身份证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf openCamera];
            }];
            UIAlertAction *photoAction =[UIAlertAction actionWithTitle:@"从相册选择身份证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf openPhotoLibrary];
            }];
            
            [alertCtl addAction:cancel];
            [alertCtl addAction:camaraAction];
            [alertCtl addAction:photoAction];
            
            [weakSelf presentViewController:alertCtl animated:YES completion:nil];
        };
        
    }
    return _cardView;
}

- (UIPickerView *)pickerView {
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.finishView.frame), SCREEN_WIDTH, pickerViewHeight)];
    }
    return _pickerView;
}

- (UIView *)addressPickerView {
    if (!_addressPickerView) {
        _addressPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - addressPickerViewHeight, SCREEN_WIDTH, addressPickerViewHeight)];
        _addressPickerView.backgroundColor = [UIColor whiteColor];
        [_addressPickerView addSubview:self.finishView];
        [_addressPickerView addSubview:self.pickerView];
    }
    return _addressPickerView;
}

- (UIView *)finishView {
    if (!_finishView) {
        _finishView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, addressPickerViewHeight - pickerViewHeight)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 32, 12, 32, 16)];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"949EA6"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_finishView addSubview:button];
    }
    return _finishView;
}

- (UIView *)saveView {
    if (!_saveView) {
        _saveView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_HEIGHT, 50)];
        _saveView.backgroundColor = [UIColor whiteColor];
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 40)];
        self.saveButton = saveButton;
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        [saveButton drawCornerWithType:0 radius:4];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_saveView addSubview:saveButton];
    }
    return _saveView;
}

@end
