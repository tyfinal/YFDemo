//
//  DSHomeEntranceActivityPopView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSBannerModel;
@interface DSHomeEntranceActivityPopView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) DSBannerModel * bannerModel;

@end
