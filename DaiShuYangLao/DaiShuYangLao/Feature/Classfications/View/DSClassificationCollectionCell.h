//
//  DSClassificationCollectionCell.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/28.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSClassificationModel;
@interface DSClassificationCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) DSClassificationModel * model;

@end
