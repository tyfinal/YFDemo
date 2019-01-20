//
//  DSHomeEntranceReusableView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeEntranceReusableView.h"

@implementation DSHomeEntranceReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end


@implementation HomeEntranceSectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = JXColorFromRGB(0xefefef);
    }
    return self;
}

@end


@implementation HomeEntranceSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = JXColorFromRGB(0xeeeeee);
        [self.contentView addSubview:_backgroundView];
        
        self.contentView.backgroundColor = JXColorFromRGB(0xffffff);
        _titleImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.titleImageView];
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(131, 17));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
    }
    return self;
}

@end
