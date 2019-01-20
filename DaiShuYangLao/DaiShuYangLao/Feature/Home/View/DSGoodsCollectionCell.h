//
//  DSGoodsCollectionCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGoodsCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * goodsCoverImageView;
@property (nonatomic, strong) UILabel * goodsNameLabel;
@property (nonatomic, strong) UILabel * goodsPriceLabel;
@property (nonatomic, strong) UIButton * shopcartButton;

@end
