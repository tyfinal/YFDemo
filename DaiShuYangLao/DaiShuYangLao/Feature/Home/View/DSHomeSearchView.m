//
//  DSHomeSearchView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeSearchView.h"

@implementation DSHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _logoImageView.backgroundColor = [UIColor redColor];
        _logoImageView.image = ImageString(@"home_navigaiton_logo");
        [self addSubview:_logoImageView];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_left).with.offset(26*ScreenAdaptFator_W);
        }];
        
        _shoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingCartButton setImage:ImageString(@"public_navigation_shoppingcart") forState:UIControlStateNormal];
        [self addSubview:_shoppingCartButton];
        [_shoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_right).with.offset(-26*ScreenAdaptFator_W);
        }];
        
        UIView * searchView = [[UIView alloc]initWithFrame:CGRectZero];
        searchView.backgroundColor = [UIColor clearColor];
        _searchTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _searchTF.enabled = NO;
        _searchTF.userInteractionEnabled = YES;
        _searchTF.text = @"输入您需要查询的商品";
        _searchTF.textColor = JXColorFromRGB(0xa39b99);
        _searchTF.font = JXFont(12);
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.backgroundColor = JXColorFromRGB(0xeeeeee);
        [searchView addSubview:_searchTF];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 31, 31)];
        UIImageView * iconLeftView = [[UIImageView alloc]initWithFrame:CGRectMake((31-15)/2.0, (31-15)/2.0, 15, 15)];
                iconLeftView.image = ImageString(@"public_search_white");
        iconLeftView.tag = 100;
        [leftView addSubview:iconLeftView];
        _searchTF.leftView = leftView;
        
        [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(searchView);
        }];
        
//        __weak __typeof(self)weakSelf = self;
        [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.BeginSearchHandle) {
                self.BeginSearchHandle();
            }
        }]];
        [self addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(31);
            make.left.equalTo(self.logoImageView.mas_centerX).with.offset(35*ScreenAdaptFator_W); make.right.equalTo(self.shoppingCartButton.mas_centerX).with.offset(-35*ScreenAdaptFator_W);
        }];
        
        [searchView layoutIfNeeded];
        _searchTF.layer.cornerRadius = _searchTF.frameHeight/2.0;
        _searchTF.layer.masksToBounds = YES;
    
    }
    return self;
}

- (void)changeStatusWithAlpha:(CGFloat)alpha{
    UIImageView * icon = (UIImageView *)[self.searchTF.leftView viewWithTag:100];
    if (alpha<1.0) {
        [_shoppingCartButton setImage:ImageString(@"public_navigation_shoppingcart") forState:UIControlStateNormal];
        self.searchTF.textColor = JXColorAlpha(255, 255, 255, 1);
        self.searchTF.backgroundColor = JXColorAlpha(238, 238, 238, 0.2);
        icon.image = ImageString(@"public_search_white");
    }else{
        self.searchTF.textColor = JXColorFromRGB(0xa39b99);
        self.searchTF.backgroundColor = JXColorAlpha(238, 238, 238, 1.0);
        [_shoppingCartButton setImage:ImageString(@"public_navigation_shoppingcart_s") forState:UIControlStateNormal];
        icon.image = ImageString(@"public_search_gray");
    }
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
