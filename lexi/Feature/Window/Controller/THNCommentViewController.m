//
//  THNContentTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentViewController.h"
#import "THNMarco.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "UIView+Helper.h"
#import "THNToolBarView.h"
#import "YYKit.h"

static NSString *const kUrlShopWindowsComments = @"/shop_windows/comments";
static NSString *const kUrlChildComments = @"/shop_windows/child_comments";
static NSString *const kFirstLevelCellIdentifier = @"kFirstLevelCellIdentifier";

@interface THNCommentViewController ()<UITableViewDelegate, UITableViewDataSource, YYTextKeyboardObserver, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) THNToolBarView *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIView *commentLikesView;

@end

@implementation THNCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadFirstLevelCommentData];
}

- (void)setupUI {
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    self.tableViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNFirstLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kFirstLevelCellIdentifier];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 橱窗一级评论
- (void)loadFirstLevelCommentData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShopWindowsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 橱窗二级评论
- (void)loadSecondLevelCommentData:(NSString *)pid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pid"] = pid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlChildComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    THNFirstLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFirstLevelCellIdentifier forIndexPath:indexPath];
//    return cell;
//}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - lazy
- (THNToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [THNToolBarView viewFromXib];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.frame = CGRectMake(0, 1000, self.view.width, 50);
        [self.view addSubview:_toolbar];
    }
    return _toolbar;
}

@end
