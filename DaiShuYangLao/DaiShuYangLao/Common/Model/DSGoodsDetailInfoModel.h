//
//  DSGoodsDetailInfoModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@class GoodsDetailSaleInfo;
@class DSBrandModel;
@class GoodsDetailContentModel;

@interface DSGoodsDetailInfoModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * goods_id;       //id
@property (nonatomic, copy) NSString * name;           //名称
@property (nonatomic, copy) NSString * price;          //价格
@property (nonatomic, copy) NSString * sellNum;        //销量
@property (nonatomic, copy) NSString * minPic;         //商品小图，列表页使用
@property (nonatomic, strong) DSBrandModel * brand;          //品牌
@property (nonatomic, copy) NSString * info;           // 营销信息
@property (nonatomic, copy) NSString * status;         //0=下架，1=销售
@property (nonatomic, copy) NSString * inventoryNum;   //库存
@property (nonatomic, copy) NSArray * pics;           //商品图
@property (nonatomic, copy) NSArray * properties;     //商品规格
@property (nonatomic, copy) NSArray * contents;       //商品描述
@property (nonatomic, copy) NSArray * skus;            //销售属性
@property (nonatomic, copy) NSString * merchantName;   //商户
@property (nonatomic, copy) NSString * originalPrice;  //原价
@property (nonatomic, copy) NSString * specification;
@property (nonatomic, copy) NSString * isLike;
@property (nonatomic, copy) NSString * useGold;  //购物金 >0 表示可用
@property (nonatomic, copy) NSString * isExclusive;  /**< 0普通产品 1新人未购买 2当前用户不是新手 */
@property (nonatomic, copy) NSString * serviceFlag;  /**< 是否是服务型 0否 1是 */
@property (nonatomic, copy) NSString * usePoint;     /**< 商品可允许使用的积分 不为0的时候表示可用 */
@property (nonatomic, copy) NSString * pointUseType; /**< 0不适用积分 1全部使用积分 2使用部分积分 */

//普通会员不能购买 也不能加入购物车
@property (nonatomic, copy) NSString * special; /**< 1 是领航会员专属商品 0 不是领航专属 */

//额外添加的属性
@property (nonatomic, assign) NSInteger buyNumber;     //购买量
@property (nonatomic, assign) BOOL selected;

@end

@interface GoodsDetailSaleInfo : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * sku_id;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * price;          //价格
@property (nonatomic, copy) NSString * inventoryNum;   //库存
@property (nonatomic, copy) NSString * originalPrice;

/** 额外信息 */
@property (nonatomic, assign) BOOL selected; /**< 标示选中属性 */

@end


@interface GoodsPropertyModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * property_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * value;

@end

@interface GoodsDetailContentModel : DSBaseModel<NSCoding>

@property (nonatomic, copy) NSString * type;  /**< 0 时content为文本 1时 content为图片 */
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) CGFloat cellH;

@end





