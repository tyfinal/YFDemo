//
//  DSSnapshotShareView.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareButtonClickHandle)(UIButton * button,UIView * view,UIImage * image);
@interface DSSnapshotShareView : UIView

@property (nonatomic, strong) UIImage * shareImage;

@property (nonatomic, copy) void(^removeShareViewHandle)(void);
@property (nonatomic, copy) ButtonClickHandle shareButtonClickHandle;
- (void)removeShareView;

@end
