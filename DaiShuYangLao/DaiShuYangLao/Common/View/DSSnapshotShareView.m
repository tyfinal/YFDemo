//
//  DSSnapshotShareView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  截屏分享的视图

#import "DSSnapshotShareView.h"

@interface DSSnapshotShareView()<UIGestureRecognizerDelegate>{
    
}

@property (nonatomic, strong) UIView * shareView;


@end

@implementation DSSnapshotShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JXColorAlpha(0, 0, 0, 0.5);
        
        self.shareView = [[UIView alloc]initWithFrame:CGRectMake(8, kStatusBarHegiht, boundsWidth-16, 100)];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = JXFont(15);
        titleLabel.textColor = JXColorFromRGB(0x282828);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.shareView addSubview:titleLabel];
        titleLabel.text = @"分享截图给好友";
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareView.mas_centerX);
            make.centerY.equalTo(self.shareView.mas_top).offset(20);
            make.height.mas_equalTo(20);
        }];
        
        NSArray * imageNames = @[@"public_payresult_success",@"public_payresult_handle",@"public_payresult_failure",@"public_payresult_success"];
        NSMutableArray * buttons = @[].mutableCopy;
        for (NSInteger i=0; i<3; i++) {
            UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            shareButton.tag = 10+i;
            [shareButton setImage:ImageString(imageNames[i]) forState:UIControlStateNormal];
            [shareButton addTarget:self action:@selector(shareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.shareView addSubview:shareButton];
            [buttons addObject:shareButton];
        }
        [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
            make.centerY.equalTo(self.shareView.mas_top).with.offset(62.5);
        }];
        
        [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:45 leadSpacing:ceil(20*ScreenAdaptFator_W) tailSpacing:ceil(20*ScreenAdaptFator_W)];
        
        self.shareView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.shareView];
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeShareView)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
    
    }
    return self;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view ==self.shareView) {
        return NO;
    }
    return YES;
}

- (void)shareButtonEvent:(UIButton *)button{
    if (self.shareButtonClickHandle) {
        self.shareButtonClickHandle(button, self);
    }
}

- (void)removeShareView{
    if (self.removeShareViewHandle) {
        self.removeShareViewHandle();
    }
}

@end
