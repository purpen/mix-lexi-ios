//
//  THNLogisticsViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLogisticsViewController.h"

@interface THNLogisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *waybillNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logisticsStatusImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THNLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
