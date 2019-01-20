//
//  DSEditUserInfoCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/22.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSUserInfoModel;

@interface DSEditUserInfoCell : UITableViewCell

@property (nonatomic, strong) DSUserInfoModel * model;
@property (nonatomic, assign) BOOL didSettupLayout;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * avatarIV;
@property (nonatomic, strong) UITextField * inputTF;
@property (nonatomic, strong) UIView * seperator;

@end



