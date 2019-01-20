//
//  DSClassificationDetailHeaderView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationDetailHeaderView.h"

@interface DSClassificationDetailHeaderView(){
    
}

@property (nonatomic, assign) NSInteger priceFilterStatus; /**< 0 价格不作为筛选条件 -1 降序 1 升序 */
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation DSClassificationDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _priceFilterStatus = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        NSMutableArray * lineArray = @[].mutableCopy;
        for (NSInteger i=0; i<2; i++) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = JXColorFromRGB(0xbfbfbf);
            [self addSubview:line];
            [lineArray addObject:line];
        }
        
        UIView * seperator = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:seperator];
        seperator.backgroundColor = JXColorFromRGB(0xeeeeee);
        
        UIButton * priceButton = nil;
        NSMutableArray * buttonArray = @[].mutableCopy;
        for (NSInteger i=0; i<3; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"综合",@"销量",@"价格"][i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 10+i;
            button.titleLabel.font = JXFont(floor(18*ScreenAdaptFator_W));
            [button setTitleColor:JXColorFromRGB(0xaaaaaa) forState:UIControlStateNormal];
             [button setTitleColor:JXColorFromRGB(0x051c29) forState:UIControlStateSelected];
            [self addSubview:button];
            [buttonArray addObject:button];
            if(i==0) button.selected = YES;
            if(i==2) priceButton = button;
        }
        _currentSelectIndex = 10;
        
        [priceButton setImage:ImageString(@"classification_price_normal") forState:UIControlStateNormal];
//        [priceButton setImage:ImageString(@"classification_price_descend") forState:UIControlStateSelected];
        [priceButton setImagePosition:LXMImagePositionRight spacing:5];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        [lineArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        
        [lineArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:1 leadSpacing:boundsWidth/3.0 tailSpacing:boundsWidth/3.0];
        
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:10 tailSpacing:10];
        
        
        
    }
    return self;
}

- (void)buttonClick:(UIButton *)button{
    NSInteger index = button.tag - 10;
    UIButton * priceButton = [self viewWithTag:12];
    
    if (button.tag!=_currentSelectIndex) {
        NSArray * filterStrings = @[@"comprehensive",@"sales",@"ascend"];
        if (self.filterHandle) {
            self.filterHandle(filterStrings[index]);
        }
        //点选的是不同按钮 则取消上次点选按钮的选中状态 并将点选按钮的状态设置为选中状态
        UIButton * oldButton = [self viewWithTag:_currentSelectIndex];
        if (_currentSelectIndex==12) {
            //取消价格按钮的选中状态
            [priceButton setImage:ImageString(@"classification_price_normal") forState:UIControlStateNormal];
            _priceFilterStatus = 0;
        }
        oldButton.selected = NO;
        button.selected = YES;
        if (button.tag==12) {
            //点选的是价格按钮 更改文字颜色以及图片 初始选择升序
            [priceButton setImage:ImageString(@"classification_price_ascend") forState:UIControlStateNormal];
            _priceFilterStatus = 1;
        }
        _currentSelectIndex = button.tag;
    }else{
        if (_currentSelectIndex==12) {
            //选中的是价格按钮 在升序与降序之间切换
            _priceFilterStatus = -_priceFilterStatus;
            if (_priceFilterStatus==1) {
                //升序
                if (self.filterHandle) {
                    self.filterHandle(@"ascend");
                }
                [priceButton setImage:ImageString(@"classification_price_ascend") forState:UIControlStateNormal];
            }else if (_priceFilterStatus==-1){
                //降序
                if (self.filterHandle) {
                    self.filterHandle(@"descend");
                }
                [priceButton setImage:ImageString(@"classification_price_descend") forState:UIControlStateNormal];
            }
        }
    }
    
    if (index==2) {
        
    }else{
        [priceButton setImage:ImageString(@"classification_price_normal") forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
