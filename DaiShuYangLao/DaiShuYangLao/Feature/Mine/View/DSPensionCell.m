//
//  DSPensionCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSPensionCell.h"
#import "DSPensionDetailModel.h"
#import "NSString+MKDate.h"

@implementation DSPensionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellType = 1;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        NSArray * fontSizes = @[JXFont(15),JXFont(10),JXFont(12),JXFont(12)];
        NSArray * textColors = @[JXColorFromRGB(0x000000),JXColorFromRGB(0xa7a7a7),JXColorFromRGB(0x666666),JXColorFromRGB(0x212121)];
        for (NSInteger i=0; i<4; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = fontSizes[i];
            label.textColor = textColors[i];
            if (i==0||i==2) {
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
            
            [self.contentView addSubview:label];
            if(i==0) self.expenseTypeLabel = label;
            if(i==1) self.dateLabel = label;
            if(i==2) self.pensionAmountLabel = label;
            if(i==3) self.expenseAmountLabel = label;
        }
        
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:_seperator];
        
        //变动类型
        [self.expenseTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.top.equalTo(self.contentView.mas_top).with.offset(13-kLabelHeightOffset/2.0);
            make.height.mas_equalTo(15+kLabelHeightOffset);
//            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(145);
        }];
        
        //余额
        [self.pensionAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(_expenseTypeLabel);
            make.height.mas_equalTo(12+kLabelHeightOffset);
            make.top.equalTo(_expenseTypeLabel.mas_bottom).with.offset(4-kLabelHeightOffset);
        }];
        
        //时间
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10+kLabelHeightOffset);
            make.centerY.equalTo(self.expenseTypeLabel.mas_centerY);
            make.width.mas_equalTo(130);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        //金额表动
        [self.expenseAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pensionAmountLabel.mas_centerY);
//            make.centerY.equalTo(self.expenseTypeLabel.mas_centerY).with.offset(12);
            make.width.and.right.equalTo(self.dateLabel);
            make.height.mas_equalTo(12+kLabelHeightOffset);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)setModel:(DSPensionDetailModel *)model{
    NSString * suffix = @"养老备用金";
    if (_cellType==2) {
        suffix = @"购物金";
    }
    
    if (_cellType==3) {
        suffix = @"份";
    }
    
    if (model.type.integerValue==1) {
        if (_cellType==3) {
            self.expenseAmountLabel.text = [NSString stringWithFormat:@"+%.2f%@",model.amount.floatValue,suffix];
        }else{
            self.expenseAmountLabel.text = [NSString stringWithFormat:@"+%.2f%@",model.point.floatValue,suffix];
        }
    }else{
        if (_cellType==3) {
            self.expenseAmountLabel.text = [NSString stringWithFormat:@"-%.2f%@",model.amount.floatValue,suffix];
        }else{
            self.expenseAmountLabel.text = [NSString stringWithFormat:@"-%.2f%@",model.point.floatValue,suffix];
        }
    }
    
    self.expenseTypeLabel.text = model.info;
    self.dateLabel.text = model.date;
    if ([model.subInfo isNotBlank]) {
        self.pensionAmountLabel.text = model.subInfo;
    }else{
        self.pensionAmountLabel.text = @"";
    }
//    self.pensionAmountLabel.text = [NSString stringWithFormat:@"余额：%.2f",model.balance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
