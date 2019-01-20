//
//  DSGoodeDetailBottomView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodeDetailBottomView.h"
#import "DSGoodsDetailInfoModel.h"

@interface DSGoodeDetailBottomView(){
    
}

@property (nonatomic, strong) UIView * seperator;
@property (nonatomic, strong) UIView * buttonView;
@property (nonatomic, strong) UIButton * shoppingCartButton;
@property (nonatomic, strong) UIButton * buyButton;
@property (nonatomic, strong) UIButton * buyNowButton;

@end

@implementation DSGoodeDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonView = [[UIView alloc]initWithFrame:CGRectZero];
//        self.buttonView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.buttonView];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xf0f0f0);
        [self addSubview:self.seperator];
        
        NSArray * backgroundImages = @[@"home_goodsdetail_buy",@"home_goodsdetail_shoppingcart_bg"];
        CGFloat buttonFontSize = ceil(15*ScreenAdaptFator_W);
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"加入购物车",@"立即购买"][i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = JXFont(buttonFontSize);
            [button setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
            button.tag = 20+i;
            [button setBackgroundImage:ImageString(backgroundImages[i]) forState:UIControlStateNormal];
            [self addSubview:button];
            if(i==0) self.buyButton = button;
            if(i==1) self.shoppingCartButton = button;
        }
        
        NSMutableArray * buttonsArray = @[].mutableCopy;
        NSArray * itemsimages = @[@"home_goodsdetail_store",@"home_goodsdetail_customersurvice",@"home_goodsdetail_collection"];
        for (NSInteger i=0; i<3; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"首页",@"客服",@"收藏"][i] forState:UIControlStateNormal];
            if (i==2) {
                 [button setImage:ImageString(@"home_goodsdetail_collection_s") forState:UIControlStateSelected];
            }
            [button addTarget:self action:@selector(operationButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 30+i;
            [button setImage:ImageString(itemsimages[i]) forState:UIControlStateNormal];
            button.titleLabel.font = JXFont(11);
            [button setTitleColor:JXColorFromRGB(0x666666) forState:UIControlStateNormal];
            [_buttonView addSubview:button];
            [button setImagePosition:LXMImagePositionTop spacing:5];
            [buttonsArray addObject:button];
            if(i==2) self.collectionButton = button;
        }
        
        
        _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyNowButton setTitleColor:JXColorFromRGB(0xffffff)forState:UIControlStateNormal];
        [_buyNowButton setBackgroundImage:ImageString(@"home_gooddetail_property_cart") forState:UIControlStateNormal];
        _buyNowButton.titleLabel.font = JXFont(buttonFontSize);
        [_buyNowButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        _buyNowButton.hidden = YES;
        [self addSubview:_buyNowButton];

        
        CGFloat buyButtonW = ceil(104*ScreenAdaptFator_W);
        [@[_buyButton,_shoppingCartButton] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buyButtonW, 40));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [_buyNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        
        [_shoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
        }];
        
        [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_shoppingCartButton.mas_left).with.offset(0);
        }];
        
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(self);
            make.right.equalTo(_buyButton.mas_left);
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        CGFloat buttonLeftSpace = 10;
        if (boundsWidth<375) {
            buttonLeftSpace = 5;
        }
        [buttonsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:35 leadSpacing:buttonLeftSpace tailSpacing:buttonLeftSpace];
        [buttonsArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_buttonView.mas_centerY);
        }];
    }
    return self;
}

- (void)setGoodsModel:(DSGoodsDetailInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    _buttonView.hidden = NO;
    _shoppingCartButton.hidden = NO;
    _buyButton.hidden = NO;
    _buyNowButton.hidden = YES;
    if (goodsModel.isExclusive.integerValue==1||goodsModel.serviceFlag.boolValue==YES) {
        //新人未购买 或者 是服务类商品
        _buttonView.hidden = YES;
        _shoppingCartButton.hidden = YES;
        _buyButton.hidden = YES;
         _buyNowButton.hidden = NO;
    }else if (goodsModel.isExclusive.integerValue==2){
        _buttonView.hidden = YES;
        _shoppingCartButton.hidden = YES;
        _buyButton.hidden = YES;
        _buyNowButton.hidden = YES;
    }
}

//购买 与 加入购物车
- (void)clickEvent:(UIButton *)button{
    NSInteger buttonIndex = button.tag - 20;
    if (button==_buyNowButton) {
        buttonIndex = 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_goodsDetailBottomView:clickBuyButtonAtIndex:button:)]) {
        [self.delegate ds_goodsDetailBottomView:self clickBuyButtonAtIndex:buttonIndex button:button];
    }
}

- (void)operationButtonEvent:(UIButton *)button{
    NSInteger buttonIndex = button.tag - 30;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_goodsDetailBottomView:clickOperationbuttonAtIndex:button:)]) {
        [self.delegate ds_goodsDetailBottomView:self clickOperationbuttonAtIndex:buttonIndex button:button];
    }
}

@end
