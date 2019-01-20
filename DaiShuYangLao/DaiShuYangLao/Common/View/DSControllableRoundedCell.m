//
//  DSMinePensionCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSControllableRoundedCell.h"

@interface DSControllableRoundedCell(){
    
}

@property (nonatomic, strong) UIImage * roundedImage;

@end

static CGFloat const kRadius = 5;

@implementation DSControllableRoundedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.mas_key = @"content";
//        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(6);
            make.right.equalTo(self.mas_right).with.offset(-6);
            make.top.and.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
        
        self.backgroundIV = [[UIImageView alloc]init];
        self.backgroundIV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backgroundIV];
        self.backgroundIV.mas_key = @"backgroundIV";
        [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.topCoverView = [[UIView alloc]initWithFrame:CGRectZero];
        self.topCoverView.backgroundColor = [UIColor whiteColor];
        self.topCoverView.hidden = YES;
        self.topCoverView.mas_key = @"topCoverView";
        [self.contentView addSubview:self.topCoverView];
        
        self.bottomCoverView = [[UIView alloc]initWithFrame:CGRectZero];
        self.bottomCoverView.backgroundColor = [UIColor whiteColor];
        self.bottomCoverView.hidden = YES;
        self.bottomCoverView.mas_key = @"bottomCoverView";
        [self.contentView addSubview:self.bottomCoverView];
        
        [self.topCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kRadius);
        }];
        
        [self.bottomCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kRadius);
        }];
        
        [self.contentView layoutIfNeeded];
        self.backgroundIV.layer.cornerRadius = kRadius;
        self.backgroundIV.layer.masksToBounds = YES;
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
