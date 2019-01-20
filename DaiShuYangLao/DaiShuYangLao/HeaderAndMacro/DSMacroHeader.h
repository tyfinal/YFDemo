//
//  DSMacroHeader.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#ifndef DSMacroHeader_h
#define DSMacroHeader_h

#endif /* DSMacroHeader_h */

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define JXLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define JXLog(...)
#endif



#define JXFont(s)  [UIFont systemFontOfSize:(s)]
#define JXBoldFont(s)  [UIFont boldSystemFontOfSize:(s)]


#define JXColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JXColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] /*  十六进制色值  */
#define JXColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]

#define APP_MAIN_COLOR JXColorFromRGB(0xf21212)

#define JXPurpleColor  JXColorFromRGB(0X9832ee)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define boundsWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define boundsHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
//#define boundsSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define boundsWidth [UIScreen mainScreen].bounds.size.width
#define boundsHeight [UIScreen mainScreen].bounds.size.height
//#define boundsSize [UIScreen mainScreen].bounds.size
#endif

#define ScreenAdaptFator_W  boundsWidth/375.0
#define ScreenAdaptFator_H  boundsHeight/667.0

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

//判断当前版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kStatusBarHegiht   [UIApplication sharedApplication].statusBarFrame.size.height

#define kNavigationBarHeight (kStatusBarHegiht+44)

#define KTabbarHeight (boundsHeight>=812 ? 83:49)

#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f



//强引用 弱引用
#define JXWeakSelf(type)    __weak typeof(type) weak##type = type;
#define JXStrongSelf(type)  __strong typeof(type) type = weak##type;

#define ImageString(_imageName_)   [UIImage imageNamed:_imageName_]
//#define JXLoadImage(filename,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:filename ofType:ext］
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define DSAppDelegate    (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define JXAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]   //app当前版本

//文件操作
//获取documents
#define DS_DOCUMENTSSPATH_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//获取cache文件夹
#define DS_PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]



static const CGFloat kLabelHeightOffset = 4;     /**< label实际高度需大于字体的高度值 */

typedef void(^ButtonClickHandle)(UIButton * button,id view); 

