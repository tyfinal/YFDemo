//
//  DSAboutUsViewController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/31.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSAboutUsViewController.h"
#import "DSAboutUsModel.h"
#import "DSLaunchConfigureModel.h"
#import "DSCommonWebViewController.h"

@interface DSAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation DSAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.navigationController.navigationBar.shadowImage = nil;
    [self.view addSubview:self.tableView];
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).with.offset(kNavigationBarHeight);
        }
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    DSAboutUsModel * contactUsModel = [[DSAboutUsModel alloc]init];
    contactUsModel.label = @"联系我们";
    
    DSLaunchConfigureModel * model = [DSLaunchConfigureModel configureModel];
    
    if ([model.serviceTel isNotBlank]) {
        contactUsModel.url = model.serviceTel;
    }

    self.dataArray = [NSMutableArray arrayWithObject:contactUsModel];
    [self getData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 44;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 网络请求及数据处理

- (void)getData{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData aboutusInfoGet:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            if ([info count]>0) {
                DSAboutUsModel * contactUsModel = [[DSAboutUsModel alloc]init];
                contactUsModel.label = @"联系我们";
                
                DSLaunchConfigureModel * model = [DSLaunchConfigureModel configureModel];
                
                if ([model.serviceTel isNotBlank]) {
                    contactUsModel.url = model.serviceTel;
                }
                self.dataArray = [NSMutableArray arrayWithArray:info];
                [self.dataArray addObject:contactUsModel];
                [self.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.dataArray.count>0) {
        DSAboutUsModel * model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.label;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==self.dataArray.count-1) {
        DSAboutUsModel * model = self.dataArray[self.dataArray.count-1];
        if ([model.url isNotBlank]) {
            NSString * telStr = [NSString stringWithFormat:@"telprompt:%@",model.url];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            }
        }
    }else{
        DSAboutUsModel * model = self.dataArray[indexPath.row];
        DSCommonWebViewController * webVC = [[DSCommonWebViewController alloc]init];
        webVC.title = model.label;
        webVC.urlString = model.url;
        [self.navigationController pushViewController:webVC animated:YES];
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
