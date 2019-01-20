//
//  DSGoodsCollectionCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsCollectionCell.h"

@implementation DSGoodsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //封面图
        _goodsCoverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_goodsCoverImageView];
        
        //标题
        _goodsNameLabel = [[UILabel alloc]init];
        _goodsNameLabel.font = JXFont(14);
        _goodsNameLabel.textColor = JXColorFromRGB(0x333333);
        _goodsNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_goodsNameLabel];
        
//        //价格
//        _goodsPriceLabel = [[UILabel alloc]init];
//        _goodsPriceLabel.font = <#fontSize#>;
//        _goodsPriceLabel.textColor = <#textColor#>;
//        _goodsPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
