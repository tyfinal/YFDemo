//
//  DSClassificationItem.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/20.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationItem.h"

@interface DSClassificationItem()<UIGestureRecognizerDelegate>{
    
}

@end

@implementation DSClassificationItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.containerView = [[UIView alloc]initWithFrame:CGRectZero];
        self.containerView.backgroundColor = JXColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:self.containerView];
        
        _leftCell = [[HomeGoodsCell alloc]initWithFrame:CGRectZero];
        _leftCell.coverImageView.userInteractionEnabled = YES;
        [self.containerView addSubview:_leftCell];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [_leftCell addSubview:leftButton];
        
        _rightCell = [[HomeGoodsCell alloc]initWithFrame:CGRectZero];
        _rightCell.coverImageView.userInteractionEnabled = YES;
        [self.containerView addSubview:_rightCell];
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [_rightCell addSubview:rightButton];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [@[_leftCell,_rightCell] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
        }];
        
        [@[_leftCell,_rightCell] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_leftCell);
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_rightCell);
        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
     NSLog(@"-->%@",NSStringFromCGRect(self.containerView.frame));
    NSLog(@"-->%@--->%@",NSStringFromCGRect(_leftCell.frame),NSStringFromCGRect(_rightCell.frame));
}

- (void)didSelectItem:(UIButton *)button{
    NSInteger itemIndex = -1;
    DSGoodsInfoModel * model = nil;
    if (button.superview==_leftCell) {
        itemIndex = 0;
        model = _leftCell.model;
    }else if (button.superview==_rightCell){
        itemIndex = 1;
        model = _rightCell.model;
    }
    
    if (self.DidSelectedItemAtIndexPath) {
        self.DidSelectedItemAtIndexPath(itemIndex, model);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
