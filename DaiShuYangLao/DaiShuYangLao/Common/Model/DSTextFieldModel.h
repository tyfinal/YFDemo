//
//  DSTextFiledModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSTextFieldModel : DSBaseModel

@property (nonatomic, assign) BOOL editEnable; /**< 是否可编辑 */
@property (nonatomic, copy) NSString * key;    /**< 对应的键 */
@property (nonatomic, copy) NSString * text;   /**< textfield显示文字 */
@property (nonatomic, copy) NSString * extraInfo; /**< 额外信息 例如记录列表中的单元格tag等 */
@property (nonatomic, copy) NSString * placeholder; /**< 占位文字 */
@property (nonatomic, copy) NSAttributedString * placeholderAttributeString; /**< 占位文字的属性配置 */
@property (nonatomic, copy) NSString * emptyWarning; /**< 为空警告 */
@property (nonatomic, assign) CGFloat fontSize;     /**< 字体大小 */
@property (nonatomic, strong) UIColor * textColor;  /**< 文字颜色 */

@property (nonatomic, copy) NSString * tipsTitle;   /**< 显示在textfield之前的 提示文字 */
@property (nonatomic, copy) NSString * iconName;    /**< 显示在textfield之前的图片名称 */

@end
