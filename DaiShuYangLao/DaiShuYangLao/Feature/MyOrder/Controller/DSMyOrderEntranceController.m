//
//  DSMyOrderEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/1.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSMyOrderEntranceController.h"
#import "DSMyOrderEntranceSubController.h"
#import <WMPageController.h>
//#import <yyca>

@interface DSMyOrderEntranceController ()<WMPageControllerDelegate,WMPageControllerDataSource>{
    
}

@end

@implementation DSMyOrderEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rt_disableInteractivePop = (self.popControllerLevel>2)? YES:NO;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"我的订单";
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:ImageString(@"public_back") style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviosPage)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40.5, boundsWidth, 0.5)];
    line.backgroundColor = JXColorFromRGB(0xdddddd);
    [self.menuView addSubview:line];
    [self.menuView sendSubviewToBack:line];
}

//样式
- (instancetype)init {
    if (self = [super init]) {
//        self.menuBGColor = [UIColor whiteColor];
        self.titleSizeNormal = 15;
        self.menuView.backgroundColor = JXColorFromRGB(0xffffff);
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = 50;
//        self.menuHeight = 45.5;
        self.titleColorNormal = JXColorFromRGB(0x3f4447);
        self.titleColorSelected = APP_MAIN_COLOR;

    }
    return self;
}

#pragma mark WMPageControllerDelegate,WMPageControllerDataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 4;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    DSMyOrderEntranceSubController * orderSubController = [[DSMyOrderEntranceSubController alloc]init];
    NSArray * types = @[@(DSOrderRequestAll),@(DSOrderRequestWaitForPayment),@(DSOrderRequestWaitForDelivery),@(DSOrderRequestWaitForReceiving)];
    orderSubController.orderStatus = [types[index] integerValue];
    return orderSubController;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return @[@"全部",@"待付款",@"待发货",@"待收货"][index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavigationBarHeight, boundsWidth, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0, kNavigationBarHeight+40, boundsWidth, boundsHeight-(kNavigationBarHeight+40));
}

- (void)backToPreviosPage{
    if (self.popControllerLevel>2) {
        NSArray * controllers = self.rt_navigationController.rt_viewControllers;
        if (controllers.count>=self.popControllerLevel) {
            [self.navigationController popToViewController:controllers[controllers.count-self.popControllerLevel] animated:YES];
        }
    }else{
      [self.navigationController popViewControllerAnimated:YES];
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
