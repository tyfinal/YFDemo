//
//  DSClassficationSelectView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSClassificationModel;
@class DSClassficationSelectView;

@protocol ClassificationSelectViewDelegate <NSObject>

@optional;

- (void)ds_classificationSelectView:(DSClassficationSelectView *)selectView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withClassificationModel:(DSClassificationModel *)classificationModel;


@end

@interface DSClassficationSelectView : UIView

@property (nonatomic, strong) UITableView * categoryTableView;
@property (nonatomic, assign) CGFloat itemHeight;         /**< 行高 */
@property (nonatomic, assign) NSInteger currentSelectRow; /**< 当前选中行 */
@property (nonatomic, weak) id <ClassificationSelectViewDelegate> delegate;
@property (nonatomic, strong) NSArray * dataArray;

@end

@interface ClassificationSelectCell : UITableViewCell

@property (nonatomic, strong) DSClassificationModel * classificationModel;

@end
