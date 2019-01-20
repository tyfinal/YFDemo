//
//  JXTabItemModel.m
//  JXZX
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DSTabItemModel.h"
#import "DSHomeEntranceController.h"
#import "DSClassificationsEntranceController.h"
#import "DSMineEntranceController.h"
#import "DSClassificationEntranceController.h"
#import "DSClassifcationMainController.h"

static NSArray * homeTableItems = nil;

@implementation DSTabItemModel


/** 首页底部tabbar */
+ (NSArray *)createHomeTabItems{
    if (homeTableItems==nil) {
        NSMutableArray * mu = [NSMutableArray array];
        
        NSArray * classes = @[[DSHomeEntranceController class],[DSClassifcationMainController class],[DSMineEntranceController class]];
//        DSClassificationEntranceController
        NSArray * titles = @[@"首页",@"分类",@"我的"];
        
        NSArray * imageNames = @[@"tabbar_home_n",@"tabbar_classification_n",@"tabbar_mine_n"];
        
        NSArray * selectImgNames = @[@"tabbar_home_s",@"tabbar_classification_s",@"tabbar_mine_s"];
        
        for (NSInteger i=0; i<classes.count; i++) {
            DSTabItemModel * itemModel = [[DSTabItemModel alloc]init];
            itemModel.className = classes[i];
            itemModel.title = titles[i];
            itemModel.imageNamed = imageNames[i];
            itemModel.selectedImageNamed = selectImgNames[i];
            [mu addObject:itemModel];
        }
        homeTableItems = mu;
    }
    return homeTableItems;
}


@end
