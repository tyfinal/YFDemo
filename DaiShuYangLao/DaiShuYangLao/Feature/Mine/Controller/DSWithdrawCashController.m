//
//  DSWithdrawCashController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/7/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSWithdrawCashController.h"
#import "DSWithdrawCashTableHeaderFooterView.h"
#import "DSPensionDetailController.h"
#import "DSWithdrawInputCell.h"
#import "DSWithdrawResultController.h"
#import "DSLaunchConfigureModel.h"
#import "DSWithdrawCashConfigureModel.h"
#import "DSLoginInputView.h"
#import "KLCPopup.h"
#import "DSWebContentView.h"
#import "DSCashAmountChooseCell.h"
#import "DSHomeEntranceActivityPopView.h"
#import "DSIdentityAuthenticationController.h"

@interface DSWithdrawCashController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSInteger countSecond;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WithdrawCashTableHeaderView * tableHeaderView;
@property (nonatomic, strong) WithdrawCashTableFooterView * tableFooterView;
@property (nonatomic, copy) NSArray * dataArray;

@property (nonatomic, strong) NSDecimalNumber * withdrawServiceFee;  /**< 提现服务费 */
@property (nonatomic, strong) NSDecimalNumber * withdrawLimitAmount; /**< 用户需保留的积分 */
@property (nonatomic, strong) NSDecimalNumber * canWithdrawAmount;   /**< 用户可提现金额  = (用户积分-用户需保留的积分)  */
@property (nonatomic, assign) BOOL withdrawEnabled;   /**< 是否可提现 */
@property (nonatomic, strong) UIButton * verificationButton;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) KLCPopup * regulationPopView;
@property (nonatomic, copy) NSArray * withdrawAmountArray;
@property (nonatomic, strong) NSDecimalNumber * withdrawAmount; /**< 用户选取的提现金额 */
@property (nonatomic, strong) KLCPopup * authenticationPopView; /**< 强制认证弹出框 */

@end

@implementation DSWithdrawCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    countSecond = 60;
    
    [self commonInit];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(withdrawCashHistory)];
    
//    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingEvent)];
//    ges.delegate = self;
//    [self.view addGestureRecognizer:ges];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTime];
}

//数据初始化
- (void)commonInit{
    _withdrawWay = 1; //提现渠道
    _withdrawEnabled = YES; //是否可提现
    _availablePoint = self.configureModel.withdrawAvailable;
    
    NSDecimalNumber * zeroNumber = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    _withdrawAmount = zeroNumber;
    
    NSDecimalNumber * availablePointAmountNum = zeroNumber;
    _canWithdrawAmount = zeroNumber;
    _withdrawLimitAmount = zeroNumber;
    
    if ([self.availablePoint isNotBlank]) {
        //存在积分
        availablePointAmountNum = [NSDecimalNumber decimalNumberWithString:self.availablePoint];
        _canWithdrawAmount = [NSDecimalNumber decimalNumberWithString:self.availablePoint];
    }
    
    if ([self.configureModel.withdrawMinimumLimit isNotBlank]) {
        //存在最低保留 积分的阈值
        _withdrawLimitAmount = [NSDecimalNumber decimalNumberWithString:self.configureModel.withdrawMinimumLimit];
        if ([_withdrawLimitAmount compare:zeroNumber]!=NSOrderedDescending) {
            if ([_withdrawLimitAmount compare:zeroNumber]==NSOrderedSame) {
                _withdrawLimitAmount = zeroNumber;
                _withdrawEnabled = NO; //禁止提现
                _canWithdrawAmount = zeroNumber;
            }else{
                _withdrawLimitAmount = zeroNumber;  //没有限制
            }
        }else{
            _canWithdrawAmount = [availablePointAmountNum decimalNumberBySubtracting:_withdrawLimitAmount];
            if ([_canWithdrawAmount compare:zeroNumber]==NSOrderedAscending) {
                //可提现金额小于0 则赋值为0
                _canWithdrawAmount = zeroNumber;
            }
        }
    }
    
    _withdrawServiceFee = [NSDecimalNumber decimalNumberWithString:@"5.00"]; //服务费
    if ([self.configureModel.withdrawServiceFee isNotBlank]) {
        _withdrawServiceFee = [NSDecimalNumber decimalNumberWithString:self.configureModel.withdrawServiceFee];
    }
    
    DSUserInfoModel * account = [JXAccountTool account];
    if (account.isCertification.boolValue==0) {
        [self.authenticationPopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
    }
    
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        NSMutableArray * mu = [NSMutableArray array];
//        NSString * withCashAmoutPlaceHodler = [NSString stringWithFormat:@"提现数额(最低提现数额%@)",self.configureModel.withdrawMinimum];
        for (NSInteger i=0; i<4; i++) {
            DSTextFieldModel * textModel = [[DSTextFieldModel alloc]init];
            textModel.placeholder = @[@"请输入支付宝预留姓名",@"请输入支付宝账号",@"",@"请输入验证码"][i];
            textModel.emptyWarning = @[@"请输入支付宝预留姓名",@"请输入支付宝账号",@"请请选择您要提现的金额",@"请输入验证验证码",][i];
            textModel.key = @[@"accountName",@"accountNo",@"amount",@"code"][i];
            [mu addObject:textModel];
        }
        _dataArray = mu.copy;
    }
    return _dataArray;
}

- (NSArray *)withdrawAmountArray{
    if (!_withdrawAmountArray) {
        NSMutableArray * mu = [NSMutableArray array];
        if (self.configureModel.isWithdraw.boolValue==NO) {
            if ([self.configureModel.withdrawFirst isNotBlank]) {
                [mu addObject:[NSDecimalNumber numberWithString:self.configureModel.withdrawFirst]];
            }
        }
        if ([self.configureModel.withdrawNum isNotBlank]&&[self.configureModel.withdrawAmount isNotBlank]) {
            for (NSInteger i=0; i<self.configureModel.withdrawNum.integerValue; i++) {
                [mu addObject:[NSDecimalNumber numberWithInteger:(i+1)*self.configureModel.withdrawAmount.integerValue]];
            }
        }
        
        _withdrawAmountArray = mu.copy;
    }
    return _withdrawAmountArray;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            countSecond--;
            if (countSecond <= 0) {
                [self stopTime]; //停止定时器
                self.verificationButton.enabled = YES;
                [self.verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }else{
                self.verificationButton.enabled = NO;
                [self.verificationButton setTitle:[NSString stringWithFormat:@"%lds后重试",(long)countSecond] forState:UIControlStateNormal];
            }
        } repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

#pragma mark UI

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.rowHeight = 50;
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableHeaderView = [[WithdrawCashTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 126)];
        _tableHeaderView.availablePointLabel.text = NSStringFormat(@"%.2f",_canWithdrawAmount.stringValue.doubleValue);
        _tableHeaderView.tipsLabel.hidden = YES;
        if ([_withdrawLimitAmount compare:[NSDecimalNumber decimalNumberWithString:@"0.0"]]!=NSOrderedSame) {
            _tableHeaderView.tipsLabel.hidden = NO;
            _tableHeaderView.tipsLabel.text = [NSString stringWithFormat:@"(账户内须保留%.2f养老备用金,其余可提现)",_withdrawLimitAmount.stringValue.doubleValue];
        }
        _tableHeaderView.tipsLabel.hidden = NO;
        _tableHeaderView.tipsLabel.text = @"袋鼠乐购提醒：涉及个人资金安全的信息请勿泄露";
        
        WithdrawCashTableFooterView * footerView = [[WithdrawCashTableFooterView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 240)];
        footerView.withdrawDetailButton.enabled = _withdrawEnabled;
        footerView.configureModel = self.configureModel;
        [footerView.withdrawDetailButton addTarget:self action:@selector(applyForWithdraw) forControlEvents:UIControlEventTouchUpInside];
        [footerView.withdrawRegulationButton addTarget:self action:@selector(withRegulationEvent) forControlEvents:UIControlEventTouchUpInside];
        footerView.backgroundColor = [UIColor whiteColor];
        [tableView setTableFooterView:footerView];
        
        [tableView setTableHeaderView:_tableHeaderView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (KLCPopup *)regulationPopView{
    if (!_regulationPopView) {
        DSWebContentView * webContentView = [[DSWebContentView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth*0.9, boundsHeight*0.7)];
        [webContentView.cancelButton addTarget:self action:@selector(dismissPopViiew) forControlEvents:UIControlEventTouchUpInside];
        _regulationPopView = [KLCPopup popupWithContentView:webContentView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _regulationPopView;
}

- (KLCPopup *)authenticationPopView{
    if (!_authenticationPopView) {
        DSHomeEntranceActivityPopView * activityView = [[DSHomeEntranceActivityPopView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 0)];
        [activityView.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(activityView.contentView.mas_left).with.offset(20);
            make.right.equalTo(activityView.contentView.mas_right).with.offset(-20);
        }];
        activityView.imageView.image = ImageString(@"mine_authentication");

        [activityView layoutIfNeeded];

        activityView.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickActivityContentView)];
        [activityView.imageView addGestureRecognizer:ges];
        [activityView.closeButton addTarget:self action:@selector(closeActivityPopView) forControlEvents:UIControlEventTouchUpInside];
        activityView.frameHeight = activityView.contentView.frameBottom;
        _authenticationPopView = [KLCPopup popupWithContentView:activityView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];

    }
    return _authenticationPopView;
}

#pragma mark 网路请求及数据处理

- (void)requestVerificaationCode{
    __weak typeof (self)weakSelf = self;
    [weakSelf.view endEditing:YES];
    if ([weakSelf arguementsValidityCheckExceptKeys:@[@"code"]]) {
        DSUserInfoModel * account = [JXAccountTool account];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"phone"] = account.phone;
        params[@"type"] = @3;
        [DSHttpResponseData LoginGetVerificationCodeWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
            [self startTimer];//开始倒计时
            if (succeed) {

                DSWithdrawInputCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                if (cell) {
                    [cell.ds_inputView.textField becomeFirstResponder];
                }
                [MBProgressHUD showText:@"验证码发送成功" toView:nil];
            }
        }];
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return [DSCashAmountChooseCell getCellHeightWithDataArray:self.withdrawAmountArray];
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count>0? _dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        static NSString *identifer = @"amountcell";
        DSCashAmountChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[DSCashAmountChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = self.withdrawAmountArray;
        cell.info = self.configureModel.info;
        __weak typeof (self)weakSelf = self;
        DSTextFieldModel * model = weakSelf.dataArray[2];
        cell.DidSelectedItemAtIndexPath = ^(NSIndexPath *indexPath, NSDecimalNumber *number) {
            [weakSelf.view endEditing:YES];
            weakSelf.withdrawAmount = number;
            model.text = weakSelf.withdrawAmount.stringValue;
        };
        return cell;
    }else{
        static NSString *identifer = @"identifer";
        DSWithdrawInputCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
       
        if (!cell) {
            cell = [[DSWithdrawInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count>0) {
            DSTextFieldModel * textModel = self.dataArray[indexPath.row];
            cell.textModel = textModel;
        }
        __weak typeof (self)weakSelf = self;
        cell.requestForVerificationCode = ^(UIButton *button, id view) {
            weakSelf.verificationButton = button;
            [weakSelf requestVerificaationCode];
        };
        cell.seperator.hidden = (indexPath.row==_dataArray.count-1)? NO:YES;
        return cell;
    }
}

- (void)withdrawCashHistory{
    DSPensionDetailController * pensionControllerVC = [[DSPensionDetailController alloc]init];
    [self.navigationController pushViewController:pensionControllerVC animated:YES];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return  YES;
}

- (void)endEditingEvent{
    [self.view endEditing:YES];
}

#pragma mark 按钮点击事件

- (BOOL)arguementsValidityCheckExceptKeys:(NSArray *)keys{
    __block BOOL arguementsIsValid = YES;
    
    if ([_canWithdrawAmount compare:[NSDecimalNumber decimalNumberWithString:@"0"]]!=NSOrderedDescending) {
        [MBProgressHUD showText:@"您暂时没有可提现金额" toView:nil];
         arguementsIsValid = NO;
        return NO;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(DSTextFieldModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (keys.count>0) {
            BOOL notCheck = [keys containsObject:obj.key]; //不参与有效性验证
            if (notCheck==YES) {
               return ;
            }
        }
        
        if ([obj.text isNotBlank]==NO) {
            [MBProgressHUD showText:obj.emptyWarning toView:nil]; //为空判断
            arguementsIsValid = NO;
            *stop = YES;
            return;
        }
        if ([obj.key isEqualToString:@"amount"]) {
            //金额不能超过积分总额
            NSDecimalNumber * withdrawAmount = [NSDecimalNumber decimalNumberWithString:obj.text];
            if ([_canWithdrawAmount compare:withdrawAmount]==NSOrderedAscending) {
                //提现金额 大于 可以提现的金额
                [MBProgressHUD showText:@"请选择有效的提现金额" toView:nil];
                arguementsIsValid = NO;
                *stop = YES;
                return;
            }
            NSDecimalNumber * withdrawMininumAmount = [NSDecimalNumber decimalNumberWithString: self.configureModel.withdrawMinimum];
            if ([withdrawAmount compare:withdrawMininumAmount]==NSOrderedAscending) {
                //提现的金额 小于 限额(即服务费)
                NSString * msg = [NSString stringWithFormat:@"提现数额不少于%@",self.configureModel.withdrawMinimum                                                                                                     ];
                [MBProgressHUD showText:msg toView:nil];
                arguementsIsValid = NO;
                *stop = YES;
                return;
            }   
        }
    }];
    return arguementsIsValid;
}

//构建请求参数
- (NSDictionary *)requestParametersConstruct{
    __block NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"type"] = @(self.withdrawWay);
    [self.dataArray enumerateObjectsUsingBlock:^(DSTextFieldModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isNotBlank]) {
            params[obj.key] = obj.text;
        }
    }];
    return params;
}

/**< 申请提现 */
- (void)applyForWithdraw{
    [self.view endEditing:YES];
    if ([self arguementsValidityCheckExceptKeys:@[]]) {
        NSDictionary * params = [self requestParametersConstruct];
        __weak typeof (self)weakSelf = self;
        [DSHttpResponseData mineWithdrawCashWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
            if (succeed) {
                [weakSelf stopTime];//倒计时停止
                DSWithdrawResultController * resultVC = [[DSWithdrawResultController alloc]init];
                resultVC.withdrawAmount = params[@"amount"];
                resultVC.accountName = params[@"accountNo"];
                resultVC.configreModel = weakSelf.configureModel;
                [weakSelf.navigationController pushViewController:resultVC animated:YES];
            }
        }];
    }
}

- (void)startTimer{
    [self.timer fire];
}

- (void)stopTime{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dismissPopViiew{
    [self.regulationPopView dismiss:YES];
}

- (void)withRegulationEvent{
    [self.regulationPopView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
}

- (void)clickActivityContentView{
    [self.authenticationPopView dismiss:YES];
    DSIdentityAuthenticationController * authenticationVC = [[DSIdentityAuthenticationController alloc]init];
    authenticationVC.popControllerLevel = 3;
    [self.navigationController pushViewController:authenticationVC animated:YES];
}

- (void)closeActivityPopView{
    [self.authenticationPopView dismiss:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    JXLog(@"did call dealloc");
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
