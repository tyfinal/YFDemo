//
//  DSPensionDetailDropDownMenu.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DropDownMenuViewClickAtIndexPath)(NSIndexPath * indexPath);
@interface DSPensionDetailDropDownMenu : UIView

@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, copy) DropDownMenuViewClickAtIndexPath clickAtIndexPathBlock;

- (void)selectIndex:(NSInteger)index;

@end


@interface DropDownmenuItem : UITableViewCell

@property (nonatomic, strong) UIButton * selctedButton;

@end
