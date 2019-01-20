//
//  NSString+MKExtension.h
//  maike
//
//  Created by kongxiaopeng on 15/7/16.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (MKExtension)
- (NSDateComponents*)dateStr;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight;  /** 根据字体计算宽度 */

- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxW:(CGFloat)maxWidth; /** 很据属性计算字体高度 */

- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxH:(CGFloat)maxHeight; /** 很据属性计算字体宽度 */

- (NSInteger)fileSize;

- (NSString*)otherStr:(NSString*)phoneStr;

+ (NSString *)handleBigNumber:(NSString *)number; /** 对超过一万的点赞、阅读、收藏数 进行处理 */

/** 将字符串应用文本样式 */
+ (NSAttributedString *)applyAttributes:(NSDictionary *)attributes forString:(NSString *)string;



/** 用****隐藏手机号中间四位 */
- (NSString *)encodePhoneNumber;


@end
