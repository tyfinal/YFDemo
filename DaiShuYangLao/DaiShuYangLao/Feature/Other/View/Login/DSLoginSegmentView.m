//
//  DSLoginSegmentView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/24.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSLoginSegmentView.h"

@interface DSLoginSegmentView(){
    
}

@property (nonatomic, assign) BOOL tapDelay; //防暴力点击
@property (nonatomic, strong) UIButton * currentButton;

@end

@implementation DSLoginSegmentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"登录",@"注册"][i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = JXFont(18);
            [button setTitleColor:JXColorFromRGB(0xfe2c2a) forState:UIControlStateSelected];
            [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
            [button setAdjustsImageWhenHighlighted:NO];
            [self addSubview:button];
            
            [button setBackgroundColor:JXColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
            [button setBackgroundColor:APP_MAIN_COLOR forState:UIControlStateSelected];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(103, 55));
                make.left.equalTo(self.mas_left).with.offset(i*103);
                make.centerY.equalTo(self);
            }];
            
            if(i==0) {
                self.loginButton  = button;
                button.selected = YES;
                _currentButton = button;
            }
            if(i==1) self.registButton = button;
        }
    }
    return self;
}

- (void)buttonEvent:(UIButton *)button{
    if (_tapDelay) {
        return;
    }
    if (button!=_currentButton) {
        _tapDelay = YES;
        __weak typeof (self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.tapDelay = NO;
        });
        //点击的不是同一个按钮
        _currentButton.selected = NO;
        button.selected  = YES;
        _currentButton = button;
        if (self.clickBlock) {
            self.clickBlock(button);
        }
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


@implementation UIButton(LoginSegment)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    CGRect rect = CGRectMake(0.0f, 0, 1.0, 5.0);;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //白色背景
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    
    //填充底部线条
    CGContextAddRect(context, CGRectMake(0, 2, 1, 3));
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 2, 1, 3));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 3, 0) resizingMode:UIImageResizingModeTile] forState:state];
}

@end


