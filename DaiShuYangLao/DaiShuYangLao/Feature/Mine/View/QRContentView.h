//
//  QRContentView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRContentView : UIView

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIImageView * backgroundIV;
@property (nonatomic, strong) UIImageView * QRImageView;
@property (nonatomic, strong) UIButton * shareButton;

@property (nonatomic, copy) ButtonClickHandle shareQRCodeHandle;

@end
