//
//  DSWithdrawResultController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawResultController.h"
#import "DSWithdrawResultCell.h"
#import "DSPensionDetailController.h"
#import "DSWithdrawCashConfigureModel.h"
@interface DSWithdrawResultController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSString * acutalAmount;
@property (nonatomic, copy) NSString * serviceFee;

@end

@implementation DSWithdrawResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rt_disableInteractivePop = YES;
    __weak typeof (self)weakSelf = self;
    self.backButtonHandle = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    self.title = @"提现";
    [self.view addSubview:self.tableView];
    self.acutalAmount = self.withdrawAmount;
    self.serviceFee = @"0.0";
    if (self.configreModel.withdrawServiceFee.doubleValue>0) {
        self.serviceFee = [NSString stringWithFormat:@"%.2f",self.withdrawAmount.doubleValue*self.configreModel.withdrawServiceFee.doubleValue/100.0];
        self.acutalAmount = [NSString stringWithFormat:@"%.2f",self.withdrawAmount.doubleValue-self.serviceFee.doubleValue];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 27)];
        headerView.backgroundColor = JXColorFromRGB(0xffffff);
        [tableView setTableHeaderView:headerView];
        [tableView setTableFooterView:[self footerView]];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)footerView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 190)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"查看明细" forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    [button setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
    button.titleLabel.font = JXFont(18);
    [button addTarget:self action:@selector(withdrawCashHistory) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:button];
    
    UILabel * tipsLabel = [[UILabel alloc]init];
    tipsLabel.font = JXFont(15);
    tipsLabel.textColor = JXColorFromRGB(0x666666);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"(到账信息请至个人支付宝查看)";
    [footerView addSubview:tipsLabel];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).with.offset(45*ScreenAdaptFator_W);
        make.right.equalTo(footerView.mas_right).with.offset(-45*ScreenAdaptFator_W);
        make.height.mas_equalTo(45);
        make.top.equalTo(footerView.mas_top).with.offset(100);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).with.offset(15-kLabelHeightOffset/2.0);
        make.centerX.equalTo(footerView.mas_centerX);
        make.height.mas_equalTo(15+kLabelHeightOffset/2.0);
    }];
    
    return footerView;
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row !=4? 44:[DSWithdrawResultCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    DSWithdrawResultCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DSWithdrawResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = @[@"提现账号",@"提现养老备用金",@"手续费用",@"实际到账",@"提现进度"][indexPath.row];
    cell.descLabel.text = @"";
    cell.resultImageView.hidden = YES;
    if(indexPath.row==0) cell.descLabel.text = self.accountName;
    if(indexPath.row==1) cell.descLabel.text = self.withdrawAmount;
    if(indexPath.row==2) cell.descLabel.text = self.serviceFee;
    if(indexPath.row==3) cell.descLabel.text = self.acutalAmount;
    if(indexPath.row==4) cell.resultImageView.hidden = NO;
    return cell;
}

- (void)withdrawCashHistory{
    DSPensionDetailController * pensionControllerVC = [[DSPensionDetailController alloc]init];
    [self.navigationController pushViewController:pensionControllerVC animated:YES];
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
