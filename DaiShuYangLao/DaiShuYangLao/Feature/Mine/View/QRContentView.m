//
//  QRContentView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "QRContentView.h"

@implementation QRContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        
        UIImage * backImage = ImageString(@"mine_qrcode_bg");
        self.backgroundIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.backgroundIV.image = backImage;
        [self.contentView addSubview:self.backgroundIV];
        
        UIView * qrView = [[UIView alloc]initWithFrame:CGRectZero];;
        [self.backgroundIV addSubview:qrView];
        
        _QRImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [qrView addSubview:_QRImageView];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:ImageString(@"mine_share_qucode") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareQRCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareButton];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
        
        [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(0.81*boundsWidth);
            make.height.mas_equalTo(_backgroundIV.mas_width).multipliedBy(backImage.size.height/backImage.size.width);
            make.centerX.equalTo(self.contentView);
            
        }];
        
        [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundIV);
            make.centerX.equalTo(_backgroundIV.mas_centerX);
            make.width.equalTo(_backgroundIV.mas_width).multipliedBy(0.60);
            make.height.equalTo(_backgroundIV.mas_width).multipliedBy(0.60);
        }];
        
        [_QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(qrView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundIV.mas_bottom);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(boundsWidth*0.93);
            make.height.equalTo(_shareButton.mas_width).multipliedBy(0.22);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
        }];
        
    }
    return self;
}

- (void)shareQRCode:(UIButton *)button{
    if (self.shareQRCodeHandle) {
        self.shareQRCodeHandle(button, self);
    }
}

@end
