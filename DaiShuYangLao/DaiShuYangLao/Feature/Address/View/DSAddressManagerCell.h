//
//  DSAddressManagerCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSUserAddress;
@interface DSAddressManagerCell : UITableViewCell


@property (nonatomic, strong) UILabel * userNameLabel;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIButton * defaultAddressButton;
@property (nonatomic, strong) UIButton * editButton;
@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UILabel * line;
@property (nonatomic, copy) ButtonClickHandle addressButtonClickHandle;
@property (nonatomic, strong) DSUserAddress * addressModel;
@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void(^UpdateAddressDefaultStatusHandle)(NSIndexPath * aIndexPath,DSUserAddress * addressModel);


@end
