//
//  DSGoodsInfoModel.h
//  KyBook
//
//  Created by tyfinal on 2018/6/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DSBaseModel.h"

@class BrandModel;

@interface DSGoodsInfoModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * name;          //名称
@property (nonatomic, copy) NSString * price;         //价格
@property (nonatomic, copy) NSString * minPic;        //商品小图，列表页使用
@property (nonatomic, strong) BrandModel * brand;        //品牌
@property (nonatomic, copy) NSString * info;          //营销信息
@property (nonatomic, copy) NSString * info1;
@property (nonatomic, copy) NSString * sellNum;       //销量
@property (nonatomic, copy) NSString * status;        //0=下架，1=销售中
@property (nonatomic, copy) NSString * inventoryNum;  //库存
@property (nonatomic, copy) NSString * specification; //规格
@property (nonatomic, copy) NSString * special;       //是否为会员专属商品  为1 YES  0 NO
@property (nonatomic, copy) NSString * useGold;       //购物金

//extra 额外信息
@property (nonatomic, assign) NSInteger buynumber;    //购买的数量

@property (nonatomic, assign) BOOL selected;          //选中标识


@end


@interface BrandModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * brand_id;
@property (nonatomic, copy) NSString * logo;
@property (nonatomic, copy) NSString * name;

@end



