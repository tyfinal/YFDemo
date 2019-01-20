//
//  DSClassificationDetailHeaderView.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailHeaderViewFilterHandle)(NSString * filterString);
@interface DSClassificationDetailHeaderView : UIView

@property (nonatomic, copy) DetailHeaderViewFilterHandle filterHandle;

@end
