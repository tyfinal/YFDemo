//
//  DSNewAddressController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/5/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSNewAddressController.h"
#import "DSNewAddressTabelCell.h"
#import "DSTextFieldModel.h"
#import <IQKeyboardManager.h>
#import "DSAreaPickerView.h"
#import "KLCPopup.h"
#import "DSAreaDataHelper.h"
#import "DSAreaModel.h"
#import "DSUserAddress.h"
#import "DSAddressManagerController.h"
#import "DSValidInfoCheck.h"

@interface DSNewAddressController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _buttonTapBlock;
}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) KLCPopup * selectAddressPop;
@property (nonatomic, strong) DSAreaPickerView * addPickerView;
@property (nonatomic, strong) DSUserAddress * submittingModel;

@end



@implementation DSNewAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.edited? @"编辑收货地址" : @"新建地址";
    self.submittingModel = [[DSUserAddress alloc]init];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.view addSubview:self.tableView];
    _buttonTapBlock = NO;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        NSMutableArray * mu = @[].mutableCopy;
        NSArray * titles = @[@"收货人",@"手机号码",@"邮政编码",@"选择区域",@"详细地址",@"设置默认"];
        NSArray * placeholders = @[@"",@"",@"",@"",@"请输入详细地址入门牌。小区。单元等",@""];
        NSArray * keys = @[@"name",@"phone",@"postcode",@"area",@"address",@"def"];
        NSArray * messages = @[@"请输入收货人姓名",@"请输入有效的手机号码",@"请输入有效的邮政编码",@"请选择区域",@"请输入详细地址",@""];
        for (NSInteger i=0; i<keys.count; i++) {
            DSTextFieldModel * textModel = [[DSTextFieldModel alloc]init];
            textModel.tipsTitle = titles[i];
            textModel.placeholder = placeholders[i];
            textModel.editEnable = [@[@(1),@(1),@(1),@(0),@(1),@(0)][i]  boolValue];
            textModel.emptyWarning = messages[i];
            textModel.key = keys[i];
            if ([textModel.key isEqualToString:@"def"]) {
                textModel.text = @"0"; //默认为未选中状态；
            }
            [mu addObject:textModel];
        }
        _dataArray = mu;
    }
    return _dataArray;
}

//编辑地址时
- (void)setAddressModel:(DSUserAddress *)addressModel{
    _addressModel = addressModel;
    NSDictionary * params = addressModel.mj_keyValues;
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        DSTextFieldModel * textModel =  self.dataArray[i];
        textModel.text = params[textModel.key];
        if ([textModel.key isEqualToString:@"area"]) {
            [self transformAddressModel:addressModel intoTextFieldModel:textModel];
        }
    }
    [self.tableView reloadData];
}

//将地址信息填充进输入框模型中
- (DSTextFieldModel *)transformAddressModel:(DSUserAddress *)addressModel intoTextFieldModel:(DSTextFieldModel *)areaTextFieldModel{
    NSMutableString * muAreaString = [NSMutableString string];
    NSMutableString * muIdString = [NSMutableString string];
    if ([addressModel.province.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",addressModel.province.name];
        [muIdString appendFormat:@"%@ ",addressModel.province.code];
    }
    if ([addressModel.city.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",addressModel.city.name];
        [muIdString appendFormat:@"%@ ",addressModel.city.code];
    }
    
    if ([addressModel.district.name isNotBlank]) {
        [muAreaString appendFormat:@"%@ ",addressModel.district.name];
        [muIdString appendFormat:@"%@ ",addressModel.district.code];
    }
    
    if ([muAreaString isNotBlank]) {
        muAreaString = [muAreaString substringToIndex:muAreaString.length-1].mutableCopy;
        muIdString = [muIdString substringToIndex:muIdString.length-1].mutableCopy;
        areaTextFieldModel.text = muAreaString;
        areaTextFieldModel.extraInfo = muIdString;
    }
    return areaTextFieldModel;
}

//将输入框内容填充进地址信息中
- (DSUserAddress *)transformAreaTextFieldModel:(DSTextFieldModel *)areaTextFieldModel addressModel:(DSUserAddress *)addressModel{
    if ([areaTextFieldModel.text isNotBlank]) {
        NSArray * textArray = [areaTextFieldModel.text componentsSeparatedByString:@" "];
        NSArray * codeArray = [areaTextFieldModel.extraInfo componentsSeparatedByString:@" "];
        for (NSInteger i=0; i<textArray.count; i++) {
            DSAreaModel * areaModel = [[DSAreaModel alloc]init];
            areaModel.name = textArray[i];
            areaModel.code = codeArray[i];
            if(i==0) addressModel.province = areaModel;
            if(i==1) addressModel.city = areaModel;
            if(i==2) addressModel.district = areaModel;
        }
    }
    return addressModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, boundsWidth, boundsHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 58.5;
        [tableView setTableFooterView:self.footerView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 150)];
        footerView.backgroundColor = [UIColor whiteColor];
        UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setTitle:@"立即保存" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
        saveButton.adjustsImageWhenDisabled = NO;
        saveButton.adjustsImageWhenHighlighted = NO;
        saveButton.titleLabel.font = JXFont(20);
        [saveButton setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [saveButton setBackgroundImage:ImageString(@"login_button_bg") forState:UIControlStateNormal];
        saveButton.frame = CGRectMake(45, 50, boundsWidth-90, 45);
//        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(footerView.mas_left).with.offset(45);
//            make.right.equalTo(footerView.mas_right).with.offset(-45);
//            make.top.equalTo(footerView.mas_top).with.offset(50);
//            make.height.mas_equalTo(45);
//        }];
        [footerView addSubview:saveButton];
        
        _footerView = footerView;
    }
    return _footerView;
}

// MARK: 选择地址
- (KLCPopup *)selectAddressPop{
    if (!_selectAddressPop) {
        CGFloat PickerHeight = 248;
        if (boundsHeight==812&&boundsWidth==375) {
            PickerHeight = 248+34;
        }
        _addPickerView = [[DSAreaPickerView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, PickerHeight)];
        __weak typeof (self)weakSelf = self;
        _addPickerView.AddressPickerClickButtonAtIndex = ^(NSInteger buttonIndex, NSMutableDictionary *addressDic) {
            [weakSelf.selectAddressPop dismiss:YES];
            if (buttonIndex==1) {
                DSAreaModel * provinceModel = addressDic[@"section_1_key"];
                DSAreaModel * cityModel = addressDic[@"section_2_key"];
                DSAreaModel * districtModel = addressDic[@"section_3_key"];
                
                weakSelf.submittingModel.province = provinceModel;
                weakSelf.submittingModel.city = cityModel;
                weakSelf.submittingModel.district = districtModel;
                
                if (weakSelf.dataArray.count>0) {
                    DSTextFieldModel * areaModel = weakSelf.dataArray[3];
                    [weakSelf transformAddressModel:weakSelf.submittingModel intoTextFieldModel:areaModel];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        };
        
        _selectAddressPop = [KLCPopup popupWithContentView:_addPickerView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    }
    return _selectAddressPop;
}

#pragma mark 网络请求及数据处理

//创建新地址 与 编辑地址
- (void)createNewAddressWithParams:(NSDictionary *)params{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"provinceId"] = params[@"province"][@"code"];
    dic[@"cityId"] = params[@"city"][@"code"];
    dic[@"districtId"] = params[@"district"][@"code"];
    [dic removeObjectForKey:@"province"];
    [dic removeObjectForKey:@"city"];
    [dic removeObjectForKey:@"district"];
    __block MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.userInteractionEnabled = NO;
    __weak typeof (self)weakSelf = self;
    completeBlock handleBlock = ^(id info ,BOOL succeed,id extraInfo){
        if (succeed) {
            HUD.minShowTime = 1.0f;
            [HUD hideAnimated:YES];
            if (weakSelf.needRefreshBlock) {
                weakSelf.needRefreshBlock(info, YES, nil);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [HUD hideAnimated:YES];
        }
    };
    if (_edited==YES) {
        dic[@"id"] = _addressModel.address_id;
        [DSHttpResponseData addressEditInfoWithParams:dic callback:handleBlock]; //更新地址信息
    }else{
        [DSHttpResponseData addressAddNewOneWithParams:dic callback:handleBlock]; //新增地址
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    
    DSNewAddressTabelCell * cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell==nil){
        cell = [[DSNewAddressTabelCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:identifer];
    }
    cell.accessoryType = (indexPath.row==3) ? UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    cell.contentTF.hidden = (indexPath.row==5)? YES:NO;
    cell.addressSwitch.hidden = (indexPath.row==5) ? NO:YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>0) {
        DSTextFieldModel * model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==3) {
        [self.view endEditing:YES];
        [self.selectAddressPop showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
        _addPickerView.dataArray = [[DSAreaDataHelper shareInstance] getAreaArray];
//        [_addPickerView reloadData];
    }
}

- (void)saveAddress:(UIButton *)button{
    _buttonTapBlock = YES;
    button.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _buttonTapBlock = NO;
        button.enabled = YES;
    });
    [self.view endEditing:YES];
    DSUserAddress * userAddress = self.submittingModel;
    
    __block BOOL continueRequest = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(DSTextFieldModel * textModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textModel.text isNotBlank]) {
            if ([self isValidArguementWithTextModel:textModel]==NO) {
                *stop = YES; //停止循环
                continueRequest = NO;
                return ;
            }
            if([textModel.key isEqualToString:@"name"]) userAddress.name = textModel.text;
            if([textModel.key isEqualToString:@"phone"]) userAddress.phone = textModel.text;
            if([textModel.key isEqualToString:@"def"]) userAddress.def = textModel.text;
            if([textModel.key isEqualToString:@"address"]) userAddress.address = textModel.text;
            if([textModel.key isEqualToString:@"postcode"]) userAddress.postcode = textModel.text;
            if ([textModel.key isEqualToString:@"area"]) {
                [self transformAreaTextFieldModel:textModel addressModel:userAddress];
            }
        }else{
            //有效性验证；
            continueRequest = NO;
            [MBProgressHUD showText:textModel.emptyWarning toView:self.view];
            *stop = YES; //停止循环
            return ;
        }
    }];
    if (continueRequest) {
         [self createNewAddressWithParams:userAddress.mj_keyValues];
    }
   
}

- (BOOL)isValidArguementWithTextModel:(DSTextFieldModel *)model{
    if ([model.key isEqualToString:@"phone"]) {
        if (![DSValidInfoCheck isValidPhoneNumber:model.text]) {
             [MBProgressHUD showText:model.emptyWarning toView:self.view];
            return NO;
        }
    }
    
    if ([model.key isEqualToString:@"postcode"]) {
        if (![DSValidInfoCheck isValidPostCode:model.text]) {
            [MBProgressHUD showText:model.emptyWarning toView:self.view];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//if ([textModel.text isNotBlank]) {
//    NSArray * areaArray = [textModel.text componentsSeparatedByString:@" "];
//    NSArray * areaCodes = [textModel.extraInfo componentsSeparatedByString:@" "];
//    for (NSInteger j=0; j<areaArray.count; j++) {
//        DSAreaModel * areaModel = [[DSAreaModel alloc]init];
//        areaModel.name = areaArray[j];
//        areaModel.code = areaCodes[j];
//        if(j==0) userAddress.province = areaModel;
//        if(j==1) userAddress.city = areaModel;
//        if(j==2) userAddress.district = areaModel;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
