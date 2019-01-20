//
//  DSCacheManager.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/3.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSCacheManager : DSBaseModel

/**
 删除文件夹所有文件
 
 @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath callback:(completeBlock)block;

/**
 获取文件夹尺寸
 
 @param directoryPath 文件夹路径
 @param completion 文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion;

+ (NSString *)transformByteIntoMegaByte:(NSInteger)fileSize;

@end
