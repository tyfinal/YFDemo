//
//  DSClassificationItem.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/20.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHomeEntranceCell.h"


@interface DSClassificationItem : UITableViewCell

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) HomeGoodsCell * leftCell;
@property (nonatomic, strong) HomeGoodsCell * rightCell;

@property (nonatomic, copy) void(^DidSelectedItemAtIndexPath)(NSInteger itemIndex,DSGoodsInfoModel * model);

@end



