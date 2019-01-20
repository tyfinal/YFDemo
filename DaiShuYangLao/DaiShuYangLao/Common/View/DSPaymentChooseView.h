//
//  DSPaymentChooseView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSItemModel;
@interface DSPaymentChooseView : UIView
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * seperator;
@property (nonatomic, copy) NSString * title;  /**< 标题 */
@property (nonatomic, assign) CGFloat rowHeight;        /**< item的固定行高 */
@property (nonatomic, copy) NSArray <DSItemModel *> * dataArray;
@property (nonatomic, assign) CGFloat maxHeight;        /**< 最大高度 内容超过这个高度允许滑动 */
@property (nonatomic, assign) CGFloat fixedViewHeight;  /**< 固定高度 必须小于等于最大高度  */

@property (nonatomic, copy) void(^DidSelectRowAtIndex)(NSInteger index);

@end

