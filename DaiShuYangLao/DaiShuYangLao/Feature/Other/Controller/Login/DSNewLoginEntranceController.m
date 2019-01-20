//
//  DSNewLoginEntranceController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/29.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSNewLoginEntranceController.h"

@interface DSNewLoginEntranceController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@end

@implementation DSNewLoginEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    bottomImageView.image = ImageString(@"login_bottom_bg");
    bottomImageView.alpha = 0.5;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(85);
    }];
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
