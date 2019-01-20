//
//  DSCheckOutVIew.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/4.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCheckOutVIew.h"
#import "DSSafeAreaAdaptBottomView.h"
#import "UIDevice+YYAdd.h"

@interface DSCheckOutVIew(){
    
}

@property (nonatomic, strong) DSSafeAreaAdaptBottomView * bottomView;

@end

@implementation DSCheckOutVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(selctAllEvent:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllButton.titleLabel.font = JXFont(13);
        [_selectAllButton setTitleColor:JXColorFromRGB(0x2f2f2f) forState:UIControlStateNormal];
        [_selectAllButton setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_selectAllButton setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        [_selectAllButton setImagePosition:LXMImagePositionLeft spacing:10];
        [self.contentView addSubview:_selectAllButton];

        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setTitle:@"移至收藏" forState:UIControlStateNormal];
        [_collectionButton addTarget:self action:@selector(collectionGoodsEvent:) forControlEvents:UIControlEventTouchUpInside];
        _collectionButton.titleLabel.font = JXFont(13);
        [_collectionButton setTitleColor:JXColorFromRGB(0x303030) forState:UIControlStateNormal];
        [self.contentView addSubview:_collectionButton];

        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(15);
        _priceLabel.textColor = JXColorFromRGB(0x303030);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
        
        _checkOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkOutButton setTitle:@"结算" forState:UIControlStateNormal];
        [_checkOutButton addTarget:self action:@selector(checkOutEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _checkOutButton.titleLabel.font = JXFont(15);
        [_checkOutButton setBackgroundImage:[UIImage imageWithColor:APP_MAIN_COLOR] forState:UIControlStateNormal];
        [_checkOutButton setBackgroundImage:[UIImage imageWithColor:JXColorFromRGB(0x979797)] forState:UIControlStateDisabled];
        [_checkOutButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.contentView addSubview:_checkOutButton];
        self.edited = NO;
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(45);
            make.bottom.equalTo(self).with.priorityLow();
        }];
        
        [_selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).with.offset(6);
            make.width.mas_equalTo(60);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectAllButton.mas_right).with.offset(7);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
            make.right.equalTo(self.checkOutButton.mas_left).with.offset(-10);
        }];
        
        [_collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(_checkOutButton.mas_left).with.offset(-50);
        }];
        
        CGFloat checkOutBtnW = ceil(135*ScreenAdaptFator_W);
        [self.checkOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(checkOutBtnW);
        }];
        
        if (boundsHeight==812&&boundsWidth==375) {
            [self addSubview:self.bottomView];
//            self.bottomView.rightView.backgroundColor = APP_MAIN_COLOR;
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(34);
                make.top.equalTo(self.contentView.mas_bottom).priorityMedium();
            }];
            
            [self.bottomView.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.checkOutButton.mas_width);
            }];
        }
    
        [self layoutIfNeeded];
        _collectionButton.layer.borderColor = JXColorFromRGB(0xf0f3f3).CGColor;
        _collectionButton.layer.borderWidth = 1.0f;

    }
    return self;
}

- (void)setEdited:(BOOL)edited{
    _edited = edited;
    if (_edited) {
        //开启编辑状态 展示收藏按钮 隐藏价格
        _collectionButton.hidden = NO;
        _priceLabel.hidden = YES;
        [_checkOutButton setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        //显示价格 隐藏收藏按钮
        _collectionButton.hidden = YES;
        _priceLabel.hidden = NO;
    }
}


- (DSSafeAreaAdaptBottomView * )bottomView{
    if (!_bottomView) {
        _bottomView = [[DSSafeAreaAdaptBottomView alloc]initWithFrame:CGRectZero];
    }
    return _bottomView;
}

- (void)selctAllEvent:(UIButton *)button{
    if (self.selectAllButtonClickHandle) {
        self.selectAllButtonClickHandle(button, self);
    }
}

//- (void)changeControlState{
//    if (_edited==NO) {
//        //非编辑状态
//        [_checkOutButton setTitle:@"去结算" forState:UIControlStateNormal];
//        _priceLabel.text = @"合计：￥0.00";
//        if (_dataArray.count>0) {
//            [_checkOutButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",_dataArray.count] forState:UIControlStateNormal];
//        }
//    }else{
//        
//    }
//}

- (void)collectionGoodsEvent:(UIButton *)button{
    if (self.collectionButtonClickHandle) {
        self.collectionButtonClickHandle(button, self);
    }
}

- (void)checkOutEvent:(UIButton *)button{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
