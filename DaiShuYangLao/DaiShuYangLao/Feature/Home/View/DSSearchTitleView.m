//
//  DSSearchTitleView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSSearchTitleView.h"

@implementation DSSearchTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(5, (44-31)/2.0, frame.size.width-62, 31)];
        _searchTF.layer.cornerRadius = _searchTF.frameHeight/2.0f;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.backgroundColor = JXColorFromRGB(0xf7f7f7);
        _searchTF.font = JXFont(12.0f);
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.leftViewMode  = UITextFieldViewModeAlways;
        _searchTF.textColor = JXColorFromRGB(0x9c9c9c);
        _searchTF.returnKeyType = UIReturnKeySearch;
        [self addSubview:_searchTF];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, _searchTF.frameHeight)];
        leftView.backgroundColor = [UIColor clearColor];
        
        UIImageView * searchIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
        searchIcon.center = CGPointMake(leftView.frameWidth/2.0, leftView.frameHeight/2.0);
        searchIcon.image = ImageString(@"public_search_center");
        [leftView addSubview:searchIcon];
        _searchTF.leftView = leftView;
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(_searchTF.frameRight+6, 0, 50, 44);
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        _backButton.titleLabel.font = JXFont(15);
        [_backButton setTitleColor:JXColorFromRGB(0x666666) forState:UIControlStateNormal];
        [self addSubview:_backButton];
    }
    return self;
}

@end
