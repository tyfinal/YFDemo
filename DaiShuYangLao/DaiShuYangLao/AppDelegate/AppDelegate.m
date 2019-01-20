//
//  AppDelegate.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "AppDelegate.h"
#import "DSLoginEntranceController.h"
#import <IQKeyboardManager.h>
#import "YYFPSLabel.h"
#import "DSParametersSignature.h"
#import "DSAreaDataHelper.h"
#import "DSAreaModel.h"
#import "DSHttpBase.h"
#import "DSShoppingCartCache.h"
#import "YJPayHelper.h"
#import "YJUMengShareHelper.h"
#import <WXApi.h>
#import "DSHttpResponseCodeHandle.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //添加网络监测
    [self addNetWorkObserver];
    
    //请求启动配置
    [self requestLaunchConfigure];
    
    //添加截屏监控
    [self addTakeScreenShotObserver];
    
    //注册支付平台
    [[YJPayHelper sharePayHelper]registerAppWithPaymentMode:Payment_WeChatPay];
        
    //注册分享平台
    [[YJUMengShareHelper shareUMengHelper]registerSharePlatforms];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; //禁止键盘工具栏
    
    self.window.backgroundColor = [UIColor whiteColor];
    BOOL didLauched = [[NSUserDefaults standardUserDefaults]boolForKey:@"startLaunch"];
    didLauched == NO ? [self goToGuidancePage]:[self goToAdvertPage]; //是否为初次安装 NO为初次
    
    return YES;
}

- (void)testFPSLabel {
    YYFPSLabel * fpsLabel = [YYFPSLabel new];
    fpsLabel.frame = CGRectMake(60, 50, 50, 30);
    [fpsLabel sizeToFit];
    [self.window addSubview:fpsLabel];
    
    // 如果直接用 self 或者 weakSelf，都不能解决循环引用问题
    
    // 移除也不能使 label里的 timer invalidate
    //        [_fpsLabel removeFromSuperview];
}

#pragma mark 网络环境监测
/** 添加网络监测 */
- (void)addNetWorkObserver{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        self.netStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                JXLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                JXLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                JXLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#ifdef __IPHONE_9_0

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    BOOL handleResult =  [[YJUMengShareHelper shareUMengHelper]handleShareOpenUrl:url];
    if (!handleResult) {
        handleResult = [[YJPayHelper sharePayHelper]handleOpenUrl:url];
    }
    return handleResult;
}

#else

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handleResult =  [[YJUMengShareHelper shareUMengHelper]handleShareOpenUrl:url];
    if (!handleResult) {
        handleResult = [[YJPayHelper sharePayHelper]handleOpenUrl:url];
    }
    return handleResult;
}


#endif


- (void)dealloc{

}

@end
