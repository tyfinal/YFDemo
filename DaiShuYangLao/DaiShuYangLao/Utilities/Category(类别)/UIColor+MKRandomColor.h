//
//  UIColor+MKRandomColor.h
//  maike
//
//  Created by keiyi on 15/9/8.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MKRandomColor)
/** 将随机颜色转成 1像素大小的图片  */
+ (UIImage*)colorfulImage;

+ (UIImage*)colorfulAplaImage;

+ (UIImage*)colorfulMainNavImage;

/** 得到指定大小的图片 */
+ (UIImage *)colorfulImageWithSize:(CGSize)size;

/** 根据颜色得到指定大小的纯色图片 */
+ (UIImage *)getImageWithColor:(UIColor *)color imageSize:(CGSize)size rounded:(BOOL)rounded;

///**< 生成  */
//+ (UIImage *)createBorderWithColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor imageSize:(CGSize)size rounded:(BOOL)rounded;


+ (UIColor *)getBackgroundColor;

@end
