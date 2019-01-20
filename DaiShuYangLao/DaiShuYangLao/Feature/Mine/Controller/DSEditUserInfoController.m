//
//  DSEditUserInfoController.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/22.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSEditUserInfoController.h"
#import "DSEditUserInfoCell.h"
#import "DSUserInfoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "NOAccessImagePickerController.h"
#import "DSHttpBase.h"
#import "DSHttpResponseCodeHandle.h"

@interface DSEditUserInfoController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
}

@property (nonatomic, strong) UIImagePickerController * pickerViewController;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImage * avatar;
@property (nonatomic, strong) NSString * nickName;

@end

@implementation DSEditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.title = @"个人信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateUserInfo)];
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setTableFooterView:[UIView new]];
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 5)];
        headerView.backgroundColor = JXColorFromRGB(0xf5f5f5);
        [tableView setTableHeaderView:headerView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark 网络请求及数据处理

- (void)updateUserInfo{
    [self.view endEditing:YES];
    
    if (self.nickName==nil&&self.avatar==nil) {
        [MBProgressHUD showText:@"未做任何修改" toView:self.view];
        return;
    }
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([self.nickName isNotBlank]) {
        params[@"nickname"] = self.nickName;
    }
    
    if (self.avatar) {
        NSData * data = UIImageJPEGRepresentation(self.avatar, 0.5);
        NSString * imageStr = [data base64EncodedString];
        params[@"avatar"] = imageStr;
        params[@"mime"] = @"jpg";
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DSHttpResponseData mineEditUserInfoWtihParams:params imageModel:nil callback:^(id info, BOOL succeed, id extraInfo) {
        [HUD hideAnimated:YES];
        if (succeed) {
            [MBProgressHUD showText:@"个人信息更新成功" toView:self.view];
            
            if (self.rt_navigationController.rt_viewControllers.count>=3) {
                [self.navigationController popToViewController:self.rt_navigationController.rt_viewControllers[self.rt_navigationController.rt_viewControllers.count-3] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
    }];
}

#pragma mark UITableViewDelete && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 90.5f;
    }else{
        return 45.5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    DSEditUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DSEditUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = @[@"头像",@"昵称"][indexPath.row];
    cell.inputTF.delegate = self;
    if (indexPath.row==0) {
        cell.inputTF.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.avatarIV.hidden = NO;
        if (self.avatar) {
            cell.avatarIV.image = self.avatar;
        }else{
            [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:self.userinfoModel.avatar] placeholderImage:ImageString(@"public_grayavatar_placeholder")];
        }
    }else{
        cell.inputTF.hidden = NO;
        cell.avatarIV.hidden = YES;
        cell.accessoryType = UITableViewCellSelectionStyleNone;
        cell.inputTF.text = self.userinfoModel.nickname;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UIAlertController * alertController = [YJAlertView presentAlertWithTitle:nil message:nil actionTitles:@[@"拍照",@"相册",@"取消"] preferredStyle:UIAlertControllerStyleActionSheet actionHandler:^(NSUInteger buttonIndex, NSString *buttonTitle) {
            switch (buttonIndex)
            {
                case 0://Take picture
                {
                    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"该设备无摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:alertAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        return;
                    }
                    
                    NSString * mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied){
                        
                        NOAccessImagePickerController *noaccessVc = [[NOAccessImagePickerController alloc] init];
                        noaccessVc.cLabelString = @"请在iPhone的“设置－隐私－照片”选项中，\n允许人人通访问你的手机相机";
                        [self presentViewController:noaccessVc animated:YES completion:nil];
                        
                        return;
                    }
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    //设置拍照后的图片可被编辑
                    picker.allowsEditing = YES;
                    //资源类型为照相机
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                    break;
                    
                case 1://From album
                {
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                        NOAccessImagePickerController *noaccessVc = [[NOAccessImagePickerController alloc] init];
                        noaccessVc.cLabelString = @"请在iPhone的“设置－隐私－照片”选项中，\n允许人人通访问你的手机相册";
                        [self presentViewController:noaccessVc animated:YES completion:nil];
                        
                        return;
                    }
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    //资源类型为图片库
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.delegate = self;
                    //设置选择后的图片可被编辑
                    picker.allowsEditing = YES;
                    
                    [self presentViewController:picker animated:YES completion:nil];
                }
                    break;
                    
                default:
                    
                    break;
            }
        }];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    self.avatar = image;
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.nickName = textField.text;
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
