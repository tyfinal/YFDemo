//
//  DSWebContentView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface DSWebContentView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) WKWebView * webView;

@end
