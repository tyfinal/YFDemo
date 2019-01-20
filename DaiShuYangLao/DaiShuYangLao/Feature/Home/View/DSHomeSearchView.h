//
//  DSHomeSearchView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSHomeSearchView : UIView

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * cityNameLabel;
@property (nonatomic, strong) UITextField * searchTF;
//@property (nonatomic, strong) UILabel * <#object#>;
@property (nonatomic, strong) UIButton * shoppingCartButton;
@property (nonatomic, copy) void(^BeginSearchHandle)(void);

- (void)changeStatusWithAlpha:(CGFloat)alpha;

@end
