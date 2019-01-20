//
//  DSWebContentView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWebContentView.h"

@implementation DSWebContentView
static CGFloat const kButtonWidth = 40;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc]initWithFrame:frame];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
//        _titleLabel = [[UILabel alloc]init];
//        _titleLabel.font = JXFont(13);
//        _titleLabel.textColor = JXColorFromRGB(0x666666);
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.text = @"提现规则";
//        [self.contentView addSubview:_titleLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:ImageString(@"public_close_black") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_cancelButton];;
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wap.dscs123.com/event/withdraw/index.html"]]];
        [_contentView addSubview:_webView];
        
        [_contentView bringSubviewToFront:_cancelButton];
        
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonWidth));
            make.top.equalTo(_contentView.mas_top).with.offset(0);
            make.right.equalTo(_contentView.mas_right).with.offset(0);
        }];

        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView.mas_left).with.offset(kButtonWidth/2.0);
            make.top.equalTo(_contentView.mas_top).with.offset(kButtonWidth/2.0);
            make.right.equalTo(_contentView.mas_right).with.offset(-kButtonWidth/2.0);
            make.bottom.equalTo(_contentView.mas_bottom).with.offset(-kButtonWidth/2.0);
        }];
        [_contentView layoutIfNeeded];
        _cancelButton.layer.cornerRadius = kButtonWidth/2.0f;
        _cancelButton.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)closeView{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
