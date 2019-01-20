//
//  YJUMengShareHelper.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "YJUMengShareHelper.h"

#import "DSShareHeader.h"
#import <UMCommon/UMCommon.h>
static YJUMengShareHelper * _UMengShareHelper = nil;
@implementation YJUMengShareHelper

//单例
+ (instancetype)shareUMengHelper{
    if (!_UMengShareHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _UMengShareHelper = [[YJUMengShareHelper alloc]init];
            [UMConfigure initWithAppkey:kUMeng_app_key channel:@"App Store"];
        });
    }
    return _UMengShareHelper;
}

- (void)registerSharePlatforms{
    [_UMengShareHelper configureUSharePlatforms];
    [_UMengShareHelper configureUShareSettings];
}

/** 配置分享平台 */
- (void)configureUSharePlatforms{
    //微信
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechat_app_key appSecret:kWechat_app_secret redirectURL:nil];
    
    //微博
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWeibo_app_key  appSecret:kWeibo_app_secret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //qq
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQ_app_key  appSecret:nil redirectURL:nil];
    
    //移除 收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_TencentWb)]];
}

/** 配置分享设置 */
- (void)configureUShareSettings{
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO; //允许分享 http的图片
}

/**
 调用分享
 params -> {text,icon,imageurl,weburl,videourl,musicurl}
 shareType 暂时未使用
 */
- (void)shareToPlatform:(UMSocialPlatformType)platform Params:(NSDictionary *)params shareType:(YJUMengShareContentType)shareType{
    UMSocialMessageObject * messageObj = [self constuctShareMessageWithParams:params shareType:shareType];
    NSLog(@"%ld--->%@",platform,messageObj);
    UIWindow * window = [DSAppDelegate window];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObj currentViewController:window.rootViewController completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

-  (UIViewController *)getCurrentVC {
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        
        UIView *tempView = window.subviews.lastObject;
        
        for (UIView *subview in window.subviews.reverseObjectEnumerator) {
            if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                tempView = subview;
                break;
            }
        }
        
        BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder){
            if (![responder isKindOfClass:[UIViewController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UINavigationController class]]) {
                return YES;
            } else if ([responder isKindOfClass:[UITabBarController class]]) {
                return YES;
            } else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
                return YES;
            }
            return NO;
        };
        
        UIResponder *nextResponder = tempView.nextResponder;
        
        while (canNext(nextResponder)) {
            tempView = tempView.subviews.firstObject;
            if (!tempView) {
                return nil;
            }
            nextResponder = tempView.nextResponder;
        }
        
        UIViewController *currentVC = (UIViewController *)nextResponder;
        if (currentVC) {
            return currentVC;
        }
    }
    return nil;
    
}


/**
 params -> {text,icon,image,imageurl,weburl,videourl,musicurl}
 shareType 暂时未使用
 */
- (UMSocialMessageObject *)constuctShareMessageWithParams:(NSDictionary *)params shareType:(YJUMengShareContentType)shareType{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString * text = params[@"text"];
    UIImage * icon = params[@"icon"];
    UIImage * image = params[@"image"];
    NSString * imageUrl = params[@"imageurl"];
    NSString * webUrl = params[@"weburl"];
    NSString * desc = params[@"desc"];
    
    if([text isNotBlank])messageObject.text = text;
    UMShareImageObject * shareImageObj = nil;
    if (icon){
        shareImageObj = [[UMShareImageObject alloc]init];
        shareImageObj.thumbImage = icon;
    }
    
    if (image) {
        if(!shareImageObj) shareImageObj = [[UMShareImageObject alloc]init];;
        [shareImageObj setShareImage:image];
    }
    
    if ([imageUrl isNotBlank]) {
        if(!shareImageObj) shareImageObj = [[UMShareImageObject alloc]init];;
        [shareImageObj setShareImage:imageUrl];
    }
    
    if (shareImageObj) {
        messageObject.shareObject = shareImageObj;
    }
    
    if ([webUrl isNotBlank]) {
        UMShareWebpageObject * webObj = [UMShareWebpageObject shareObjectWithTitle:text descr:desc thumImage:imageUrl];
        webObj.webpageUrl = webUrl;
        messageObject.shareObject = webObj;
    }
    
    return messageObject;
}

- (BOOL)handleShareOpenUrl:(NSURL *)url{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}



@end
