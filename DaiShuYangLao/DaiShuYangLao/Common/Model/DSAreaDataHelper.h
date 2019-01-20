//
//  DSAreaDataHelper.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
@class DSAreaModel;
@interface DSAreaDataHelper : DSBaseModel

+ (instancetype)shareInstance;

- (void)saveAreaList:(NSData *)areaListData;   /**< 保存地址 */

- (NSData *)getAreaData; /**< 获取地址列表 */

- (NSArray <DSAreaModel *> *)getAreaArray;

@end
