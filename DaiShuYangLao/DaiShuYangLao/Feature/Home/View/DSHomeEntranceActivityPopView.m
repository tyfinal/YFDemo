//
//  DSHomeEntranceActivityPopView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/15.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeEntranceActivityPopView.h"
#import "DSBannerModel.h"
@implementation DSHomeEntranceActivityPopView

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
    
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [_contentView addSubview:_imageView];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:ImageString(@"home_activity_close") forState:UIControlStateNormal];
        [_contentView addSubview:_closeButton];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(0).priorityLow();
        }];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(_contentView.mas_top);
            make.height.equalTo(_contentView.mas_width).multipliedBy(0.98);
//            make.centerY.equalTo(_contentView.mas_centerY);
        }];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(_contentView.mas_centerX);
            make.top.equalTo(_imageView.mas_bottom).with.offset(ceil(55*ScreenAdaptFator_H));
            make.bottom.equalTo(_contentView.mas_bottom).with.offset(-20);
        }];
        
    }
    return self;
}

- (void)setBannerModel:(DSBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.pic] placeholderImage:ImageString(@"public_longpicture_placeholder")];
}


@end
