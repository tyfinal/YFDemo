//
//  YJGoodsNumberStepperView.m
//  YJRRT
//
//  Created by keiyi on 16/5/17.
//  Copyright © 2016年 jimneylee. All rights reserved.
//

#import "YJGoodsNumberStepperView.h"
//#import "YJCartGoodsModel.h"

@interface YJGoodsNumberStepperView()<UITextFieldDelegate>

@end

@implementation YJGoodsNumberStepperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)refreshStateWithGoodsNumber:(GoodsNumberChangeBlock)block{
    self.goodsNumberChangeBlock = block;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonW = frame.size.height;
        CGFloat labelWidth = frame.size.width-1-2*buttonW;
        self.layer.borderColor = JXColorFromRGB(0xadadad).CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 2.0f;
        self.layer.masksToBounds = YES;
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((frame.size.width-buttonW)*i, 0, buttonW, buttonW);
            [button setTitle:@[@"-",@"+"][i] forState:normal];
            [button setTitleColor:JXColorFromRGB(0x262626) forState:UIControlStateNormal];
            [button setTitleColor:JXColorFromRGB(0xb2b2b2) forState:UIControlStateDisabled];
            button.titleLabel.font = JXFont(12.0f);
            button.tag = i+10;
            if(i==0)self.leftButton = button;
            if(i==1)self.rightButton = button;
            [button addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(buttonW+(labelWidth+0.5)*i, 0, 0.5, buttonW)];
            lineLabel.backgroundColor = JXColorFromRGB(0xadadad);
            [self addSubview:lineLabel];
        }
        
        self.goodsNumberLabel = [[UITextField alloc]initWithFrame:CGRectMake(buttonW+0.5, 0, labelWidth, frame.size.height)];
        self.goodsNumberLabel.textColor = JXColorFromRGB(0x4e4e4e);
        self.goodsNumberLabel.delegate = self;
        [self.goodsNumberLabel addTarget:self action:@selector(limitTextLength:) forControlEvents:UIControlEventEditingChanged];
        self.goodsNumberLabel.keyboardType = UIKeyboardTypeNumberPad;
        self.goodsNumberLabel.textAlignment = NSTextAlignmentCenter;
        UIView * accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 35)];
        accessoryView.backgroundColor = JXColorFromRGB(0xf0f2f5);
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(15+(boundsWidth-44-30)*i,0, 44, 35);
            [button setTitle:@[@"取消",@"确定"][i] forState:normal];
            button.contentHorizontalAlignment = (i==0)? UIControlContentHorizontalAlignmentLeft:UIControlContentHorizontalAlignmentRight;
            [button setTitleColor:JXColorFromRGB(0xf23030) forState:normal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            button.tag = 10+i;
            [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
            [accessoryView addSubview:button];
        }
        self.goodsNumberLabel.inputAccessoryView = accessoryView;
        self.goodsNumberLabel.font = JXFont(12);
        [self addSubview:self.goodsNumberLabel];
        
    }
    return self;
}

- (void)setGoodsNumber:(NSString *)goodsNumber{
    self.goodsNumberLabel.text = goodsNumber;
    if (goodsNumber.integerValue<=1) {
        self.leftButton.enabled = NO;
    }else{
        self.leftButton.enabled = YES;
    }
}

- (NSString *)goodsNumber{
    if (self.goodsNumberLabel.text.integerValue<=1) {
        self.leftButton.enabled = NO;
    }else{
        self.leftButton.enabled = YES;
    }
    return self.goodsNumberLabel.text;
}

- (void)changeNumber:(UIButton *)button{
    [self.goodsNumberLabel resignFirstResponder];
    if (button.tag == 10) {
        //减
        if (self.goodsNumber.integerValue>1) {
            self.goodsNumber = [NSString stringWithFormat:@"%ld",self.goodsNumber.integerValue-1];
        }
    }else{
        //加
        self.goodsNumber = [NSString stringWithFormat:@"%ld",self.goodsNumber.integerValue+1];
        if (self.goodsNumber.integerValue>999) {
            self.goodsNumber = @"999";
        }
    }
    if (self.goodsNumberChangeBlock) {
        self.goodsNumberChangeBlock(self.goodsNumber);
    }
//    self.goodsModel.goodsnum = self.goodsNumber;
}

- (void)limitTextLength:(UITextField *)textField{

    NSString * numberRegex = @"^\\+?[1-9][0-9]*$";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    if ([numberTest evaluateWithObject:textField.text]==NO) {
        textField.text = @"";
    }
    if (textField.text.length>3) {
        textField.text = [textField.text substringToIndex:3];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"1";
    }
    [textField resignFirstResponder];
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.layer.borderColor = [UIColor redColor].CGColor;
//    textField.layer.borderWidth = 0.2;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    textField.layer.borderColor = YJColorFromRGB(0xadadad).CGColor;
//    textField.layer.borderWidth = 0.0;
//}

- (void)clickEvent:(UIButton *)button{
    [self.goodsNumberLabel resignFirstResponder];
    if (button.tag == 11) {
//        YJLog(@"------>");
//        if ([self.goodsNumberLabel.text isEqualToString:@""]) {
//            self.goodsNumberLabel.text = self.goodsModel.goodsnum;
//        }
//        self.goodsModel.goodsnum = self.goodsNumberLabel.text;
        if (self.goodsNumberChangeBlock) {
            self.goodsNumberChangeBlock(self.goodsNumber);
        }
    }
}

@end
