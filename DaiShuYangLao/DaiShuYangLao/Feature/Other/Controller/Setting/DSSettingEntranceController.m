//
//  DSSettingEntranceController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSSettingEntranceController.h"
#import "DSSettingEntranceTableCell.h"
#import "DSAddressManagerController.h"
#import "DSTabItemModel.h"
#import "DSCheckVerificationCodeController.h"
#import "DSMemberResetPasswordController.h"
#import "DSLoginEntranceController.h"
#import "DSIdentityAuthenticationController.h"
#import "DSAboutUsViewController.h"
#import "DSLoginEntranceController.h"
#import "DSCompleteInfoController.h"
#import "NSString+MKExtension.h"
#import "DSEditUserInfoController.h"
#import "DSUserInfoModel.h"
#import "DSCacheManager.h"

@interface DSSettingEntranceController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL didSettupLayout;
@property (nonatomic, strong) UIView * tableFooterView;

@property (nonatomic, copy) NSString * cacheAmount;

@end

@implementation DSSettingEntranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    [DSCacheManager getFileSize:DS_PATH_CACHE completion:^(NSInteger totalSize) {
        self.cacheAmount = [DSCacheManager transformByteIntoMegaByte:totalSize];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

//- (NSArray *)dataArray{
//    NSMutableArray * mu = [NSMutableArray array];
//    NSMutableArray * firstSecMu = [NSMutableArray array];
//    DSTabItemModel *
//}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setTableFooterView:self.tableFooterView];
        tableView.sectionHeaderHeight = 10;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        CGFloat footerViewH = ceil(180*ScreenAdaptFator_H);
        CGFloat buttonLeft = ceil(57*ScreenAdaptFator_W);
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,boundsWidth,footerViewH)];
        _tableFooterView.backgroundColor = [UIColor whiteColor];
        
        UIButton * logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutEvent) forControlEvents:UIControlEventTouchUpInside];
        logoutButton.titleLabel.font = JXFont(18);
        [logoutButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_tableFooterView addSubview:logoutButton];
        logoutButton.backgroundColor = APP_MAIN_COLOR;
        logoutButton.frame = CGRectMake(buttonLeft, 0, boundsWidth-buttonLeft*2, 44);
        logoutButton.frameBottom = _tableFooterView.frameHeight-17;
        logoutButton.layer.cornerRadius = 5.0f;
        logoutButton.layer.masksToBounds = YES;
    }
    return _tableFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }else{
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 98;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
    headerView.backgroundColor = JXColorFromRGB(0xe7e7e7);
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger threeSectionCount = 1;
    if (self.userinfoModel.level.integerValue==2) {
        //领航会员
        threeSectionCount = 2;
    }
    return [@[@1,@4,@(threeSectionCount)][section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString * identifer = @"avatar";
        SettingEntranceUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[SettingEntranceUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:self.userinfoModel.avatar] placeholderImage:ImageString(@"public_grayavatar_placeholder")];
        DSUserInfoModel * account = [JXAccountTool account];
        if ([account.phone isNotBlank]) {
            cell.userNameLabel.text = account.nickname;
        }
    
        return cell;
    }else{
        static NSString * identifer = @"identifer";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"";
        cell.detailTextLabel.font = JXFont(15.0f);
        if (indexPath.section==1) {
            cell.textLabel.text = @[@"收货地址管理",@"登录密码管理",@"完善个人信息",@"关于我们"][indexPath.row];
        }else if (indexPath.section==2){
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSInteger cacheRow = 0;
            if(self.userinfoModel.level.integerValue==2) cacheRow = 1;
            if (indexPath.row==cacheRow) {
                cell.textLabel.text = @"清除缓存";
                cell.detailTextLabel.text = self.cacheAmount;
            }else{
                cell.textLabel.text = @"领航会员";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@到期",self.userinfoModel.expireTime];
            }
        }

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            DSAddressManagerController * addressManagerVC = [[DSAddressManagerController alloc]init];
            [self.navigationController pushViewController:addressManagerVC animated:YES];
        }else if (indexPath.row==1){
            DSMemberResetPasswordController * resetPasswordVC = [[DSMemberResetPasswordController alloc]init];
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }else if (indexPath.row==2){
            DSIdentityAuthenticationController * resetPasswordVC = [[DSIdentityAuthenticationController alloc]init];
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
        }else if (indexPath.row==3){
            DSAboutUsViewController * aboutUsVC = [[DSAboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }else if (indexPath.section==0){
        DSEditUserInfoController * editUserInfoVC = [[DSEditUserInfoController alloc]init];
        editUserInfoVC.userinfoModel = self.userinfoModel;
        [self.navigationController pushViewController:editUserInfoVC animated:YES];
    }else{
        NSInteger cacheRow = 0;
        if(self.userinfoModel.level.integerValue==2) cacheRow = 1;
        if (indexPath.row==cacheRow     ) {
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DSCacheManager removeDirectoryPath:DS_PATH_CACHE callback:^(id info, BOOL succeed, id extraInfo) {
                [HUD hideAnimated:YES];
                if (succeed) {
                    [DSCacheManager getFileSize:DS_PATH_CACHE completion:^(NSInteger totalSize) {
                        self.cacheAmount = [DSCacheManager transformByteIntoMegaByte:totalSize];
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
            }];
            SDImageCache * cache = [SDImageCache sharedImageCache];
            [cache clearMemory];
            [cache clearDiskOnCompletion:^{
                
            }];
        }
    }
}

- (void)logoutEvent{
    UIAlertController * alert = [YJAlertView presentAlertWithTitle:@"确定退出登录?" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        if (buttonIndex==1) {
            //退出登录
            [DSHttpResponseData Logout:^(id info, BOOL succeed, id extraInfo) {
                if (succeed) {
                    [JXAccountTool logOutAccount]; //清空存储的用户信息
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
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
