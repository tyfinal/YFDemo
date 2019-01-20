//
//  DSUserAddress.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@class DSAreaModel;
@interface DSUserAddress : DSBaseModel

@property (nonatomic, copy) NSString * address_id;
@property (nonatomic, copy) NSString * name;      //用户姓名
@property (nonatomic, copy) NSString * phone;     //用户手机号
@property (nonatomic, copy) NSString * address;   //地址
@property (nonatomic, copy) NSString * postcode;  //邮编
@property (nonatomic, strong) DSAreaModel * province;  //省
@property (nonatomic, strong) DSAreaModel * city;      //市
@property (nonatomic, strong) DSAreaModel * district;  //区县
@property (nonatomic, copy) NSString * def;       //是否默认是默认地址，0=否，1=是


@end
