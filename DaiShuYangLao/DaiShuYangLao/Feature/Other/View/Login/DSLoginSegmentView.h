//
//  DSLoginSegmentView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/24.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonClickBlock)(UIButton * button);
@interface DSLoginSegmentView : UIView

@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * registButton;
@property (nonatomic, copy) buttonClickBlock clickBlock;

@end


@interface UIButton (LoginSegment)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
