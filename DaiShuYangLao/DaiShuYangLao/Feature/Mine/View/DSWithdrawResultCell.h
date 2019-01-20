//
//  DSWithdrawResultCell.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSWithdrawResultCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * resultImageView;
@property (nonatomic, strong) UIView * seperator;

+ (CGFloat)getCellHeight;

@end
