//
//  JXAdvertisementController.m
//  JXZX
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JXAdvertisementController.h"
#import "DSCommonWebViewController.h"
#import "DSLaunchConfigureModel.h"
#import "DSBannerModel.h"
#import "DSGoodsDetailController.h"
#import "DSClassificationDetailController.h"

@interface JXAdvertisementController (){
    BOOL isAdverLoadSuccess; //广告是否加载成功
    NSString * goodsId;
    NSString * adverUrl;
    YYLabel * timeLab;
    NSTimer * skipTimer;     //倒计时计时器
    NSInteger currTime;
}

@property (nonatomic, strong) DSLaunchConfigureModel * lauchModel;

@end

@implementation JXAdvertisementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        //调用隐藏方法
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    goodsId = @"";
    isAdverLoadSuccess = NO;
    currTime = 3;
    
    //广告主图片
    UIImageView *adverView = [[UIImageView alloc] init];
    adverView.userInteractionEnabled = YES;
    adverView.contentMode = UIViewContentModeScaleAspectFill;
    adverView.frame = CGRectMake(0, 0, boundsWidth, boundsHeight);
    [self.view addSubview:adverView];
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    logoImageView.image = ImageString(@"LauchImage_bottom");
    [self.view addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(boundsWidth*(4/15.0));
    }];
    
    [adverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(logoImageView.mas_top);
    }];
    
    //添加广告点击事件
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(advertiseDetail:)];
    [adverView addGestureRecognizer:ges];
    
    //跳过按钮
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(boundsWidth-61.5, 12.5, 46.5, 46.5);
    skipButton.backgroundColor = JXColorAlpha(0, 0, 0, 0.3);
    skipButton.layer.cornerRadius = skipButton.frameWidth/2.0;
    skipButton.layer.masksToBounds = YES;
    skipButton.userInteractionEnabled = YES;
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [skipButton addTarget:self action:@selector(skipAdvertise) forControlEvents:UIControlEventTouchUpInside];
    [adverView addSubview:skipButton];
    
    //倒计时
    timeLab = [[YYLabel alloc]initWithFrame:CGRectMake(0, 7, skipButton.frameWidth, 21)];
    timeLab.font = JXFont(18.0f);
    timeLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
    timeLab.textColor = JXColorFromRGB(0xfbfbfb);
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.userInteractionEnabled = NO;
    timeLab.text = [NSString stringWithFormat:@"%ld",(long)currTime];
    
    [skipButton addSubview:timeLab];
    
    YYLabel * tipsLab  = [[YYLabel alloc]initWithFrame:CGRectMake(timeLab.frameX, timeLab.frameBottom-1, timeLab.frameWidth, 14)];
    tipsLab.font = JXFont(12.0f);
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textVerticalAlignment = YYTextVerticalAlignmentTop;
    tipsLab.textColor = JXColorFromRGB(0xfefefe);
    tipsLab.text = @"跳过";
    tipsLab.userInteractionEnabled = NO;
    [skipButton addSubview:tipsLab];
    
    skipTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:skipTimer forMode:NSDefaultRunLoopMode];
    
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, CGSizeMake(boundsWidth, boundsHeight)) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    DSLaunchConfigureModel * model = [DSLaunchConfigureModel configureModel];
    self.lauchModel = model;
    adverView.image = launchImage;
    if (model) {
        if (model.bootPic) {
            [adverView sd_setImageWithURL:[NSURL URLWithString:model.bootPic.pic] placeholderImage:launchImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    isAdverLoadSuccess = YES;
                }
            }];
        }
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 各种事件处理 按钮 通知 计时器 等

//点击跳过 直接进入首页
- (void)skipAdvertise{
    [skipTimer invalidate]; //点击跳过按钮停止定时器
    [DSAppDelegate goToHomePage];
}

//点击广告图片
- (void)advertiseDetail:(UITapGestureRecognizer *)tapGes{
    if (self.lauchModel.bootPic.type.integerValue==0) {
        return;
    }
    [skipTimer invalidate]; //点击跳过按钮停止定时器
    if (self.lauchModel.bootPic) {
        //跳转页面
        DSBannerModel * model = self.lauchModel.bootPic;
        if (model.type.integerValue==1) {
            //跳转商详
            DSGoodsDetailController * detailVC = [[DSGoodsDetailController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.goodsId = model.action;
            detailVC.ds_universal_params = @{@"previouspagetype":@"advertpage"};
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (model.type.integerValue==2){
            //web
            DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.title = model.name;
            webVC.ds_universal_params = @{@"previouspagetype":@"advertpage"};
            webVC.urlString = model.action;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if(model.type.integerValue==3){
            DSClassificationDetailController * classificationVC = [[DSClassificationDetailController alloc]init];
            classificationVC.classificationId = model.action;
            classificationVC.ds_universal_params = @{@"previouspagetype":@"advertpage"};
            classificationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classificationVC animated:YES];
        }
    }
}

//计时器计时
- (void)countTime{
    currTime--;
    timeLab.text = [NSString stringWithFormat:@"%ld",currTime];
    if (currTime == 0) {
        //计时满15十五秒 跳转至首页 并停止定时器
        [skipTimer invalidate];
        [DSAppDelegate goToHomePage];
    }
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
