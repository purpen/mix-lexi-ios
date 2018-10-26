//
//  THNToolBarView.m
//  newDemo
//
//  Created by HongpingRao on 2018/8/22.
//  Copyright © 2018年 Hongping Rao. All rights reserved.
//

#import "THNToolBarView.h"
#import "YYKit.h"
#import "WBEmoticonInputView.h"
#import <Masonry/Masonry.h>

@interface THNToolBarView() <YYTextViewDelegate, WBStatusComposeEmoticonViewDelegate>

@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *emoticoonButton;

@end

@implementation THNToolBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView.layer.cornerRadius = self.backgroundView.height / 2;
    [self.backgroundView addSubview:self.textView];
    [self toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backgroundView).with.offset(15);
        make.trailing.equalTo(self.backgroundView).with.offset(-42);
        make.top.equalTo(self.backgroundView).with.offset(0);
        make.bottom.equalTo(self.backgroundView).with.offset(0);
    }];
    
    [self layoutInputView];
    
}


- (void)toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    
    self.emoticoonButton.exclusiveTouch = YES;
     self.emoticoonButton.size = CGSizeMake(46, 46);
    [ self.emoticoonButton setImage:[self imageNamed:imageName] forState:UIControlStateNormal];
    [ self.emoticoonButton setImage:[self imageNamed:highlightImageName] forState:UIControlStateHighlighted];
     self.emoticoonButton.centerY = 46 / 2;
     self.emoticoonButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.emoticoonButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(UIButton *)button {
    if (_textView.inputView) {
        _textView.inputView = nil;
        [_textView reloadInputViews];
        [_textView becomeFirstResponder];
        
        [button setImage:[self imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [button setImage:[self imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self layoutInputView];
        [button setImage:[self imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [button setImage:[self imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
    
    
}

- (void)layoutInputView {
    WBEmoticonInputView *inputView = [WBEmoticonInputView sharedView];
    inputView.delegate = self;
    _textView.inputView = inputView;
    [_textView reloadInputViews];
    [_textView becomeFirstResponder];
}

- (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

- (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"WeiboImageCache";
    });
    return cache;
}

- (NSBundle *)bundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.alwaysBounceVertical = YES;
        _textView.allowsCopyAttributedString = NO;
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _textView.delegate = self;
        _textView.placeholderText = @"添加评论";
        _textView.inputAccessoryView = [UIView new];
    }
    return _textView;
}

#pragma mark @protocol YYTextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}


#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}

@end