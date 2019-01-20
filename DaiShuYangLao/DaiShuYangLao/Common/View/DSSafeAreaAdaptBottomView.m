//
//  DSSafeAreaAdaptBottomView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  旨在适配 iPhone X 吸底按钮

#import "DSSafeAreaAdaptBottomView.h"

@implementation DSSafeAreaAdaptBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftView = [[UIView alloc]initWithFrame:CGRectZero];
        self.leftView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftView];
        
        self.rightView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.rightView];
        
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(135);
            make.right.top.and.bottom.equalTo(self);
            make.left.equalTo(self.leftView.mas_right).priorityLow();
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.rightView);
        }];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
