//
//  THNLivingHallTableView.m
//  lexi
//
//  Created by HongpingRao on 2018/12/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeadLineTableView.h"
#import "THNLivingHallHeadLineTableViewCell.h"
#import "THNAPI.h"
#import "THNLivingHallHeadLineModel.h"
#import "THNTextTool.h"
#import <MJExtension/MJExtension.h>

// 开馆指引
static NSString *const kUrlLivingHallHeadLine = @"/store/store_headline";

@interface THNLivingHallHeadLineTableView () <UITableViewDataSource>

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) int count;

@end

@implementation THNLivingHallHeadLineTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        self.dataSource = self;
        self.rowHeight = 30;
        [self registerNib:[UINib nibWithNibName:@"THNLivingHallHeadLineTableViewCell" bundle:nil] forCellReuseIdentifier:livingHallHeadLineCellIdentifier];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSRunLoopCommonModes];
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self loadLivingHallHeadLineData];
        
    }
    return self;
}

// 开馆指引
- (void)loadLivingHallHeadLineData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(2);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLivingHallHeadLine requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
        self.dataArray  = result.data[@"headlines"];
        [self reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)removeDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

//CADisplayLink 定时器 系统默认每秒调用60次
- (void) tick:(CADisplayLink *)displayLink {
    
    self.count ++;
    //(25.0 / 30.0) * (float)self.count) ---> (tableview需要滚动的contentOffset / 一共调用的次数) * 第几次调用
    //contentOffset最大值为 = cell的高度 * cell的个数 ,5秒执行一个循环则调用次数为 300,没1/60秒 count计数器加1,当count=300时,重置count为0,实现循环滚动.
    [self setContentOffset:CGPointMake(0, ((20.0 / 50.0) * (float)self.count)) animated:NO];
    
    if (self.count >= 50 * 60) {
        self.count = 0;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallHeadLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:livingHallHeadLineCellIdentifier forIndexPath:indexPath];
    THNLivingHallHeadLineModel *headLineModel = [THNLivingHallHeadLineModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setHeadLineModel:headLineModel];
    
    return cell;
}

@end
