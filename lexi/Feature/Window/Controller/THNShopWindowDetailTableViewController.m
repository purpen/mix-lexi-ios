//
//  THNShopWindowDetailTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowDetailTableViewController.h"
#import "THNShopWindowTableViewCell.h"
#import "THNFeatureTableViewCell.h"

@interface THNShopWindowDetailTableViewController ()

@end

@implementation THNShopWindowDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"橱窗";
}



#pragma mark - Table view data source


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    THNFeatureTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    [cell setCellTypeStyle:FeaturedLifeAesthetics initWithDataArray:<#(NSArray *)#> initWithTitle:<#(NSString *)#>]
////    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
