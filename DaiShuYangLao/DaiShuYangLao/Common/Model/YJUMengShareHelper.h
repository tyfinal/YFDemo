//
//  YJUMengShareHelper.h
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"
#import <UMShare/UMShare.h>

typedef NS_ENUM(NSInteger,YJUMengShareContentType) {
    UMeng_PlainText = 0,       /**< 纯文本 */
    UMeng_PlainImage = 1,      /**< 纯图片 */
    Umeng_ImageTextMixed = 2,  /**< 图文混合 */
    Umeng_WebUrl = 3,          /**< 链接 */
};
@interface YJUMengShareHelper : DSBaseModel


+ (instancetype)shareUMengHelper;

//注册分享平台
- (void)registerSharePlatforms;

/**
 调用分享
 params -> {text,icon,image,imageurl,weburl,videourl,musicurl}
 shareType 暂时未使用
 */
- (void)shareToPlatform:(UMSocialPlatformType)platform Params:(NSDictionary *)params shareType:(YJUMengShareContentType)shareType;


//处理分享回调
- (BOOL)handleShareOpenUrl:(NSURL *)url;

@end
