//
//  DSEmptyDataCustomView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSEmptyDataCustomView.h"

@implementation DSEmptyDataCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
        
        self.emptyImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //        self.emptyImageView.backgroundColor = [UIColor yellowColor];
        UIImage * emptyImage = ImageString(@"public_loadingfailed");
        self.emptyImageView.image = emptyImage;
        [self.contentView addSubview:self.emptyImageView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"重新加载" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = JXFont(19);
        [_button setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_button setBackgroundImage:ImageString(@"address_createnew") forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.size.mas_equalTo(CGSizeMake(90, 85));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.width.mas_equalTo(ceil(130*ScreenAdaptFator_W));
            make.height.equalTo(_emptyImageView.mas_width).multipliedBy(emptyImage.size.height/emptyImage.size.width);
        }];
        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ceil(170*ScreenAdaptFator_W));
            make.height.mas_equalTo(_button.mas_width).multipliedBy(0.28);
            make.centerX.equalTo(self.emptyImageView.mas_centerX);
            make.top.equalTo(self.emptyImageView.mas_bottom).with.offset(ceil(40*ScreenAdaptFator_H));
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
        [self layoutIfNeeded];
        _button.layer.cornerRadius = _button.frameHeight/2.0f;
        _button.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)buttonEvent:(UIButton *)button{
    if (self.EmptyDataButtonClickHandle) {
        self.EmptyDataButtonClickHandle(button, self);
    }
}

@end
