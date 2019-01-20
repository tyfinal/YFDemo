//
//  /Users/a/Desktop/袋鼠养老/DaiShuYangLao/DaiShuYangLao.xcodeprojDSCheckOutVIew.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSSafeAreaAdaptBottomView;
@interface DSCheckOutVIew : UIView

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, assign) BOOL edited;

@property (nonatomic, strong) UIButton * checkOutButton;

@property (nonatomic, strong) UIButton * selectAllButton;

@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UIButton * collectionButton;

@property (nonatomic, copy) ButtonClickHandle selectAllButtonClickHandle;

@property (nonatomic, copy) ButtonClickHandle collectionButtonClickHandle;

@property (nonatomic, copy) NSArray * dataArray;  /**< 如果结算时则传待结算的按钮 如果删除或者收藏时传递相关数组 */

@end
