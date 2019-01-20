//
//  DSWithdrawResultCell.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawResultCell.h"

//static CGFloat cellHeight = 0.0f;
@implementation DSWithdrawResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat fontSize = ceil(18*ScreenAdaptFator_W);
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(fontSize);
        _titleLabel.textColor = JXColorFromRGB(0x282828);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        CGFloat descFontSize = ceil(15*ScreenAdaptFator_W);
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(descFontSize);
        _descLabel.textColor = JXColorFromRGB(0x282828);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_descLabel];
        
        _resultImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _resultImageView.image = ImageString(@"mine_withdraw_result_checking");
        _resultImageView.hidden = YES;
        [self.contentView addSubview:_resultImageView];
        
        self.seperator = [[UIView alloc]init];
        self.seperator.backgroundColor = JXColorFromRGB(0xebebeb);
        [self addSubview:self.seperator];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(ceil(25*ScreenAdaptFator_W));
            make.centerY.equalTo(self.contentView.mas_top).with.offset(24);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(ceil(91*ScreenAdaptFator_W));
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.height.mas_equalTo(20);
            make.right.equalTo(self.contentView.mas_right).with.offset(-20);
            make.left.equalTo(_titleLabel.mas_right);
        }];
        
        [_resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right);
            make.top.right.and.equalTo(self.contentView);
            make.height.equalTo(_resultImageView.mas_width).multipliedBy(0.55);
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
        
    }
    return self;
}

+ (CGFloat)getCellHeight{
    CGFloat imageW = boundsWidth-ceil(25*ScreenAdaptFator_W)-ceil(91*ScreenAdaptFator_W);
    return imageW*0.55;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
