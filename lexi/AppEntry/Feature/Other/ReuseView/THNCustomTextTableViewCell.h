//
//  THNCustomTextTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNCustomTextTableViewCell : UITableViewCell

- (void)thn_setIconImageName:(NSString *)imageName mainText:(NSString *)mainText;
- (void)thn_setSubText:(NSString *)subText textColor:(NSString *)colorHex;

@end
