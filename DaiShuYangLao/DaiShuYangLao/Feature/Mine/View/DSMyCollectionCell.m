//
//  DSMyCollectionCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyCollectionCell.h"


@interface DSMyCollectionCell(){
    
}

@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation DSMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _edited = NO;
        
        self.backgroundColor = JXColorFromRGB(0xffffff);
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectZero];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containerView];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_selectButton setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.hidden = YES;
        [self.contentView addSubview:_selectButton];

        
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.containerView addSubview:self.coverImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(14.0);
        _titleLabel.textColor = JXColorFromRGB(0x5d5d5d);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.containerView addSubview:_titleLabel];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = JXFont(13);
        _descLabel.textColor = JXColorFromRGB(0x5d5d5d);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self.containerView addSubview:_descLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = APP_MAIN_COLOR;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.containerView addSubview:_priceLabel];
        
        _salesAmountLabel = [[UILabel alloc]init];
        _salesAmountLabel.font = JXFont(11);
        _salesAmountLabel.textColor = JXColorFromRGB(0x9d9d9d);
        _salesAmountLabel.textAlignment = NSTextAlignmentLeft;
        [self.containerView addSubview:_salesAmountLabel];
        
        _shoppingcartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingcartButton setImage:ImageString(@"public_shoppingcar") forState:UIControlStateNormal];
        [_shoppingcartButton addTarget:self action:@selector(addToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_shoppingcartButton];
        
        _shopCartClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopCartClearButton.backgroundColor = [UIColor clearColor];
        [_shopCartClearButton addTarget:self action:@selector(addToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_shopCartClearButton];
        
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xf4f4f4);
        [self.containerView addSubview:_seperator];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        
    }
    return self;
}

- (void)updateConstraints{
    if (!_didSetupLayout) {
        
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(self.contentView.mas_left).with.offset(30);
            make.centerY.equalTo(self.contentView.mas_top).with.offset(70);
        }];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 108));
            make.top.equalTo(self.containerView.mas_top).with.offset(16);
            make.left.equalTo(self.containerView);
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
            make.left.equalTo(_priceLabel.mas_right).with.offset(7);
            make.height.mas_equalTo(11+kLabelHeightOffset);
            make.centerY.equalTo(_priceLabel.mas_centerY);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-45);
        }];
        
        [_shoppingcartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.centerX.equalTo(self.containerView.mas_right).with.offset(-27);
            make.centerY.equalTo(self.containerView.mas_bottom).with.offset(-30);
        }];
        
        [_shopCartClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_shoppingcartButton).with.insets(UIEdgeInsetsMake(-10, -10, -10, -10));
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.left.and.right.equalTo(self.containerView);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];
        
        _didSetupLayout = YES;
    }
    
    if (_edited) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(55);
        }];
    }else{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
        }];
    }
    
    [super updateConstraints];
}

- (void)setModel:(DSGoodsDetailInfoModel *)model{
    _model = model;
    _selectButton.selected = model.selected;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    self.titleLabel.text = model.name;
    _descLabel.text = model.info;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
    _salesAmountLabel.text = [NSString stringWithFormat:@"月销%ld笔",(long)model.sellNum.integerValue];
}

- (void)selectItem:(UIButton *)button{
    if (_edited) {
        button.selected = !button.selected;
        _model.selected = !_model.selected;
        if (self.DidSelectCellAtIndexPath) {
            self.DidSelectCellAtIndexPath(self.indexPath, _model);
        }
    }
}

- (void)setEdited:(BOOL)edited{
    if (_edited!=edited) {
        _edited = edited;
        _selectButton.hidden = ! _edited;
        _shoppingcartButton.hidden = _edited;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

- (void)addToShoppingCart{
    if (self.indexPath && _model) {
        if (self.AddGoodsToShopCart) {
            self.AddGoodsToShopCart(self.indexPath, _model);
        }
    }else{
        JXLog(@"数据为空");
    }
}




@end
