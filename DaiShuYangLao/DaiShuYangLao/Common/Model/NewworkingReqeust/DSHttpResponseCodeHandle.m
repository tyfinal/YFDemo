//
//  DSHttpTool.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  主要处理错误码 以及通用特定返回码的跳转处理事件 例如 登录令牌失效跳转指定界面

#import "DSHttpResponseCodeHandle.h"
#import "DSHttpBase.h"
#import "MBProgressHUD+JXAdd.h"
#import "DSHttpRequestParameterConfigure.h"
#import "DSControllerHelper.h"

static NSInteger kErrorMessageBlockTime = 10;
static BOOL errorMessageBlock = NO;
@implementation DSHttpResponseCodeHandle

+ (void)getWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [DSHttpRequestParameterConfigure getWirhUrl:url parms:parms token:token success:^(id json) {
        if(success){
            if ([json[@"error"] integerValue] == 3) {
                [MBProgressHUD hideHUD];
                [JXAccountTool logOutAccount]; //清空存储的用户信息
                UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"登录令牌不正确或已经超时失效,请重新登录" message:nil actionTitles:@[@"取消",@"登录"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                    if (buttonIndex==1) {
                        [DSAppDelegate goToLoginPage];
                    }
                }];
                [[DSControllerHelper getCurrentViewController].navigationController presentViewController:alertController animated:YES completion:nil];;
                
            }else{
                success(json);
            }
        }
    } failture:^(id error) {
        if(failture){
            failture(error);
            [self errorMsgTip:error];
        }
    }];
}

+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
//    if ([DSAppDelegate netStatus]==AFNetworkReachabilityStatusNotReachable) {
//        //网络未连接
//        if (failture) {
//            failture(nil);
//        }
//        return;
//    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [DSHttpRequestParameterConfigure postWirhUrl:url parms:parms token:token success:^(id json) {
        if(success){
            if ([json[@"error"] integerValue] == 3) {
                if (success) {
                    success(nil);
                }
                DSUserInfoModel * account = [JXAccountTool account];
                account.access_token = @"";
                [JXAccountTool saveAccount:account];
                UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"登录令牌不正确或已经超时失效,请重新登录" message:nil actionTitles:@[@"取消",@"登录"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                    if (buttonIndex==1) {
                        [DSAppDelegate goToLoginPage];
                    }
                }];
                [[DSControllerHelper getCurrentViewController].navigationController presentViewController:alertController animated:YES completion:nil];;
            }else{
                if (success) {
                    success(json);
                }
            }
        }
    } failture:^(id error) {
        if(failture){
            failture(error);
            [self errorMsgTip:error];
        }
    }];

}

+ (void)postWirhUrl:(NSString*)url parms:(NSDictionary*)parms imageArray:(NSArray <DSUploadingImageModel *> *)imageArray token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [DSHttpRequestParameterConfigure postWirhUrl:url parms:parms images:imageArray token:token success:^(id json) {
        if ([json[@"error"] integerValue] == 3) {
            DSUserInfoModel * account = [JXAccountTool account];
            account.access_token = @"";
            [JXAccountTool saveAccount:account];
            UIAlertController * alertController = [YJAlertView presentAlertWithTitle:@"登录令牌不正确或已经超时失效,请重新登录" message:nil actionTitles:@[@"取消",@"登录"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
                if (buttonIndex==1) {
                    [DSAppDelegate goToLoginPage];
                }
            }];
            [[DSControllerHelper getCurrentViewController].navigationController presentViewController:alertController animated:YES completion:nil];;
        }else{
            if (success) {
                success(json);
            }
        }
    } failture:^(id error) {
        if(failture){
            failture(error);
            [self errorMsgTip:error];
        }
    }];
}

+ (void)patchWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [DSHttpBase patch:url parms:parms token:token success:^(id json) {
        if(success){
            if ([json[@"error"] integerValue] == 3) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showText:@"登录令牌不正确或者已经超时失效，请重新登录" toView:nil];
                DSUserInfoModel * account = [JXAccountTool account];
                account.access_token = @"";
                [JXAccountTool saveAccount:account];
                [DSAppDelegate goToLoginPage];
            }else{
                success(json);
            }
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
            [self errorMsgTip:json];
        }
    }];
}

+ (void)putWirhUrl:(NSString*)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [DSHttpBase put:url parms:parms token:token success:^(id json) {
        if(success){
            if ([json[@"error"] integerValue] == 3) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showText:@"登录令牌不正确或者已经超时失效，请重新登录" toView:nil];
                DSUserInfoModel * account = [JXAccountTool account];
                account.access_token = @"";
                [JXAccountTool saveAccount:account];
                [DSAppDelegate goToLoginPage];
            }else{
                success(json);
            }
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
            [self errorMsgTip:json];
        }
    }];
}

+ (void)deleteWithUrl:(NSString *)url parms:(NSDictionary*)parms token:(NSString*)token success:(void(^)(id json))success failture:(void(^)(id error))failture{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [DSHttpBase dele:url parms:parms token:token success:^(id json) {
        if(success){
            if ([json[@"error"] integerValue] == 3) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showText:@"登录令牌不正确或者已经超时失效，请重新登录" toView:nil];
                DSUserInfoModel * account = [JXAccountTool account];
                account.access_token = @"";
                [JXAccountTool saveAccount:account];
                [DSAppDelegate goToLoginPage];
            }else{
                success(json);
            }
        }
    } failture:^(id json) {
        if(failture){
            failture(json);
            [self errorMsgTip:json];
        }
    }];
}


+ (void)errorMsgTip:(id)json
{
    
    NSError *error = json;
    NSString *errorMesg;
    switch (error.code) {
        case -1://NSURLErrorUnknown
            errorMesg = @"无效的URL地址";
            break;
        case -999://NSURLErrorCancelled
            errorMesg = @"无效的URL地址";
            break;
        case -1000://NSURLErrorBadURL
            errorMesg = @"无效的URL地址";
            break;
        case -1001://NSURLErrorTimedOut
            errorMesg = @"网络不给力，请稍后再试";
            break;
        case -1002://NSURLErrorUnsupportedURL
            errorMesg = @"不支持的URL地址";
            break;
        case -1003://NSURLErrorCannotFindHost
            errorMesg = @"找不到服务器";
            break;
        case -1004://NSURLErrorCannotConnectToHost
            errorMesg = @"连接不上服务器";
            break;
        case -1103://NSURLErrorDataLengthExceedsMaximum
            errorMesg = @"请求数据长度超出最大限度";
            break;
        case -1005://NSURLErrorNetworkConnectionLost
            errorMesg = @"网络连接异常";
            break;
        case -1006://NSURLErrorDNSLookupFailed
            errorMesg = @"DNS查询失败";
            break;
        case -1007://NSURLErrorHTTPTooManyRedirects
            errorMesg = @"HTTP请求重定向";
            break;
        case -1008://NSURLErrorResourceUnavailable
            errorMesg = @"资源不可用";
            break;
        case -1009://NSURLErrorNotConnectedToInternet
            errorMesg = @"网络连接已断开，请检查您的网络";
            break;
        case -1010://NSURLErrorRedirectToNonExistentLocation
            errorMesg = @"重定向到不存在的位置";
            break;
        case -1011://NSURLErrorBadServerResponse
            errorMesg = @"服务器响应异常";
            break;
        case -1012://NSURLErrorUserCancelledAuthentication
            errorMesg = @"用户取消授权";
            break;
        case -1013://NSURLErrorUserAuthenticationRequired
            errorMesg = @"需要用户授权";
            break;
        case -1014://NSURLErrorZeroByteResource
            errorMesg = @"零字节资源";
            break;
        case -1015://NSURLErrorCannotDecodeRawData
            errorMesg = @"无法解码原始数据";
            break;
        case -1016://NSURLErrorCannotDecodeContentData
            errorMesg = @"无法解码内容数据";
            break;
        case -1017://NSURLErrorCannotParseResponse
            errorMesg = @"无法解析响应";
            break;
        case -1018://NSURLErrorInternationalRoamingOff
            errorMesg = @"国际漫游关闭";
            break;
        case -1019://NSURLErrorCallIsActive
            errorMesg = @"被叫激活";
            break;
        case -1020://NSURLErrorDataNotAllowed
            errorMesg = @"数据不被允许";
            break;
        case -1021://NSURLErrorRequestBodyStreamExhausted
            errorMesg = @"请求体";
            break;
        case -1100://NSURLErrorFileDoesNotExist
            errorMesg = @"文件不存在";
            break;
        case -1101://NSURLErrorFileIsDirectory
            errorMesg = @"文件是个目录";
            break;
        case -1102://NSURLErrorNoPermissionsToReadFile
            errorMesg = @"无读取文件权限";
            break;
        case -1200://NSURLErrorSecureConnectionFailed
            errorMesg = @"安全连接失败";
            break;
        case -1201://NSURLErrorServerCertificateHasBadDate
            errorMesg = @"服务器证书失效";
            break;
        case -1202://NSURLErrorServerCertificateUntrusted
            errorMesg = @"不被信任的服务器证书";
            break;
        case -1203://NSURLErrorServerCertificateHasUnknownRoot
            errorMesg = @"未知Root的服务器证书";
            break;
        case -1204://NSURLErrorServerCertificateNotYetValid
            errorMesg = @"服务器证书未生效";
            break;
        case -1205://NSURLErrorClientCertificateRejected
            errorMesg = @"客户端证书被拒";
            break;
        case -1206://NSURLErrorClientCertificateRequired
            errorMesg = @"需要客户端证书";
            break;
        case -2000://NSURLErrorCannotLoadFromNetwork
            errorMesg = @"无法从网络获取";
            break;
        case -3000://NSURLErrorCannotCreateFile
            errorMesg = @"无法创建文件";
            break;
        case -3001:// NSURLErrorCannotOpenFile
            errorMesg = @"无法打开文件";
            break;
        case -3002://NSURLErrorCannotCloseFile
            errorMesg = @"无法关闭文件";
            break;
        case -3003://NSURLErrorCannotWriteToFile
            errorMesg = @"无法写入文件";
            break;
        case -3004://NSURLErrorCannotRemoveFile
            errorMesg = @"无法删除文件";
            break;
        case -3005://NSURLErrorCannotMoveFile
            errorMesg = @"无法移动文件";
            break;
        case -3006://NSURLErrorDownloadDecodingFailedMidStream
            errorMesg = @"下载解码数据失败";
            break;
        case -3007://NSURLErrorDownloadDecodingFailedToComplete
            errorMesg = @"下载解码数据失败";
            break;
        default:
            //请求失败，请重试
            errorMesg = @"请求失败，请重试";
            break;
    }
    
    if (errorMessageBlock==NO) {
        errorMessageBlock = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:errorMesg toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kErrorMessageBlockTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            errorMessageBlock = NO;
        });
    }
}


@end
