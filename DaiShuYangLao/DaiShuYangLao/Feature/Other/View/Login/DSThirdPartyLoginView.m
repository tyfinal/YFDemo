//
//  DSThirdPartyLoginView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  第三方登录

#import "DSThirdPartyLoginView.h"

@implementation DSThirdPartyLoginView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(12);
        _titleLabel.textColor = JXColorFromRGB(0x9a9a9a);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"您还可以用以下方式登录";
        [self addSubview:_titleLabel];
        
        UIView * leftLine = [[UIView alloc]initWithFrame:CGRectZero];
        leftLine.backgroundColor = JXColorFromRGB(0xefefef);
        [self addSubview:leftLine];
        
        UIView * rightLine = [[UIView alloc]initWithFrame:CGRectZero];
        rightLine.backgroundColor = JXColorFromRGB(0xefefef);
        [self addSubview:rightLine];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        
        NSMutableArray * mu = [NSMutableArray array];
        NSArray * imageNames = @[@"login_thirdparty_wechat",@"login_thirdparty_qq",@"login_thirdparty_weibo"];
        for (NSInteger i=0; i<3; i++) {
            ThirdPartyItemView * item = [[ThirdPartyItemView alloc]initWithFrame:CGRectZero];
            item.textLabel.text = @[@"微信",@"QQ",@"微博"][i];
            item.tag = 10+i;
            item.icon.image = ImageString(imageNames[i]);
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItem:)];
            [item addGestureRecognizer:ges];
            [self.contentView addSubview:item];
            [mu addObject:item];
        }
        
        [mu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
        }];
        
        [mu mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40 leadSpacing:ceil(70*ScreenAdaptFator_W) tailSpacing:ceil(70*ScreenAdaptFator_W)];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12+kLabelHeightOffset/2.0);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(0);
        }];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(25*ScreenAdaptFator_W);
            make.right.equalTo(_titleLabel.mas_left).with.offset(-5);
            make.height.mas_equalTo(0.5);
            make.centerY.equalTo(_titleLabel.mas_centerY);
        }];

        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-25*ScreenAdaptFator_W);
            make.left.equalTo(_titleLabel.mas_right).with.offset(5);
            make.height.mas_equalTo(0.5);
            make.centerY.equalTo(_titleLabel.mas_centerY);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            if (boundsHeight<=480) {
                make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
            }else{
               make.top.equalTo(_titleLabel.mas_bottom).with.offset(30*ScreenAdaptFator_H);
            }
            make.bottom.equalTo(self.mas_bottom).with.offset(0).priorityLow();
            make.height.mas_equalTo(50);
        }];
        
        
    }
    return self;
}

- (void)clickItem:(UITapGestureRecognizer *)ges{
    NSInteger index = ges.view.tag-10;
    if (self.ThirdPartyLoginWay) {
        self.ThirdPartyLoginWay(index+1);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation ThirdPartyItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_icon];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(12);
        _textLabel.textColor = JXColorFromRGB(0x666666);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];

        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.height.mas_equalTo(12+kLabelHeightOffset/2.0);
            make.top.equalTo(_icon.mas_bottom).with.offset(5-kLabelHeightOffset/2.0);
        }];
        
    }
    return self;
}



@end
