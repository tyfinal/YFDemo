//
//  JXSearchHistoryCell.m
//  JXZX
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JXSearchHistoryCell.h"
#import "JXSearchHotWordModel.h"

@implementation JXSearchHistoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.backgroundImageView];
        
        UIImage * bgImage = ImageString(@"home_search_item_bg");
        [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageView.image = bgImage;
        
        UILabel * label = [[UILabel alloc]init];
        label.font = JXFont(15.0f);
        label.textColor = JXColorFromRGB(0x747474);
        label.textAlignment = NSTextAlignmentCenter;
        self.textLabel = label;
        [self.backgroundImageView addSubview:self.textLabel];
        
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.lineLabel.mas_key = @"line";
        self.lineLabel.hidden = YES;
        [self.backgroundImageView addSubview:self.lineLabel];
        self.lineLabel.backgroundColor = JXColorFromRGB(0xebebeb);
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).with.offset(5);
            make.height.mas_equalTo(14+kLabelHeightOffset);
            make.centerY.equalTo(_backgroundImageView.mas_centerY);
            make.right.equalTo(_backgroundImageView.mas_right).with.offset(-5);
        }];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.and.right.equalTo(_backgroundImageView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setHotWordModel:(JXSearchHotWordModel *)hotWordModel{
    self.textLabel.text = hotWordModel.fullname;
}

@end
