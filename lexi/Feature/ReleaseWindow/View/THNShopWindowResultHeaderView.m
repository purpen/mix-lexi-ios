//
//  THNShopWindowResultHeaderView.m
//  lexi
//
//  Created by rhp on 2018/11/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowResultHeaderView.h"
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"

static NSString *const kUrlAddShopWindowKeyWords = @"/shop_windows/keywords";

@interface THNShopWindowResultHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation THNShopWindowResultHeaderView

- (IBAction)addLabel:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = self.name;
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddShopWindowKeyWords requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        [SVProgressHUD thn_showInfoWithStatus:@"添加成功"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addLabelSuccess" object:nil userInfo:@{@"name":self.name}];
        }];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = [NSString stringWithFormat:@"# %@", self.name];
}

@end
