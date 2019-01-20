//
//  DSMineHeaderView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSUserInfoModel;
@interface DSMineHeaderView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIImageView * userIcon;  /**< 用户头像 */
@property (nonatomic, strong) UILabel * userNameLabel; /**< 用户名 */
@property (nonatomic, strong) UILabel * roleLabel;      /**< 角色身份 */
@property (nonatomic, strong) UILabel * workAgeLabel;
@property (nonatomic, strong) UILabel * extraRoleLabel; /**< 额外身份 */

//@property (nonatomic, strong) UIButton * settingButton;
//@property (nonatomic, strong) UIButton * collectionButton;

@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, copy) ButtonClickHandle settingButtonClickHandle;

@property (nonatomic, strong) DSUserInfoModel * model;

@end
