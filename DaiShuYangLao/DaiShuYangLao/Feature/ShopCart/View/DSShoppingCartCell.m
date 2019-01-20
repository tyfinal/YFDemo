//
//  DSShoppingCartCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/2.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSShoppingCartCell.h"
#import "YJGoodsNumberStepperView.h"
#import "PPNumberButton.h"
#import "DSGoodsInfoModel.h"
#import "DSShopCartModel.h"
#import "DSGoodsDetailInfoModel.h"

@implementation DSShoppingCartCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end


@interface ShoppingCartGoodsCell()<PPNumberButtonDelegate>{
    
}

@end

@implementation ShoppingCartGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_selectedButton setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(selctItemEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectedButton];
        
        _moduleBackgroundIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _moduleBackgroundIV.contentMode = UIViewContentModeScaleToFill;
        _moduleBackgroundIV.image = [ImageString(@"shoppingcart_shadow") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        _moduleBackgroundIV.userInteractionEnabled = YES;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDetail)];
        [_moduleBackgroundIV addGestureRecognizer:ges];
        [self.contentView addSubview:_moduleBackgroundIV];
        
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _coverImageView.image = [UIColor colorfulImage];
        [_moduleBackgroundIV addSubview:_coverImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(13);
        _titleLabel.textColor = JXColorFromRGB(0x5b5b5c);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        [_moduleBackgroundIV addSubview:_titleLabel];
        
        _featureLabel = [[UILabel alloc]init];
        _featureLabel.font = JXFont(12);
        _featureLabel.textColor = JXColorFromRGB(0x999999);
        _featureLabel.textAlignment = NSTextAlignmentLeft;
        [_moduleBackgroundIV addSubview:_featureLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = APP_MAIN_COLOR;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.text = @"￥0.00";
//        _priceLabel.backgroundColor = [UIColor greenColor];
        _priceLabel.clipsToBounds = YES;
        [_moduleBackgroundIV addSubview:_priceLabel];

        _goodsNumberStepperView = [[PPNumberButton alloc]initWithFrame:CGRectZero];
        _goodsNumberStepperView.minValue = 1;
        _goodsNumberStepperView.increaseImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        _goodsNumberStepperView.decreaseImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        _goodsNumberStepperView.backgroundColor = JXColorFromRGB(0xf8f8f8);
        // 设置最大值
        _goodsNumberStepperView.maxValue = 99;
//        _goodsNumberStepperView.borderColor = APP_MAIN_COLOR;
        // 设置输入框中的字体大小
        _goodsNumberStepperView.inputFieldFont = 10;
        _goodsNumberStepperView.increaseTitle = @"＋";
        _goodsNumberStepperView.decreaseTitle = @"－";
        _goodsNumberStepperView.currentNumber = 1;
        _goodsNumberStepperView.decimalNum = NO;
//        _goodsNumberStepperView.currentNumber = 777;
        _goodsNumberStepperView.longPressSpaceTime = 0.1;
        [_moduleBackgroundIV addSubview:_goodsNumberStepperView];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    if (!self.didSetupLayout) {
        
        [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
        }];
        
        [_moduleBackgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(35);
            make.height.mas_equalTo(140);
            make.centerY.equalTo(self.selectedButton.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(115*ScreenAdaptFator_W, 115*ScreenAdaptFator_W));
            make.centerY.equalTo(self.moduleBackgroundIV);
            make.left.equalTo(self.moduleBackgroundIV.mas_left).with.offset(7.5);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageView.mas_right).with.offset(9);
            make.right.equalTo(self.moduleBackgroundIV.mas_right).with.offset(-10);
            make.top.equalTo(self.coverImageView.mas_top).with.offset(9);
            make.height.mas_greaterThanOrEqualTo(13);
        }];
        
        [_featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.height.mas_equalTo(12+kLabelHeightOffset/2.0);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(7-kLabelHeightOffset/2.0);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, kLabelHeightOffset+12));
            make.centerY.equalTo(self.coverImageView.mas_bottom).with.offset(-23);
            make.left.equalTo(self.titleLabel);
        }];
        
        [_goodsNumberStepperView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.priceLabel.mas_right).with.offset(10);
            make.right.equalTo(self.moduleBackgroundIV.mas_right).with.offset(-10);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(90);
            make.centerY.equalTo(_priceLabel.mas_centerY);
        }];
        
        
        self.didSetupLayout = YES;
    }
    [super updateConstraints];
}

- (void)setModel:(DSShopCartModel *)model{
    _model = model;
    DSGoodsInfoModel * infoModel = model.product;
    _selectedButton.selected = model.selected;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    _titleLabel.text = infoModel.name;
    _featureLabel.text = model.sku.info;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.sku.price.floatValue];
    _goodsNumberStepperView.currentNumber = model.num.integerValue;
    _goodsNumberStepperView.minValue = 1;
//    _goodsNumberStepperView.maxValue = infoModel.inventoryNum.integerValue;
    
}

- (void)selctItemEvent:(UIButton *)button{
    if (self.ShoppingCartCellSelectItemAtIndexPath) {
        self.ShoppingCartCellSelectItemAtIndexPath(self.indexPath, _model,self);
    }
}

- (void)viewDetail{
    if (self.ShoppingCartCellViewDetailAtIndexPath) {
        self.ShoppingCartCellViewDetailAtIndexPath(self.indexPath, _model,self);
    }
}

@end


@implementation ShoppingCartRecommendCell


@end
