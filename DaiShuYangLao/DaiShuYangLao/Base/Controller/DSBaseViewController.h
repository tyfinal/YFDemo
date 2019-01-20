//
//  DSBaseViewController.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSBannerModel;
typedef void(^BackButtonHandle)(void);
@interface DSBaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem * backItem;
@property (nonatomic, assign) BOOL hidenBackBarItem;            /**< 隐藏返回按钮 默认为NO*/
@property (nonatomic, copy)   BackButtonHandle backButtonHandle; /**< 需要手动返回上层界面时调用 */

@property (nonatomic, assign) BOOL needChangeStatusBarStyle;

@property (nonatomic) id ds_universal_params;  /** 通用参数 可以不传 */

//设置导航条透明
- (void)changeNavigationBarTransparent:(BOOL)tranparent;

/** 是否需要引导用户去升级会员 */
- (BOOL)shouldGuidaUserToUpgradeMembershipWithGoodsModel:(id)model;

/**< banner跳转事件 */
- (void)bannerClickEventHandle:(DSBannerModel *)bannerModel;


@end
