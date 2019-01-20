//
//  DSAddressManagerController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSAddressManagerController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "DSAddressManagerCell.h"
#import "DSNewAddressController.h"
#import "DSUserAddress.h"
#import "YJAlertView.h"
#import "DSValidInfoCheck.h"

@interface DSAddressManagerController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) DSLoadDataStatus loadingStatus;
@property (nonatomic, strong) UIBarButtonItem * rightItem;

@end

@implementation DSAddressManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地址管理";
    [self.navigationController.navigationBar setShadowImage:nil];
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建地址" style:UIBarButtonItemStylePlain target:self action:@selector(createNewAddress)];
    [self requestAddressData];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, boundsWidth, boundsHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 132.5;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 网络请求及数据处理

//获取地址列表
- (void)requestAddressData{
    self.loadingStatus = DSBeginLoadingData;
    [DSHttpResponseData addressList:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            self.loadingStatus = DSLoadDataSuccessed;
            self.dataArray = info;
        }else{
            self.loadingStatus = DSLoadDataFailed;
        }
        [self.tableView reloadData];
    }];
}

//删除地址
- (void)deleteAddressWithModel:(DSUserAddress *)addressModel{
    UIAlertController * alertView = [YJAlertView presentAlertWithTitle:@"确定要删除该地址吗？" message:nil actionTitles:@[@"取消",@"确定"] preferredStyle:UIAlertControllerStyleAlert actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
        if (buttonIndex==1) {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"id"] = addressModel.address_id;
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.minShowTime = 0.3f;
            [DSHttpResponseData addressDeleteWithParams:params callback:^(id info, BOOL succeed, id extraInfo) {
                [HUD hideAnimated:YES];
                if (succeed) {
                    NSInteger row = [self.dataArray indexOfObject:addressModel];
                    [self.dataArray removeObject:addressModel];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    if (self.dataArray.count==0) {
                        [self.tableView reloadEmptyDataSet];
                    }
                }
            }];
        }
    }];
    [self presentViewController:alertView animated:YES completion:nil];

}

/** 设置默认地址 */
- (void)updateDefaultAddressWithModel:(DSUserAddress *)userAddress{
    
    NSDictionary * params = userAddress.mj_keyValues;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"provinceId"] = params[@"province"][@"code"];
    dic[@"cityId"] = params[@"city"][@"code"];
    dic[@"districtId"] = params[@"district"][@"code"];
    [dic removeObjectForKey:@"province"];
    [dic removeObjectForKey:@"city"];
    [dic removeObjectForKey:@"district"];
    dic[@"def"] = @(!userAddress.def.boolValue);
    dic[@"id"] = userAddress.address_id;
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.userInteractionEnabled = NO;
    [DSHttpResponseData addressEditInfoWithParams:dic callback:^(id info, BOOL succeed, id extraInfo) {
        if (succeed) {
            HUD.minShowTime = 1.0f;
            [HUD hideAnimated:YES];
            [self requestAddressData];
        }else{
            [HUD hideAnimated:YES];
        }
    }];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    
    DSAddressManagerCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell==nil){
        cell = [[DSAddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count>0) {
        DSUserAddress * addressModel = _dataArray[indexPath.row];
        cell.addressModel = addressModel;
        cell.indexPath = indexPath;
    }
    
    __weak typeof (self)weakSelf = self;
    cell.addressButtonClickHandle = ^(UIButton *button, id view) {
        NSInteger index = button.tag - 10;
        DSAddressManagerCell * addressCell = (DSAddressManagerCell *)view;
        [weakSelf addressButtonEditEvent:index model:addressCell.addressModel];
    };
    
    cell.UpdateAddressDefaultStatusHandle = ^(NSIndexPath *aIndexPath, DSUserAddress *addressModel) {
        [weakSelf updateDefaultAddressWithModel:addressModel];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.DidSelectedAddressHandle) {
        DSUserAddress * addressModel = self.dataArray[indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
        self.DidSelectedAddressHandle(addressModel);
    }
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.loadingStatus==DSLoadDataSuccessed) {
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        UIImage * emptyImage = ImageString(@"address_emptyset");
        emptyView.emptyImageView.image = emptyImage;
        [emptyView.button setTitle:@"立即创建" forState:UIControlStateNormal];
        [emptyView.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(emptyView.emptyImageView.mas_width).multipliedBy(emptyImage.size.height/emptyImage.size.width);
        }];
        __weak typeof (self)weakSelf = self;
        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
            [weakSelf createNewAddress];
        };
        return emptyView;
    }else if (self.loadingStatus == DSLoadDataFailed){
        DSEmptyDataCustomView * emptyView = [[DSEmptyDataCustomView alloc]initWithFrame:CGRectZero];
        __weak typeof (self)weakSelf = self;
        emptyView.EmptyDataButtonClickHandle = ^(UIButton *button, id view) {
            [weakSelf requestAddressData];
        };
        return emptyView;
    }
    return nil;
}

#pragma mark 按钮点击事件

//新建地址
- (void)createNewAddress{
    DSNewAddressController * newAddressVC = [[DSNewAddressController alloc]init];
    newAddressVC.edited = NO;
    __weak typeof (self)weakSelf = self;
    newAddressVC.needRefreshBlock = ^(id info, BOOL succeed, id extraInfo) {
        [weakSelf requestAddressData];
    };
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

- (void)addressButtonEditEvent:(NSInteger)buttonIndex model:(DSUserAddress *)addressModel{
    if (buttonIndex==0) {
        //编辑
        DSNewAddressController * newAddressVC = [[DSNewAddressController alloc]init];
        newAddressVC.edited = YES;
        newAddressVC.addressModel = addressModel;
        __weak typeof (self)weakSelf = self;
        newAddressVC.needRefreshBlock = ^(id info, BOOL succeed, id extraInfo) {
            [weakSelf requestAddressData];
        };
        [self.navigationController pushViewController:newAddressVC animated:YES];
    }else{
        //删除
        [self deleteAddressWithModel:addressModel];
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



