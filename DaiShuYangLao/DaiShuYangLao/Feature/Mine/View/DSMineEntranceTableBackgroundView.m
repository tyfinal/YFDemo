//
//  DSMineEntranceTableBackgroundView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMineEntranceTableBackgroundView.h"

@implementation DSMineEntranceTableBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.topView.image = ImageString(@"mine_headerbg");
        [self addSubview:self.topView];
        
        self.bottomView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.bottomView.backgroundColor = JXColorFromRGB(0xf0f0f0);
        [self addSubview:self.bottomView];
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
