//
//  DSGoldDetailController.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//  购物金详情

#import "DSGoldDetailController.h"
#import "KLCPopup.h"
#import "DSPensionCell.h"
#import "DSPensionDetailDropDownMenu.h"

@interface DSGoldDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * navigationButton;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) KLCPopup * popView;
@property (nonatomic, strong) UIView * dimView;
@property (nonatomic, assign) BOOL tapBlock;
@property (nonatomic, strong) DSPensionDetailDropDownMenu * dropMenuView;
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, assign) NSInteger requestType;
@property (nonatomic, strong) UIImageView * logoView;

@end

static CGFloat const kDropDownMenuHeight = 120;

#define kPageSize (boundsHeight>667? 20:10)

@implementation DSGoldDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物金明细";

    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 50)];
    _logoView.image = ImageString(@"public_list_logo");
    [self.view addSubview:_logoView];
    
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.navigationButton;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(_logoView.mas_top);   
    }];
    
    self.requestType = 0;
    self.dataArray = [NSArray array];
    //    self.re
    [self addTableViewHeaderAndFooterRefresher];
    __weak typeof (self)weakSelf = self;
    self.backButtonHandle = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    
    //弹出框 遮罩视图
    _dimView = [[UIView alloc]initWithFrame:CGRectZero];
    _dimView.hidden = YES;
    _dimView.backgroundColor = JXColorAlpha(0, 0, 0, 0);
    
    [_dimView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf  dropDownMenuViewShowed:NO];
    }]];
    [self.view addSubview:_dimView];
    
    [_dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view);
        }
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    //弹出框
    _dropMenuView = [[DSPensionDetailDropDownMenu alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight-kDropDownMenuHeight, boundsWidth, kDropDownMenuHeight)];
    _dropMenuView.dataArray = @[@"全部",@"支出",@"收入"];
    _dropMenuView.clickAtIndexPathBlock = ^(NSIndexPath *indexPath) {
        NSString * title = @[@"购物金明细",@"支出明细",@"收入明细"][indexPath.row];
        weakSelf.requestType = indexPath.row;
        if (indexPath.row==1) {
            weakSelf.requestType = 2;
        }
        if (indexPath.row==2) {
            weakSelf.requestType = 1;
        }
        [weakSelf.navigationButton setTitle:title forState:UIControlStateNormal];
        [weakSelf.navigationButton  setImagePosition:LXMImagePositionRight spacing:7];
        [weakSelf dropDownMenuViewShowed:NO];
        _pageNumber = 1;
        [weakSelf reqeustDataWithRefreshFlag:DSRefreshFirstTimeLoad];
    };
    
    [self.view addSubview:_dropMenuView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 60.5;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
}

- (UIButton *)navigationButton{
    if (!_navigationButton) {
        _navigationButton= [UIButton buttonWithType:UIButtonTypeCustom];
        _navigationButton.adjustsImageWhenDisabled = NO;
        _navigationButton.adjustsImageWhenHighlighted = NO;
        [_navigationButton setTitle:@"购物金明细" forState:UIControlStateNormal];
        [_navigationButton addTarget:self action:@selector(showDropDownMneu:) forControlEvents:UIControlEventTouchUpInside];
        _navigationButton.titleLabel.font = JXFont(16);
        [_navigationButton setImage:ImageString(@"public_navigation_rotationarrow_up") forState:UIControlStateSelected];
        [_navigationButton setImage:ImageString(@"public_navigation_rotationarrow_down") forState:UIControlStateNormal];
        [_navigationButton setTitleColor:JXColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_navigationButton setImagePosition:LXMImagePositionRight spacing:7];
        _navigationButton.frame = CGRectMake(0, 0, 120, 30);
    }
    return _navigationButton;
}

#pragma mark 网络请求及数据处理

- (void)addTableViewHeaderAndFooterRefresher{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNumber = 1;
        [self reqeustDataWithRefreshFlag:DSRereshHeader];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNumber ++;
        [self reqeustDataWithRefreshFlag:DSRereshFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void)reqeustDataWithRefreshFlag:(DSRefreshFlag)refreshFlag{
    MBProgressHUD * HUD = nil;
    if (refreshFlag == DSRefreshFirstTimeLoad) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(_pageNumber);
    params[@"max"] =  @(kPageSize);
    params[@"type"] = @(self.requestType);
    [DSHttpResponseData mineGoldDetailListGetByParams:params callback:^(id info, BOOL succeed, id extraInfo) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(refreshFlag== DSRefreshFirstTimeLoad) [HUD hideAnimated:YES];
        if (succeed) {
            self.tableView.mj_footer.hidden = ([info count]<kPageSize) ? YES:NO;
            if (refreshFlag==DSRereshHeader||refreshFlag==DSRefreshFirstTimeLoad) {
                self.dataArray = info;
            }else if (refreshFlag==DSRereshFooter){
                if ([info count]>0) {
                    NSMutableArray * mu = [NSMutableArray arrayWithArray:self.dataArray];
                    [mu addObjectsFromArray:info];
                    self.dataArray = mu;
                }
            }
            [self.tableView reloadData];
        }else{
            self.tableView.mj_footer.hidden = YES;
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    DSPensionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DSPensionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>0) {
        cell.cellType = 2;     
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)showDropDownMneu:(UIButton *)button{
    if (_tapBlock==NO) {
        _tapBlock = YES;
        button.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.userInteractionEnabled = YES;
            _tapBlock = NO;
        });
        
        self.navigationButton.selected = ! self.navigationButton.selected;
        [self dropDownMenuViewShowed:self.navigationButton.selected];
    }
    
}

- (void)dropDownMenuViewShowed:(BOOL)show{
    if (show) {
        _dimView.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.dimView.backgroundColor = JXColorAlpha(0, 0, 0, 0.5);
            self.dropMenuView.frame = CGRectMake(0, kNavigationBarHeight, boundsWidth, kDropDownMenuHeight);
        }];
    }else{
        if (self.navigationButton.selected) {
            self.navigationButton.selected = NO;
        }
        [UIView animateWithDuration:0.15 animations:^{
            self.dimView.backgroundColor = JXColorAlpha(0, 0, 0, 0.5);
            self.dropMenuView.frame = CGRectMake(0, kNavigationBarHeight-kDropDownMenuHeight, boundsWidth, kDropDownMenuHeight);
        }completion:^(BOOL finished) {
            _dimView.hidden = YES;
        }];
    }
    
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
