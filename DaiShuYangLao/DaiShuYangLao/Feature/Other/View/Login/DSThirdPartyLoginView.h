//
//  DSThirdPartyLoginView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdPartyItemView;
@class  DSItemModel;

@interface DSThirdPartyLoginView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, copy) void(^ThirdPartyLoginWay)(NSInteger index); /**< index = 1 微信 2 qq 3微博 */

@end


@interface ThirdPartyItemView : UIView

@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * textLabel;

@end

