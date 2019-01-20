//
//  DSClassficationDetailCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassficationDetailCell.h"
#import "DSGoodsInfoModel.h"
@interface DSClassficationDetailCell(){
    
}

@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation DSClassficationDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = JXColorFromRGB(0xf4f4f4);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.coverImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(14.0);
        _titleLabel.textColor = JXColorFromRGB(0x5d5d5d);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(13);
        _descLabel.textColor = JXColorFromRGB(0x5d5d5d);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_descLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = APP_MAIN_COLOR;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
        
        _salesAmountLabel = [[UILabel alloc]init];
        _salesAmountLabel.font = JXFont(11);
        _salesAmountLabel.textColor = JXColorFromRGB(0x9d9d9d);
        _salesAmountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_salesAmountLabel];
        
        _progressView = [[ClassificationDetailProgressView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_progressView];
        
        _shoppingcartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingcartButton setImage:ImageString(@"public_shoppingcar") forState:UIControlStateNormal];
        [_shoppingcartButton addTarget:self action:@selector(addToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        _shoppingcartButton.hidden = YES;
        [self.contentView addSubview:_shoppingcartButton];

        _rewardImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rewardImageView.image = ImageString(@"home_reward_bg");
        [self.contentView addSubview:_rewardImageView];
        
        _rewardLabel = [[UILabel alloc]init];
        _rewardLabel.font = JXFont(10);
        _rewardLabel.textColor = APP_MAIN_COLOR;
        _rewardLabel.textAlignment = NSTextAlignmentCenter;
        [_rewardImageView addSubview:_rewardLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(-3).priorityLow();
        }];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 108));
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.left.equalTo(self.contentView);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-45);
            make.centerY.equalTo(_coverImageView.mas_top).with.offset(7);
            make.left.equalTo(_coverImageView.mas_right).with.offset(10);
            make.height.mas_equalTo(14+kLabelHeightOffset);
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_titleLabel);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(23-kLabelHeightOffset);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.centerY.equalTo(_coverImageView.mas_bottom).with.offset(-6.5);
        }];
        
        [_salesAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(_priceLabel.mas_right).with.offset(7);
            make.height.mas_equalTo(11+kLabelHeightOffset);
            make.centerY.equalTo(_priceLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(90);
            make.centerY.equalTo(_priceLabel.mas_centerY).with.offset(-10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_shoppingcartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.centerX.equalTo(self.contentView.mas_right).with.offset(-27);
            make.centerY.equalTo(self.contentView.mas_bottom).with.offset(-30);
        }];
        
        [_rewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(19);
            make.left.equalTo(_priceLabel.mas_left);
            make.top.equalTo(_descLabel.mas_bottom).with.offset(8);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14);
            make.centerY.equalTo(_rewardImageView.mas_centerY);
            make.left.equalTo(_rewardImageView.mas_left).with.offset(5);
            make.right.equalTo(_rewardImageView.mas_right).with.offset(-5);
        }];
        
        _didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setModel:(DSGoodsInfoModel *)model{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    self.titleLabel.text = model.name;
    _descLabel.text = model.specification;
    _salesAmountLabel.textColor = JXColorFromRGB(0x9d9d9d);
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
    _salesAmountLabel.text = [NSString stringWithFormat:@"月销%ld笔",(long)model.sellNum.integerValue];
    _progressView.hidden = YES;
    _salesAmountLabel.hidden = NO;
    _rewardImageView.hidden = YES;
    if ([model.info1 isNotBlank]) {
        _rewardImageView.hidden = NO;
        model.info1 = model.info1;
    }
    
    _rewardLabel.text = model.info1;
    if (model.special.boolValue==YES) {
        if(model.inventoryNum.integerValue==0){
            _salesAmountLabel.textColor = APP_MAIN_COLOR;
          _salesAmountLabel.text = @"已售罄";
        }else{
            _salesAmountLabel.hidden = YES;
            _progressView.hidden = NO;
            _progressView.goodsModel = model;
        }
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)addToShoppingCart{
    if (self.SaveGoodsToShoppingCartHandle) {
        self.SaveGoodsToShoppingCartHandle(nil, _model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation ClassificationDetailProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.progressTintColor = APP_MAIN_COLOR;
        self.progressView.trackTintColor = JXColorFromRGB(0xcecece);
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self addSubview:self.progressView];
        
        self.progressLabel = [[UILabel alloc]init];
        self.progressLabel.font = JXFont(13);
        self.progressLabel.textColor = JXColorFromRGB(0x666666);
        self.progressLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.progressLabel];
        
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.height.mas_equalTo(13+kLabelHeightOffset);
            make.top.equalTo(self);
            make.bottom.equalTo(_progressView.mas_top).with.offset(-3).priorityLow();
        }];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setGoodsModel:(DSGoodsInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    if (goodsModel.inventoryNum.integerValue>0) {
        _progressLabel.font = JXFont(10.0f);
        _progressView.hidden = NO;
        NSInteger totalAmount = 100;
        _progressLabel.text = [NSString stringWithFormat:@"还剩%ld件",(long)goodsModel.inventoryNum.integerValue];
        if (totalAmount>0) {
           _progressView.progress = goodsModel.inventoryNum.floatValue/totalAmount;
        }else{
            _progressView.progress = 1.0f;
        }
    }
    [self setNeedsUpdateConstraints];
}

@end



