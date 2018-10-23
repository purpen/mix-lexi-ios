//
//  THNFeaturedOpenCarouselScrollView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedOpenCarouselScrollView.h"
#import "UIColor+Extension.h"

#define ViewWidth self.bounds.size.width
#define ViewHeight self.bounds.size.height
#define OrangeColor [UIColor colorWithRed:254/255.0 green:97/255.0 blue:69/255.0 alpha:1.0]
//屏幕宽度和高度
#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

@interface THNFeaturedOpenCarouselScrollView()<UIScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *titles; //标题
@property(assign, nonatomic)int index;
@property(nonatomic,strong) UIView *firstView;
@property(nonatomic,strong) UILabel *firstLabel1;
@property(nonatomic,strong) UILabel *firstLable2;
@property(nonatomic,strong) UIView *secondView;
@property(nonatomic,strong) UILabel *secondLabel1;
@property(nonatomic,strong) UILabel *secondLabel2;

@end

@implementation THNFeaturedOpenCarouselScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.index = 0;
        self.delegate = self;
        self.firstView.frame = CGRectMake(0, 0, Screen_Width, ViewHeight);
        self.firstLabel1.frame = CGRectMake(0, 0, Screen_Width - 140, 13);
        self.firstLable2.frame = CGRectMake(0, CGRectGetMaxY(self.firstLabel1.frame) + 8, Screen_Width - 140, 13);
        self.secondView.frame = CGRectMake(0, ViewHeight, Screen_Width, ViewHeight);
        self.secondLabel1.frame = CGRectMake(0, 0, Screen_Width-140, 13);
        self.secondLabel2.frame = CGRectMake(0, CGRectGetMaxY(self.secondLabel1.frame) + 8, Screen_Width-140, 13);
    }
    
    return self;
}

- (void)setDataTitleArray:(NSArray *)titleArray {
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray<NSArray *> *finalArray = [NSMutableArray arrayWithCapacity:0];
    
    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpArray addObject:obj];
        if ((idx +1) % 2 == 0) {
            [finalArray addObject:[NSArray arrayWithArray:tmpArray]];
            [tmpArray removeAllObjects];
        } else {
            if (idx == (titleArray.count - 1)) {
                [finalArray addObject:[NSArray arrayWithArray:tmpArray]];
                [tmpArray removeAllObjects];
            }
        }
    }];
    
    self.titles = [NSMutableArray arrayWithArray:finalArray];
    [self setDataWithIndex:self.index];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextView) userInfo:nil repeats:YES];
}

- (void)setDataWithIndex:(int)index{
    NSArray *array = [NSArray array];
    
    if (index >= self.titles.count) {
        self.index = 0;
        return;
    } else {
        array = self.titles[index];
    }
    //根据单双数设置单行和双行Label的显示和隐藏
    if (array.count == 1) {
        self.firstLabel1.hidden = YES;
        self.firstLable2.hidden = YES;
    } else {
        self.firstLabel1.attributedText = array[0];
        self.firstLable2.attributedText = array[1];
        self.firstLabel1.hidden = NO;
        self.firstLable2.hidden = NO;
    }
    
    NSArray *nextArray = nil;      //数组循环
    
    if (index==self.titles.count-1) {
        nextArray = self.titles[0];
    } else {
        nextArray = self.titles[index+1];
    }
    
    if (nextArray.count == 1) {
        self.secondLabel1.hidden = YES;
        self.secondLabel2.hidden = YES;
    } else {
        self.secondLabel1.attributedText = nextArray[0];
        self.secondLabel2.attributedText = nextArray[1];
        self.secondLabel1.hidden = NO;
        self.secondLabel2.hidden = NO;
    }
}

- (void)nextView{
    [self setContentOffset:CGPointMake(0, ViewHeight) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y==ViewHeight) {
        
        if (self.index == self.titles.count-1) {
            self.index = 0;
        }else{
            self.index++;
        }
        [self setDataWithIndex:self.index];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
}

- (UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_firstView];
        [self.firstView addSubview:self.firstLabel1];
        [self.firstView addSubview:self.firstLable2];
    }
    return _firstView;
}

- (UILabel *)firstLabel1
{
    if (!_firstLabel1) {
        _firstLabel1 = [[UILabel alloc] init];
        _firstLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        _firstLabel1.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _firstLabel1;
}

- (UILabel *)firstLable2
{
    if (!_firstLable2) {
        _firstLable2 = [[UILabel alloc] init];
        _firstLable2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        _firstLable2.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _firstLable2;
}

- (UIView *)secondView
{
    if (!_secondView) {
        _secondView = [[UIView alloc] init];
        _secondView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_secondView];
        [self.secondView addSubview:self.secondLabel1];
        [self.secondView addSubview:self.secondLabel2];
    }
    return _secondView;
}

- (UILabel *)secondLabel1
{
    if (!_secondLabel1) {
        _secondLabel1 = [[UILabel alloc] init];
        _secondLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        _secondLabel1.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _secondLabel1;
}



- (UILabel *)secondLabel2
{
    if (!_secondLabel2) {
        _secondLabel2 = [[UILabel alloc] init];
        _secondLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        _secondLabel2.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _secondLabel2;
}


@end
