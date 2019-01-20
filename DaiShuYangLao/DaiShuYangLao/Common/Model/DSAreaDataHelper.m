//
//  DSAreaDataHelper.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSAreaDataHelper.h"
#import "DSAreaModel.h"

#define kAreaListPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/arealist.txt"]

static DSAreaDataHelper * areaDataHelper = nil;
@implementation DSAreaDataHelper

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaDataHelper = [[DSAreaDataHelper alloc]init];
    });
    return areaDataHelper;
}

/**< 保存地址 */
- (void)saveAreaList:(NSData *)areaListData{
    NSString * path = kAreaListPath;
    if (!areaListData) {
        //无数据时 默认从本地拉取
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSString * localPath = [[NSBundle mainBundle]pathForResource:@"arealist" ofType:@"txt"];
            NSData * localData = [NSData dataWithContentsOfFile:localPath];
            [localData writeToFile:kAreaListPath atomically:YES];
        }
    }else{
        [areaListData writeToFile:path atomically:YES];
    }
}

/**< 获取地址列表 */
- (NSData *)getAreaData{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSData * areaData = [NSData dataWithContentsOfFile:kAreaListPath];
    if (!areaData) {
        if (![fileManager fileExistsAtPath:kAreaListPath]) {
            NSString * localPath = [[NSBundle mainBundle]pathForResource:@"arealist" ofType:@"txt"];
            NSData * localData = [NSData dataWithContentsOfFile:localPath];
            [localData writeToFile:kAreaListPath atomically:YES];
            areaData = localData;
        }else{
            areaData = [NSData dataWithContentsOfFile:kAreaListPath];
        }
    }
    return areaData;
}

- (NSArray <DSAreaModel *> *)getAreaArray{
    NSData * data = [self getAreaData];
    NSJSONSerialization * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray * areaListArray = [DSAreaModel mj_objectArrayWithKeyValuesArray:json];
    return areaListArray;
}

@end
