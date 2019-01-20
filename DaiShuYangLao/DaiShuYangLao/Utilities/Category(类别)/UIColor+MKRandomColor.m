//
//  UIColor+MKRandomColor.m
//  maike
//
//  Created by keiyi on 15/9/8.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "UIColor+MKRandomColor.h"

@implementation UIColor (MKRandomColor)

//随机色获取
+ (UIColor *)getBackgroundColor{
    CGFloat R = arc4random()%255;
    CGFloat G = arc4random()%255;
    CGFloat B = arc4random()%255;
    UIColor * color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.5];
    return color;
}

/** 根据颜色得到指定大小的纯色图片 */
+ (UIImage *)getImageWithColor:(UIColor *)color imageSize:(CGSize)size rounded:(BOOL)rounded{
    CGRect aRect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    if (rounded) {
        //变成圆形
        CGContextAddEllipseInRect(context, aRect);
        // 3.裁剪
        CGContextClip(context);
    }
    CGContextFillRect(context, aRect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/** 得到指定大小的图片 */
+ (UIImage *)colorfulImageWithSize:(CGSize)size{
    UIColor * color = [self getBackgroundColor];
    UIImage * image = [self getImageWithColor:color imageSize:size rounded:NO];
    return image;
}


//将随机颜色转成 1像素大小的图片
+ (UIImage*) colorfulImage
{
    UIColor * color = [self getBackgroundColor];
    UIImage * image = [self getImageWithColor:color imageSize:CGSizeMake(1, 1) rounded:NO];
    return image;
}

+ (UIImage*)colorfulAplaImage
{
    UIColor * color = [UIColor colorWithRed:40.f/255.0 green:158/255.0 blue:251/255.0 alpha:0.0];
    UIImage * image = [self getImageWithColor:color imageSize:CGSizeMake(1, 1) rounded:NO];
    return image;
}

+ (UIImage*)colorfulMainNavImage
{
    UIColor * color = [UIColor colorWithRed:40.f/255.0 green:158/255.0 blue:251/255.0 alpha:1.0];
    UIImage * image = [self getImageWithColor:color imageSize:CGSizeMake(1, 1) rounded:NO];
    return image;
}

@end
