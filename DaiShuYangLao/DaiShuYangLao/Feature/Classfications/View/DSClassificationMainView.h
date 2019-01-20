//
//  DSClassificationMainView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/27.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSClassificationContentView.h"

@class DSClassificationMainView;

@protocol ClassificationMainViewDelegate<NSObject>

@optional;

/**  滑动翻页 page = -1 上一页 page = 1 下一页 */
- (void)ds_classificationMainView:(DSClassificationMainView *)contentView selectSection:(NSInteger)section;

/** 选中子分类 */
- (void)ds_classificationMainView:(DSClassificationMainView *)contentView didSelectItemaAtIndexPath:(NSIndexPath *)indexPath model:(DSClassificationModel *)model;

@end

@interface DSClassificationMainView : UIView

@property (nonatomic, weak) id<ClassificationMainViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentSelectSection;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;

@end
