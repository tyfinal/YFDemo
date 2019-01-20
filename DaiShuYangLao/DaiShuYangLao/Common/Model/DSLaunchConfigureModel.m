//
//  DSLaunchConfigureModel.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSLaunchConfigureModel.h"
#define DSLaunchConfigurePath @"launchconfigure.archive"
@implementation DSLaunchConfigureModel


MJCodingImplementation

+ (void)saveConfigureModel:(DSLaunchConfigureModel *)configureModel{
    if (configureModel) {
        // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
        NSString * filePath = [DS_DOCUMENTSSPATH_DIRECTORY stringByAppendingPathComponent:DSLaunchConfigurePath];
        BOOL saveSucceed = [NSKeyedArchiver archiveRootObject:configureModel toFile:filePath];
        if (saveSucceed==NO) {
            //存储失败
        }
    }
}

+  (DSLaunchConfigureModel *)configureModel{
    NSString * filePath = [DS_DOCUMENTSSPATH_DIRECTORY stringByAppendingPathComponent:DSLaunchConfigurePath];
    DSLaunchConfigureModel * configureModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return configureModel;
}

@end


@implementation LaunchConfigureAreaModel
MJCodingImplementation
@end


@implementation LaunchConfigureUpgradeModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"desc":@"description"};
}

@end
