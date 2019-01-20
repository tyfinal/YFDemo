//
//  YJGoodsNumberStepperView.h
//  YJRRT
//
//  Created by keiyi on 16/5/17.
//  Copyright © 2016年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class YJCartGoodsModel;

typedef void(^GoodsNumberChangeBlock)(NSString * goodsNum);
@interface YJGoodsNumberStepperView : UIView

@property (nonatomic, strong) UITextField * goodsNumberLabel;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, copy) NSString * goodsNumber;
//@property (nonatomic, strong) YJCartGoodsModel * goodsModel;
@property (nonatomic, copy) GoodsNumberChangeBlock goodsNumberChangeBlock;

- (void)refreshStateWithGoodsNumber:(GoodsNumberChangeBlock)block;

@end
