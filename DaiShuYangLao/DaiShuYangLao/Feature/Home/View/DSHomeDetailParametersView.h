//
//  DSHomeDetailParameters.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSGoodsDetailInfoModel;

@interface DSHomeDetailParametersView : UIView

@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, copy) NSArray <GoodsPropertyModel *> * dataArray;

@end


