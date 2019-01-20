//
//  DSHomeEntranceReusableView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/8.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSHomeEntranceReusableView : UICollectionReusableView

@property (nonatomic, strong) UIView * contentView;

@end

@interface HomeEntranceSectionFooterView : DSHomeEntranceReusableView

@end


@interface HomeEntranceSectionHeaderView : DSHomeEntranceReusableView

@property (nonatomic, strong) UIView * backgroundView ;
@property (nonatomic, strong) UIImageView * titleImageView;

@end
