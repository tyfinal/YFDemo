//
//  DSEmptyDataCustomView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSEmptyDataCustomView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * emptyImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * button;

@property (nonatomic, copy) ButtonClickHandle EmptyDataButtonClickHandle;

@end
