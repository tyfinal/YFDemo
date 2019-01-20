//
//  DSMineTableCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/29.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMineTableCell.h"
#import "DSUserInfoModel.h"
#import "DSMembershipInfoModel.h"
#import <YYImage.h>
#import "DSLaunchConfigureModel.h"

@implementation DSMineTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation MinePensionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSMutableArray * tipsLabelMu = @[].mutableCopy;
        NSArray * tips = @[@"",@"养老备用金",@"消费总额"];
        
        self.section = 2;
        
        _pensionDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_pensionDetailButton];

        _withdrawCashItem = [[OrderItemView alloc]initWithFrame:CGRectZero];
        [_withdrawCashItem.iconIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_withdrawCashItem.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(30, 25));
            make.top.equalTo(@0);
        }];
        _withdrawCashItem.itemNameLabel.text = @"提现";
        _withdrawCashItem.iconIV.image = ImageString(@"mine_withdrawcash");
        [self.contentView addSubview:_withdrawCashItem];
        
        for (NSInteger i=0; i<3; i++) {
            UILabel * tipsLabel = [[UILabel alloc]init];
            tipsLabel.font = JXFont(13);
            tipsLabel.tag = 10+i;
            tipsLabel.textColor = JXColorFromRGB(0x3e3e3e);
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.text = tips[i];
            [tipsLabelMu addObject:tipsLabel];
            [self.contentView addSubview:tipsLabel];
            
            UILabel * contentLabel = [[UILabel alloc]init];
            contentLabel.font = JXFont(17);
            contentLabel.textColor = JXColorFromRGB(0x4d4848);
            contentLabel.textAlignment = NSTextAlignmentCenter;
            contentLabel.text = @"--";
            [self.contentView addSubview:contentLabel];
            if(i==1) {
                _totalPensionLabel = contentLabel;
                tipsLabel.textColor = APP_MAIN_COLOR;
                _totalPensionLabel.textColor = APP_MAIN_COLOR;
            }
            if(i==0){
                _workingAgeLabel = contentLabel;
                tipsLabel.hidden = YES;
                contentLabel.hidden = YES;
            }
            if(i==2) _expenseAmountLabel = contentLabel;
        }
        
        [@[_workingAgeLabel,_totalPensionLabel,_expenseAmountLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).with.offset(22);
            make.height.mas_equalTo(17+kLabelHeightOffset);
        }];
        
        [@[_workingAgeLabel,_totalPensionLabel,_expenseAmountLabel] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        
        __weak typeof (self)weakSelf = self;
        
        [_withdrawCashItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_workingAgeLabel.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(47, 47));
        }];
        
        [tipsLabelMu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView.mas_bottom).with.offset(-17);
            make.height.mas_equalTo(13+kLabelHeightOffset);
        }];
        
        [tipsLabelMu mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        
        [_pensionDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_totalPensionLabel.mas_left).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
            make.right.equalTo(_totalPensionLabel.mas_right);
        }];
        
    }
    return self;
}

- (void)setSection:(NSInteger)section{
    _section = section;
    for (NSInteger i=0; i<3; i++) {
        UILabel * tipsLabel = (UILabel *)[self.contentView viewWithTag:10+i];
        if (_section==2) {
            //积分
            tipsLabel.text = @[@"",@"养老备用金",@"可提数额"][i];
        }else if (_section==3){
            //购物金
             tipsLabel.text = @[@"",@"购物金",@"消费总额"][i];
        }
    }
    if (_section==2) {
        //积分
        _withdrawCashItem.itemNameLabel.text = @"提现";
        _withdrawCashItem.iconIV.image = ImageString(@"mine_withdrawcash");
    }else if (_section==3){
        //购物金
        _withdrawCashItem.itemNameLabel.text = @"签到";
        _withdrawCashItem.iconIV.image = ImageString(@"mine_signin");
    }
}

- (void)setModel:(id)model{
    _totalPensionLabel.text  = @"--";
    _workingAgeLabel.text    = @"--";
    _expenseAmountLabel.text = @"--";
    if (model) {
        if ([model isKindOfClass:[DSUserInfoModel class]]) {
            DSUserInfoModel * userInfoModel = (DSUserInfoModel *)model;
            if (_section==2 ) {
                if ([userInfoModel.point isNotBlank]) {
                    _totalPensionLabel.text = [NSString stringWithFormat:@"%.2f",userInfoModel.availablePoint.floatValue];
                }
                
                if ([userInfoModel.workYears isNotBlank]) {
                    _workingAgeLabel.text = userInfoModel.workYears;
                }
                
                if ([userInfoModel.consumptionAmount isNotBlank]) {
                    _expenseAmountLabel.text = [NSString stringWithFormat:@"%.2f",userInfoModel.canWithdrawPoint.floatValue];
                }
            }else{
                if ([userInfoModel.availableGold isNotBlank]) {
                    _totalPensionLabel.text = [NSString stringWithFormat:@"%.2f",userInfoModel.availableGold.floatValue];
                }
                
                if ([userInfoModel.consumptionAmount isNotBlank]) {
                    _expenseAmountLabel.text = [NSString stringWithFormat:@"%.2f",userInfoModel.consumptionAmount.floatValue];
                }
            }

        }
    }
}

@end



@implementation MineIdentityCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel * tipsLabel = [[UILabel alloc]init];
        tipsLabel.font = JXFont(15);
        tipsLabel.textColor = JXColorFromRGB(0x3e3e3e);
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.text = @"身份识别码";
        [self.contentView addSubview:tipsLabel];
        
        //身份识别码
        _identityCodeLabel = [[UILabel alloc]init];
        _identityCodeLabel.font = JXFont(13);
        _identityCodeLabel.textColor = JXColorFromRGB(0x3e3e3e);
        _identityCodeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_identityCodeLabel];
        
        _inviteLabel = [[UILabel alloc]init];
        _inviteLabel.font = JXFont(15);
        _inviteLabel.text = @"";
        _inviteLabel.textColor = JXColorFromRGB(0x000000);
        _inviteLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_inviteLabel];
        
        //身份识别码
        _rewardLabel = [[UILabel alloc]init];
        _rewardLabel.font = JXFont(10);
        _rewardLabel.text = @"";
        _rewardLabel.textColor = JXColorFromRGB(0xb6b6b6);
        _rewardLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rewardLabel];
        
        _gifImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
        UIImage * image = [YYImage imageNamed:@"mine_share.gif"];
        _gifImageView.image = image;
        [self.contentView addSubview:_gifImageView];
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(15+kLabelHeightOffset);
        }];
        
        [_identityCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipsLabel.mas_right).with.offset(22);
            make.centerY.equalTo(tipsLabel.mas_centerY);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.width.mas_equalTo(80);
        }];
        
        [_inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.right.equalTo(_gifImageView.mas_left).with.offset(-5);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
         
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.right.equalTo(self.inviteLabel);
            make.top.equalTo(_inviteLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(12);
        }];
        
        [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-5);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
//        _arrowIV = [UIImageView im];
    }
    return self;
}

- (void)setModel:(id)model{
    _identityCodeLabel.text = @"";
    _arrowIV.hidden = YES;
    _gifImageView.hidden = YES;
    _rewardLabel.hidden = YES;
    _inviteLabel.hidden = YES;
    if ([model isKindOfClass:[DSUserInfoModel class]]) {
        DSUserInfoModel * userInfoModel = (DSUserInfoModel *)model;
        if ([userInfoModel.invitationCode isNotBlank]) {
            DSLaunchConfigureModel * configure = [DSLaunchConfigureModel configureModel];
            if ([configure.inviteFirstRewardPointMsg isNotBlank]) {
                NSArray * strings = [configure.inviteFirstRewardPointMsg componentsSeparatedByString:@"|"];
                if (strings.count>0) {
                    _inviteLabel.text = strings[0];
                }
                if (strings.count>1) {
                    _rewardLabel.text = strings[1];
                }
            }else{
                _inviteLabel.text = @"";
                _rewardLabel.text = @"";
            }
            _identityCodeLabel.text = userInfoModel.invitationCode;
            _gifImageView.hidden = NO;
            _rewardLabel.hidden = NO;
            _inviteLabel.hidden = NO;
        }
    }
}

@end


@implementation MineOptionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x3e3e3e);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"我的期权";
        [self.contentView addSubview:_titleLabel];
        
        //身份识别码
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = JXFont(14);
        _detailLabel.textColor = JXColorFromRGB(0x4c4c4c);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_detailLabel];
        
        _regulationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regulationButton setImage:ImageString(@"mine_regulation") forState:UIControlStateNormal];
        [self.contentView addSubview:_regulationButton];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(15+kLabelHeightOffset);
        }];
        
        CGFloat detailW = ceil(144*ScreenAdaptFator_W);
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(22);
            make.centerY.equalTo(_titleLabel.mas_centerY);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.width.mas_equalTo(detailW);
        }];
        
        
        [_regulationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            if (boundsWidth<375) {
                make.centerX.equalTo(_detailLabel.mas_right).with.offset(15);
            }else{
                make.centerX.equalTo(_detailLabel.mas_right).with.offset(35*ScreenAdaptFator_W);
            }
            
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(id)model{
    [super setModel:model];
    self.detailLabel.attributedText = [[NSAttributedString alloc]initWithString:@"--"];
    if ([model isKindOfClass:[DSUserInfoModel class]]) {
        DSUserInfoModel * userInfoModel = (DSUserInfoModel *)model;
        if ([userInfoModel.companyOption isNotBlank]) {
            NSString * text = NSStringFormat(@"%ld 份",(long)userInfoModel.companyOption.integerValue);
            NSMutableAttributedString * muAttri = [[NSMutableAttributedString alloc]initWithString:text];
            [muAttri addAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR} range:NSMakeRange(0, userInfoModel.companyOption.length)];
            self.detailLabel.attributedText = muAttri;
        }
    }
}

@end



@interface MineMenbershipInfoCell(){
    
}

@property (nonatomic, strong) UILabel * firstLevelTipsLabel;
@property (nonatomic, strong) UILabel * secondLevelTipsLabel;
@property (nonatomic, strong) UIView * membershipLevelView;
@property (nonatomic, strong) UILabel * levelTipsLabel;
@property (nonatomic, strong) UILabel * teamTipsLabel;

@end


@implementation MineMenbershipInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _levelTipsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _levelTipsLabel.font = JXFont(15);
        _levelTipsLabel.text = @"我的成长值";
        _levelTipsLabel.textColor = JXColorFromRGB(0x3e3e3e);
        _levelTipsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_levelTipsLabel];
        
        _membershipLevelView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_membershipLevelView];
        
        NSMutableArray * starsMu = @[].mutableCopy;
        for (NSInteger i=0; i<5; i++) {
            UIImageView * starIV = [[UIImageView alloc]initWithFrame:CGRectZero];
            starIV.tag = 100+i;
            starIV.image = ImageString(@"mine_menbershiprank_n");
            starIV.mas_key = @"star";
            [_membershipLevelView addSubview:starIV];
            [starsMu addObject:starIV];
        }
        
        _regulationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _regulationButton.hidden = YES;
        [_regulationButton setImage:ImageString(@"mine_regulation") forState:UIControlStateNormal];
        [self.contentView addSubview:_regulationButton];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = JXColorFromRGB(0xeeeee7);
        [self.contentView addSubview:line];
        
        _teamTipsLabel = [[UILabel alloc]init];
        _teamTipsLabel.font = JXFont(13.0);
        _teamTipsLabel.textColor = JXColorFromRGB(0x3e3e3e);
        _teamTipsLabel.textAlignment = NSTextAlignmentLeft;
        _teamTipsLabel.text = @"团队规模：";
        [self.contentView addSubview:_teamTipsLabel];
        
        NSMutableArray * levelTipsMu = @[].mutableCopy;
        for (NSInteger i=0; i<2; i++) {
            UILabel * levelTipsLabel = [[UILabel alloc]init];
            levelTipsLabel.font = JXFont(11);
            levelTipsLabel.textColor = JXColorFromRGB(0xffffff);
            levelTipsLabel.backgroundColor = @[JXColorFromRGB(0xff0202),JXColorFromRGB(0xffa302)][i];
            levelTipsLabel.text = @[@"一级",@"二级"][i];
            levelTipsLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:levelTipsLabel];
            [levelTipsMu addObject:levelTipsLabel];
            if(i==0) _firstLevelTipsLabel = levelTipsLabel;
            if(i==1) _secondLevelTipsLabel = levelTipsLabel;
            
            UILabel * levelLabel = [[UILabel alloc]init];
            levelLabel.font = JXFont(12);
            levelLabel.textColor = JXColorFromRGB(0x4d4848);
            levelLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:levelLabel];
            if(i==0) _firstLevelLabel = levelLabel;
            if(i==1) _secondLevelLabel = levelLabel;
        }
        
        [_firstLevelTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.teamTipsLabel.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.centerY.equalTo(self.teamTipsLabel.mas_centerY);
        }];
        
        [_firstLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstLevelTipsLabel.mas_right).with.offset(12);
            make.centerY.equalTo(self.firstLevelTipsLabel.mas_centerY);
            make.height.mas_equalTo(kLabelHeightOffset+12);
            make.width.mas_equalTo(45);
        }];
        
        [_secondLevelTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.centerY.equalTo(self.teamTipsLabel.mas_centerY);
            make.left.equalTo(self.firstLevelLabel.mas_right).with.offset(20);
        }];
        
        [_secondLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.secondLevelTipsLabel.mas_right).with.offset(12);
            make.centerY.equalTo(self.firstLevelTipsLabel.mas_centerY);
            make.height.mas_equalTo(kLabelHeightOffset+12);
            make.width.mas_equalTo(45);
        }];
        
        [_levelTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).with.offset(26);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.height.mas_equalTo(15+kLabelHeightOffset);
            make.width.mas_equalTo(80);
        }];
        
        CGFloat memberViewH = ceil(26*ScreenAdaptFator_W);
        CGFloat memberViewW = ceil(144*ScreenAdaptFator_W);
        [_membershipLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.levelTipsLabel.mas_right).with.offset(22);
            make.height.mas_equalTo(memberViewH);
            make.centerY.equalTo(self.levelTipsLabel.mas_centerY);
            make.width.mas_equalTo(memberViewW);
        }];
        
        [starsMu mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:memberViewH leadSpacing:0 tailSpacing:0];
        [starsMu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_membershipLevelView.mas_height);
            make.centerY.equalTo(self.membershipLevelView.mas_centerY);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.contentView.mas_top).with.offset(51.5);
        }];
        
        [_teamTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.levelTipsLabel.mas_left);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.width.mas_equalTo(75);
            make.centerY.equalTo(line.mas_bottom).with.offset(29);
        }];
        
        UIImageView * lastStarIV = [_membershipLevelView viewWithTag:100+4];
        [_regulationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            if (boundsWidth<375) {
                make.centerX.equalTo(lastStarIV.mas_right).with.offset(15);
            }else{
                make.centerX.equalTo(lastStarIV.mas_right).with.offset(35*ScreenAdaptFator_W);
            }
            
            make.centerY.equalTo(self.membershipLevelView.mas_centerY).with.offset(2);
        }];
        
    }
    return self;
}

- (void)setModel:(id)model{
    [super setModel:model];
    _firstLevelLabel.text = @"--人";
    _secondLevelLabel.text = @"--人";
    for (NSInteger i=0; i<5; i++) {
        UIImageView * star = [self.contentView viewWithTag:100+i];
        star.image = ImageString(@"mine_menbershiprank_n");
    }
    if ([model isKindOfClass:[DSMembershipInfoModel class]]&&model) {
        DSMembershipInfoModel * membershipModel = (DSMembershipInfoModel *)model;
        NSInteger level = membershipModel.star.integerValue;
        for (NSInteger i=0; i<5; i++) {
            UIImageView * star = [self.contentView viewWithTag:100+i];
            if (level>0&&i<level&&level<6) {
                star.image = ImageString(@"mine_menbershiprank_s");
            }
        }
        if ([membershipModel.inviteFirstNum isNotBlank]) {
            _firstLevelLabel.text = [NSString stringWithFormat:@"%@人",membershipModel.inviteFirstNum];
        }
        
        if ([membershipModel.inviteSecondNum isNotBlank]) {
            _secondLevelLabel.text = [NSString stringWithFormat:@"%@人",membershipModel.inviteSecondNum];
        }
    }
}

@end


@interface MineOrderInfoCell(){
    
}

@property (nonatomic, strong) UIView * orderStatusView;

@end

@implementation MineOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * myorderTipsLabel = [[UILabel alloc]init];
        myorderTipsLabel.font = JXFont(15);
        myorderTipsLabel.text = @"我的订单";
        myorderTipsLabel.textColor = JXColorFromRGB(0x3e3e3e);
        myorderTipsLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:myorderTipsLabel];
        
        _allOrdersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allOrdersButton setTitle:@"查看更多订单" forState:UIControlStateNormal];
        [_allOrdersButton addTarget:self action:@selector(viewOnAllOrder) forControlEvents:UIControlEventTouchUpInside];
        [_allOrdersButton setImage:ImageString(@"public_rightarrow") forState:UIControlStateNormal];
        _allOrdersButton.titleLabel.font = JXFont(13);
        [_allOrdersButton setImagePosition:LXMImagePositionRight spacing:5];
        [_allOrdersButton setTitleColor:JXColorFromRGB(0x939393) forState:UIControlStateNormal];
        [self.contentView addSubview:_allOrdersButton];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectZero];
        line.backgroundColor = JXColorFromRGB(0xeeeee7);
        [self.contentView addSubview:line];
    
        self.orderStatusView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.orderStatusView];
        
        NSArray * itemNames = @[@"待付款",@"待发货",@"待收货",@"退款/售后"];
        NSArray * itemIconNames = @[@"mine_waitingfor_payment",@"mine_watingfor_delivery",@"mine_waitingfor_receving",@"mine_refund"];
        NSMutableArray * items = @[].mutableCopy;
        for (NSInteger i=0; i<itemNames.count; i++) {
            OrderItemView * itemView = [[OrderItemView alloc]initWithFrame:CGRectZero];
            itemView.iconIV.image = ImageString(itemIconNames[i]);
            itemView.itemNameLabel.text = itemNames[i];
            itemView.tag = 100+i;
            UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItemWithRecognizer:)];
            [itemView addGestureRecognizer:ges];
            [self.orderStatusView addSubview:itemView];
            [items addObject:itemView];
        }
        
        [myorderTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.width.mas_equalTo(80);
            make.centerY.equalTo(self.contentView.mas_top).with.offset(18.5);
            make.height.mas_equalTo(15+kLabelHeightOffset);
        }];
        
        [_allOrdersButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 30));
            make.centerY.equalTo(myorderTipsLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.contentView.mas_top).with.offset(37);
        }];
        
        [self.orderStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(line.mas_bottom);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        
        [items mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderStatusView.mas_top);
            make.bottom.equalTo(self.orderStatusView.mas_bottom);
        }];
    }
    return self;
}

- (void)setModel:(id)model{
    if ([model isKindOfClass:[DSMembershipInfoModel class]]) {
        DSMembershipInfoModel * membershipModel = (DSMembershipInfoModel *)model;
        for (NSInteger i=0; i<4; i++) {
            OrderItemView * itemView = (OrderItemView *)[self.orderStatusView viewWithTag:100+i];
            
            itemView.badgeLabel.hidden = YES;
            if (membershipModel.orderNum.count>i) {
                NSNumber * badge = membershipModel.orderNum[i];
                if (badge.integerValue>0) {
                    itemView.badgeLabel.hidden = NO;
                    itemView.badgeLabel.text = [NSString stringWithFormat:@"%@",badge];
                }
            }
        }
    }
}

- (void)viewOnAllOrder{
    if (self.viewAllOrderHandle) {
        self.viewAllOrderHandle(self.allOrdersButton, self);
    }
}

- (void)clickItemWithRecognizer:(UITapGestureRecognizer *)ges{
    NSInteger index = ges.view.tag-100;
    if (self.OrderClickHandle) {
        self.OrderClickHandle(index);
    }
}

@end



@implementation MineAdvertisementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.adverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.adverImageView.image = [UIColor colorfulImage];
        [self.contentView addSubview:self.adverImageView];
        
        [self.adverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}


@end



@implementation OrderItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconIV];
        
        _itemNameLabel = [[UILabel alloc]init];
        _itemNameLabel.font = JXFont(13);
        _itemNameLabel.textColor = JXColorFromRGB(0x6d6d6d);
        _itemNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_itemNameLabel];
        
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.backgroundColor = [UIColor whiteColor];
        _badgeLabel.font = JXFont(11);
        _badgeLabel.text = @"5";
        _badgeLabel.textColor = JXColorFromRGB(0xff7c34);
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLabel];
        
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(17);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [_itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).with.offset(7.5-kLabelHeightOffset/2.0);
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.height.mas_equalTo(13+kLabelHeightOffset);
        }];
        
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
            make.centerY.equalTo(self.iconIV.mas_top).with.offset(0);
            make.centerX.equalTo(self.iconIV.mas_right);
            make.right.lessThanOrEqualTo(self.mas_right).with.offset(-5).priorityLow();
            make.width.mas_greaterThanOrEqualTo(18);
        }];
        
        [self layoutIfNeeded];
        
        _badgeLabel.layer.cornerRadius = 18/2.0f;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.hidden = YES;
        _badgeLabel.layer.borderColor = JXColorFromRGB(0xff7c34).CGColor;
        _badgeLabel.layer.borderWidth = 1.0f;
        
        
    }
    return self;
}


@end




