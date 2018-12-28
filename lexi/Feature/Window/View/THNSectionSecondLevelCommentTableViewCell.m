//
//  THNSectionSecondLevelCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/11/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSectionSecondLevelCommentTableViewCell.h"
#import "THNCommentModel.h"
#import "THNTextTool.h"

@interface THNSectionSecondLevelCommentTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation THNSectionSecondLevelCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 62;
    frame.size.width -= 82;
    [super setFrame:frame];
}

- (void)setSubCommentModel:(THNCommentModel *)subCommentModel {
    _subCommentModel = subCommentModel;
    if (subCommentModel.height) {
        if (subCommentModel.reply_user_name.length > 0) {
              NSString *secondReplyStr= [NSString stringWithFormat:@"%@ 回复 %@: %@",subCommentModel.user_name, subCommentModel.reply_user_name, subCommentModel.content];
            self.contentLabel.attributedText = [THNTextTool setTextColor:secondReplyStr initWithColor:@"999999" initWithRange:NSMakeRange(subCommentModel.user_name.length + 1, 2)];
        } else {
            self.contentLabel.text = [NSString stringWithFormat:@"%@ : %@",subCommentModel.user_name, subCommentModel.content];
        }
        
    } else {
        NSString *contentStr = [NSString stringWithFormat:@"%@ 等人共%ld条回复",subCommentModel.user_name, self.subCommentCount];
        NSInteger loc = subCommentModel.user_name.length + 3;
         self.contentLabel.attributedText = [THNTextTool setTextColor:contentStr initWithColor:@"5FE4B1" initWithRange:NSMakeRange(loc, contentStr.length - loc)];
    }
}

@end
