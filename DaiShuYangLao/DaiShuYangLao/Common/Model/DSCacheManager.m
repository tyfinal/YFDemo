//
//  DSCacheManager.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/3.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCacheManager.h"

@implementation DSCacheManager


+ (void)removeDirectoryPath:(NSString *)directoryPath callback:(completeBlock)block{
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectoey;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectoey];
    
    if (!isExist || !isDirectoey) {
        NSException *exception = [NSException exceptionWithName:@"PathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        [exception raise];
    }
    //获取cache文件夹下所有文件，不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *subPath in subPaths) {
            if ([subPath isEqualToString:@"Snapshots"]) {
                continue;
            }
            //拼接完整路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            //删除路径
            [mgr removeItemAtPath:filePath error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil,YES,nil);
            }
        });
    });
}

+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion {
    NSFileManager *mgr =[NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExist) {
        NSException *exception = [NSException exceptionWithName:@"PathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        [exception raise];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取文件夹下所有文件，包括子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger totalSize = 0;
        for (NSString *subPath in subPaths) {
            //获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            //判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            //判断是否文件夹
            BOOL isDircetory;
            
            //判断文件是否存在，并判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDircetory];
            if (isDircetory || !isExist) continue;
            
            //获取文件属性
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            NSInteger size = [attr fileSize];
            
            totalSize += size;
        }
        
        //计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}

+ (NSString *)transformByteIntoMegaByte:(NSInteger)fileSize{
    NSInteger totalSize = fileSize;
    NSString * sizeStr = @"0B";
    if (totalSize > 1000 * 1000) {
        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%.1fMB", sizeF];
    } else if (totalSize > 1000) {
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%.1fKB", sizeF];
    } else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%ldB)" ,(long)totalSize];
    }
    return sizeStr;
}

//- (NSString *)cacheSizeStr {
//    NSInteger totalSize = _totalSize;
//    NSString *sizeStr = @"清除缓存";
//    if (totalSize > 1000 * 1000) {
//        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
//        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
//    } else if (totalSize > 1000) {
//        CGFloat sizeF = totalSize / 1000.0;
//        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];
//    } else if (totalSize > 0) {
//        sizeStr = [NSString stringWithFormat:@"%@(%.ldB)", sizeStr, totalSize];
//    }
//    return sizeStr;
//}

@end
