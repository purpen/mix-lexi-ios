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

static NSString *const kAddressCellIdentifier = @"kAddressCellIdentifier";
static CGFloat const addressPickerViewHeight = 255;
static CGFloat const pickerViewHeight = 215;

static NSString *const kUrlPlaces = @"/places/provinces_cities";
static NSString *const kUrlAreaCode = @"/auth/area_code";
static NSString *const kUrlAddress = @"/address";

static NSString *const kName = @"name";
static NSString *const kOid = @"oid";

@interface THNNewShippingAddressViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, YYTextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
// 详细地址
@property (nonatomic, assign) NSString *streetAddress;
@property (nonatomic, assign) NSInteger countryID;
@property (nonatomic, assign) NSInteger provinceID;
@property (nonatomic, assign) NSInteger cityID;
@property (nonatomic, assign) NSInteger townID;

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
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.navigationBarView.title = @"新增收货地址";
    [self.tableView registerNib:[UINib nibWithNibName:@"THNNewShippingAddressTableViewCell" bundle:nil] forCellReuseIdentifier:kAddressCellIdentifier];
    [self.view addSubview:self.saveView];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    //跳转动画效果
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
}

- (void)initData {
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_id"] =  @(countryID);
    THNRequest *request = [THNAPI getWithUrlString:kUrlPlaces requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.provinces = result.data[@"k_1_0"];
        self.resultDict = result.data;
        [self.pickerView reloadAllComponents];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 点击完成
- (void)finish {
    if (self.textView.tag == 2) {
        self.textView.text = self.areaCodes[_countryIndex][kName] ? : @"";
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"first_name"] = self.name;
    params[@"mobile"] = self.mobile;
    params[@"country_id"] = @(self.countryID);
    params[@"province_id"] = @(self.provinceID);
    params[@"city_id"] = @(self.cityID);
    params[@"town_id"] = @(self.townID);
    params[@"street_address"] = self.streetAddress;
    params[@"zipcode"] = self.zipcode;
    params[@"is_default"] = @(self.isDefaultAddress);
    params[@"id_card_front"] = @(self.positiveImageID);
    params[@"id_card_back"] = @(self.negativeImageID);
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddress requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
    
}

//  设置默认地址
- (void)setDefaultAddress:(UISwitch *)swich {
    self.isDefaultAddress = swich.on;
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
    
    if (indexPath.row == 1) {
        [cell addSubview:cell.areaCodeTextView];
        cell.areaCodeTextView.inputView = self.addressPickerView;
        cell.areaCodeTextView.text = self.areaCodes[0][@"areacode"];
        cell.areaCodeTextView.delegate = self;
        cell.rightImageView.hidden = NO;
        cell.areaCodeTextView.viewWidth = 60;
        cell.areaCodeTextView.tintColor = [UIColor clearColor];
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        cell.rightImageView.hidden = NO;
        cell.areaCodeTextView.viewWidth = 0;
        cell.textView.inputView = self.addressPickerView;
        cell.textView.tintColor = [UIColor clearColor];
    } else {
        cell.areaCodeTextView.viewWidth = 0;
        cell.rightImageView.hidden = YES;
    }
    
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.row;
    [cell setPlaceholderText:self.placeholders[indexPath.row]];
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

    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.isHiddenCardView) {
        self.cardView.hidden = YES;
        return 58;
    } else {
        return 315;
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
        case 4:
            self.streetAddress = textView.text;
        case 5:
            self.zipcode = textView.text;
        default:
            break;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + 18, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    return _tableView;
}

- (NSArray *)placeholders {
    if (!_placeholders) {
        _placeholders = @[@"收件人真实姓名", @"手机号", @"选择国家", @"选择地区", @"详细地址", @"邮政编码"];
    }
    return _placeholders;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 315)];
        THNAddressIDCardView *cardView = [THNAddressIDCardView viewFromXib];
        
        cardView.openCameraBlcok = ^(PhotoType photoType) {
            self.photoTyoe = photoType;
            
            UIAlertController *alertCtl =[[UIAlertController alloc]init];
            
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *camaraAction =[UIAlertAction actionWithTitle:@"拍摄身份证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openCamera];
            }];
            UIAlertAction *photoAction =[UIAlertAction actionWithTitle:@"从相册选择身份证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self openPhotoLibrary];
            }];
            
            [alertCtl addAction:cancel];
            [alertCtl addAction:camaraAction];
            [alertCtl addAction:photoAction];
            
            [self presentViewController:alertCtl animated:YES completion:nil];
        };
        
        self.cardView = cardView;
        [_footerView addSubview:cardView];
        UILabel *label = [[UILabel alloc]init];
        [_footerView addSubview:label];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.text = @"设为默认地址";
        UISwitch *addressSwitch = [[UISwitch alloc]init];
        [addressSwitch addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:addressSwitch];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        [_footerView addSubview:view];
        
        __weak typeof(self)weakSelf = self;
        
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf.footerView);
            make.top.equalTo(weakSelf.footerView);
            make.height.equalTo(@(257));
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.footerView).with.offset(-48);
            make.leading.trailing.equalTo(weakSelf.footerView);
            make.height.equalTo(@(10));
        }];
        
        [addressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.footerView).with.offset(-15);
            make.bottom.equalTo(weakSelf.footerView.mas_bottom).with.offset(-8);
            make.height.equalTo(@(30));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.footerView).with.offset(15);
            make.centerY.equalTo(addressSwitch);
        }];
    }
    return _footerView;
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
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
        [saveButton drawCornerWithType:0 radius:4];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_saveView addSubview:saveButton];
    }
    return _saveView;
}

@end
