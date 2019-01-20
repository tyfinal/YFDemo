//
//  DSMinePensionCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSControllableRoundedCell : UITableViewCell

@property (nonatomic, strong) UIImageView * backgroundIV; /**< 设置圆角 */

//通过控制视图的显示与隐藏来控制 是否出现圆角
@property (nonatomic, strong) UIView * topCoverView; /**< 遮住上部分的圆角 */
@property (nonatomic, strong) UIView * bottomCoverView; /**< 遮住下部圆角 */

@property (nonatomic, assign) id model;

@end
