//
//  DSClassificationCollectionCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationCollectionCell.h"
#import "DSClassificationModel.h"
@interface DSClassificationCollectionCell(){
    
}
@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation DSClassificationCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        
        _titleLabel = [[UILabel alloc]init];
        CGFloat fontSize = floor(15*ScreenAdaptFator_W);
        _titleLabel.font = JXFont(fontSize);
        _titleLabel.textColor = JXColorFromRGB(0x454545);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.imageView.mas_bottom).with.offset(7);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.height.mas_equalTo(19);
        }];
        _didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setModel:(DSClassificationModel *)model{
    _titleLabel.text = model.name;
    if ([model.icon isNotBlank]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    }else{
        _imageView.image = ImageString(@"public_clearbg_placeholder");
    }

}

@end
