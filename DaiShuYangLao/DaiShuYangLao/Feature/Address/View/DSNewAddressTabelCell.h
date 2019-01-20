//
//  DSNewAddressTabelCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSTextFieldModel;
@interface DSNewAddressTabelCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellType;   /**< 1 contentTF与title  2 title与switch */
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * contentTF;
@property (nonatomic, strong) UILabel * lineLabel;
@property (nonatomic, strong) UISwitch * addressSwitch;
@property (nonatomic, strong) DSTextFieldModel * model;

@end
