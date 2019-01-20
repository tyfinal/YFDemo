//
//  DSClassificationContentView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSClassificationModel;
@class ClassificationContentItem;
@class DSClassificationContentView;

@protocol ClassificationContentViewDelegate<NSObject>

@optional;

/**  滑动翻页 page = -1 上一页 page = 1 下一页 */
- (void)ds_classificationContentView:(DSClassificationContentView *)contentView loadPage:(NSInteger)page;

/** 选中子分类 */
- (void)ds_classificationContentView:(DSClassificationContentView *)contentView didSelectItemaAtIndexPath:(NSIndexPath *)indexPath model:(DSClassificationModel *)model;

@end

@interface DSClassificationContentView : UIView
@property (nonatomic, assign) NSInteger currentSelectSection;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, weak) id<ClassificationContentViewDelegate> delegate;

@end

@interface ClassificationContentItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView * coverIV;
@property (nonatomic, strong) UILabel * classificationNameLabel;



@property (nonatomic, strong) DSClassificationModel * classificationModel;



+ (CGFloat)getItemHeightWithItemWidth:(CGFloat)itemWidth;

@end

@interface ClassificationContentSectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * sectionTitleLabel;

@property (nonatomic, strong) DSClassificationModel * classificationModel;

@end

