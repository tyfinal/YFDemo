//
//  DSCashAmountChooseCell.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSCashAmountChooseCell;
@class ChooseAmountItem;
@class ChoosetAmountSectionHeaderView;
@interface DSCashAmountChooseCell : UITableViewCell

@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) void(^DidSelectedItemAtIndexPath)(NSIndexPath *indexPath,NSDecimalNumber * number);


+ (CGFloat)getCellHeightWithDataArray:(NSArray *)dataArrray;

@end


@interface ChooseAmountItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView * containterView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UIView * selectedFlag;

@end


@interface ChoosetAmountSectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * textLabel;

@end

