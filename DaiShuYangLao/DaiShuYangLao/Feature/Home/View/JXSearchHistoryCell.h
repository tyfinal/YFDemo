//
//  JXSearchHistoryCell.h
//  JXZX
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXSearchHotWordModel;
@interface JXSearchHistoryCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UILabel * lineLabel;

@property (nonatomic, strong) JXSearchHotWordModel * hotWordModel;

@end
