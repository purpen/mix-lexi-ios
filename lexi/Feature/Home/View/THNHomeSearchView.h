//
//  THNHomeSearchView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeHome,
    SearchTypeProductCenter
};

@interface THNHomeSearchView : UIView

@property (nonatomic, assign) SearchType searchType;

@end
