//
//  DSCommonWebViewController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/14.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCommonWebViewController.h"
#import <WebKit/WebKit.h>
#import "DSCompleteInfoController.h"
#import "DSClassificationDetailController.h"
#import "DSGoodsDetailController.h"
#import "YJUMengShareHelper.h"
#import <UShareUI/UShareUI.h>
#import "DSParametersSignature.h"
#import "DSLoginEntranceController.h"

@interface DSCommonWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    
}

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) MBProgressHUD * HUD;

@end

@implementation DSCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc]initWithImage:[ImageString(@"public_share_clear") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareEvent)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    if (self.ds_universal_params) {
        if ([self.ds_universal_params[@"previouspagetype"] isEqualToString:@"advertpage"]) {
            self.rt_disableInteractivePop = YES;
            self.backButtonHandle = ^{
                [DSAppDelegate goToHomePage];
            };
        }
    }
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // self 指代的对象需要遵守 WKScriptMessageHandler 协议
    [userContent addScriptMessageHandler:self name:@"dsLocation"];
    config.userContentController = userContent;
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [self combineRequestUrl]; //拼接链接
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearWebCache];
}

//构建请求链接
- (void)combineRequestUrl{
    if ([self.urlString isNotBlank]) {
        NSURL * url = [NSURL URLWithString:self.urlString];
        NSDictionary * parameters = [self getParametersFromUrl:url];
        NSMutableDictionary * universalParams = [NSMutableDictionary dictionaryWithDictionary:[DSParametersSignature universalParameters]];
        NSMutableString * requestUrlStr = [NSMutableString stringWithString:self.urlString];
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.access_token isNotBlank]) {
            universalParams[@"token"] = account.access_token;
        }
        if (parameters.allKeys.count>0) {
            //存在参数
            [universalParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [requestUrlStr appendFormat:@"&%@=%@",key,obj];
            }];
            
        }else{
            //不存在参数
            __block NSInteger index = 0;
            [universalParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (index==0) {
                    [requestUrlStr appendFormat:@"?%@=%@",key,obj];
                }else{
                    [requestUrlStr appendFormat:@"&%@=%@",key,obj];
                }
                index++;
            }];
        }
        self.HUD = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrlStr.copy]];
        request.timeoutInterval = 10.0f;
        [_webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.HUD showAnimated:YES];
}
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    
//}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.HUD hideAnimated:YES];
    //设置JS

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
     [self.HUD hideAnimated:YES];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    if ([navigationResponse.response.URL.scheme isEqualToString:@"dslocation"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
         decisionHandler(WKNavigationResponsePolicyAllow);
    }
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
   
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%@",navigationAction.request.URL.absoluteString);

    if ([navigationAction.request.URL.scheme isEqualToString:@"dslocation"]) {
        decisionHandler(WKNavigationActionPolicyCancel); //不允许跳转
        //拦截事件
        if ([navigationAction.request.URL.host isEqualToString:@"vipPay"]) {
            //购买会员
            if ([DSAppDelegate shouldShowLoginAlertViewInController:self]==NO) {
                //只有普通会员才能升级
                DSCompleteInfoController * completeInfoVC = [[DSCompleteInfoController alloc]init];
                [self.navigationController pushViewController:completeInfoVC animated:YES];
            }
        }else if ([navigationAction.request.URL.host isEqualToString:@"catgegory"]){
            NSDictionary * params = [self getParametersFromUrl:navigationAction.request.URL];
            if (params) {
                if ([params[@"id"] isNotBlank]) {
                    DSClassificationDetailController * detailVC = [[DSClassificationDetailController alloc]init];
                    detailVC.classificationId = params[@"id"];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
        }else if ([navigationAction.request.URL.host isEqualToString:@"product"]){
            NSDictionary * params = [self getParametersFromUrl:navigationAction.request.URL];
            if (params) {
                if ([params[@"id"] isNotBlank]) {
                    DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
                    detailVC.goodsId = params[@"id"];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
        }else if ([navigationAction.request.URL.host isEqualToString:@"login"]){
            DSLoginEntranceController * loginEntrance = [[DSLoginEntranceController alloc]init];
            RTRootNavigationController * nav = [[RTRootNavigationController alloc]initWithRootViewController:loginEntrance];
            nav.hidesBottomBarWhenPushed = YES;
            __weak typeof (self)weakSelf = self;
            loginEntrance.DidLoginSucceed = ^{
                [weakSelf combineRequestUrl];
            };
            [self presentViewController:nav animated:YES completion:nil];
        }
    }else{
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(WKScriptMessage*)message
{
    NSLog(@"%@", message);
}


/**< 根据url解析url中的参数 */
- (NSDictionary *)getParametersFromUrl:(NSURL *)url{
    if ([url.query isNotBlank]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSString * paramStr = url.query;
        NSArray * paramsStringarray = [paramStr componentsSeparatedByString:@"&"];
        __block NSString * key = @"";
        __block NSString * value = @"";
        if (paramsStringarray.count>0) {
            [paramsStringarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray * singleParamArray = [obj componentsSeparatedByString:@"="];
                
                if (singleParamArray.count>0) {
                    key = singleParamArray[0];
                    if (singleParamArray.count>1) {
                        value = singleParamArray[1];
                    }
                }
                if ([key isNotBlank]&&[value isNotBlank]) {
                    dic[key] = value;
                }
            }];
        }
        return dic;
    }
    return nil;
}



//#pragma mark - WKUIDelegate
//// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    return [[WKWebView alloc]init];
//}

//// 输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
//    completionHandler(@"http");
//}

//// 确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
//    completionHandler(YES);
//}

//// 警告框
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    NSLog(@"%@",message);
//    completionHandler();
//}

- (void)clearWebCache{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

- (void)shareEvent{
    NSString* js = [NSString stringWithFormat:@"weixinShareParams()"];
    [_webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            if([response[@"shareUrl"] isNotBlank]) params[@"weburl"] = response[@"shareUrl"];
            
            if ([response[@"shareUrl"] isNotBlank]) {
                params[@"weburl"] = [self combineShareUrl:response[@"shareUrl"]];
            }
            if([response[@"icon"] isNotBlank]) params[@"imageurl"] = response[@"icon"];
            
            if([response[@"title"] isNotBlank]) params[@"text"] = response[@"title"];
            if([response[@"description"] isNotBlank]) params[@"desc"] = response[@"description"];
            if([response[@"circleTitle"] isNotBlank]) params[@"detaildesc"] = response[@"circleTitle"];
            if (params) {
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    [[YJUMengShareHelper shareUMengHelper]shareToPlatform:platformType Params:params shareType:0];
                }];
            }
        }
    }];
}

- (NSString *)combineShareUrl:(NSString *)shareUrlStr{
    if ([shareUrlStr isNotBlank]) {
        NSURL * shareUrl = [NSURL URLWithString:shareUrlStr];
//        if ([shareUrlStr.pathExtension isNotBlank]) {
//            if (shareUrlStr.length>shareUrlStr.pathExtension.length+1) {
//                shareUrlStr = [shareUrlStr substringToIndex:shareUrlStr.length-(shareUrlStr.pathExtension.length+1)]; //去除后缀名
//            }
//        }
        
        NSString * paramStr = shareUrl.query;
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.user_id isNotBlank]) {
            //存在用户id时需要拼接
            if ([paramStr isNotBlank]) {
                //存在参数时的拼接方法
                shareUrlStr = [NSString stringWithFormat:@"%@&dsInviterUserId=%@",shareUrlStr,account.user_id];
            }else{
                //不存在参数时的拼接方法
                shareUrlStr = [NSString stringWithFormat:@"%@?dsInviterUserId=%@",shareUrlStr,account.user_id];
            }
            NSLog(@"%@",shareUrlStr);
        }
    }
    NSLog(@"%@",shareUrlStr);
    return shareUrlStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
