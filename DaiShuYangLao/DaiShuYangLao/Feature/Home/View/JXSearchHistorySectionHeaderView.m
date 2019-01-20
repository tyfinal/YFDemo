//
//  JXSearchHistorySectionHeaderView.m
//  JXZX
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JXSearchHistorySectionHeaderView.h"

@implementation JXSearchHistorySectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 42)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (headerView.frameHeight-15)/2.0, 2, 15)];
        lineLabel.backgroundColor = APP_MAIN_COLOR;
        lineLabel.hidden = YES;
        [headerView addSubview:lineLabel];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (headerView.frameHeight-20)/2.0, 70, 20)];
        titleLabel.font = JXFont(17.0f);
        titleLabel.textColor = JXColorFromRGB(0x1f1f1f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLabel];
        self.textLabel = titleLabel;
        
        UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(headerView.frameWidth-67.5, (headerView.frameHeight-30)/2.0, 60, 30);
        [clearButton setTitle:@"清空" forState:UIControlStateNormal];
        [clearButton setTitleColor:JXColorFromRGB(0x888888)forState:UIControlStateNormal];
        [clearButton setImage:ImageString(@"mm_vedio_search_delete") forState:UIControlStateNormal];
        clearButton.titleLabel.font = JXFont(13.0f);
        [clearButton setImagePosition:LXMImagePositionLeft spacing:5];
        [headerView addSubview:clearButton];
        clearButton.hidden = YES;
        self.clearButton = clearButton;
        
        UILabel * seperaterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frameBottom-0.5, headerView.frameWidth, 0.5)];
        seperaterLabel.backgroundColor = JXColorFromRGB(0xebebeb);
        [headerView addSubview:seperaterLabel];
        seperaterLabel.hidden = YES;
        [self addSubview:headerView];
    }
    return self;
}

@end
