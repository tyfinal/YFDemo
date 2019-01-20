//
//  DSGoodeDetailBottomView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSGoodeDetailBottomView;
@class DSGoodsDetailInfoModel;
@protocol GoodsDetailBottomViewDelegate<NSObject>

@optional

/*
 * 点击了立即购买 或者 加入购物车
 * buttonIndex -> 0 立即购买 1加入购物车
 */
- (void)ds_goodsDetailBottomView:(DSGoodeDetailBottomView *)bottomView clickBuyButtonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button;

/*
 * 点击收藏 客服 以及 回首页
 * buttonIndex -> 0 超市 1客服 2收藏
 */
- (void)ds_goodsDetailBottomView:(DSGoodeDetailBottomView *)bottomView clickOperationbuttonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button;

@end


@interface DSGoodeDetailBottomView : UIView

@property (nonatomic, weak) id <GoodsDetailBottomViewDelegate> delegate;
@property (nonatomic, strong) UIButton * collectionButton;
@property (nonatomic, strong) DSGoodsDetailInfoModel * goodsModel;

@end
