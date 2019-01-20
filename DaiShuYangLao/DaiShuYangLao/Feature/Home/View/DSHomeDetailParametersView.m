//
//  DSHomeDetailParameters.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/19.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeDetailParametersView.h"
#import "DSGoodsDetailInfoModel.h"
#import "DSGoodsDetailCell.h"

@interface DSHomeDetailParametersView()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation DSHomeDetailParametersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = JXFont(14);
        titleLabel.textColor = JXColorFromRGB(0x4C4C4C);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"产品参数";
        [self addSubview:titleLabel];
        
        [self addSubview:self.tableView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:JXColorFromRGB(0xffffff)forState:UIControlStateNormal];
        [button setBackgroundImage:ImageString(@"public_gradient_buttonbg") forState:UIControlStateNormal];
        button.titleLabel.font = JXFont(15.0f);
        [self addSubview:button];
        _closeButton = button;
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(120);
            make.centerY.equalTo(self.mas_top).with.offset(20);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(40, 0, 45, 0));
        }];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.left.right.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.rowHeight = 44;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tableView setTableFooterView:[UIView new]];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    cell.textLabel.font = JXFont(14);
    cell.textLabel.textColor = JXColorFromRGB(0xB7B7B7);
    cell.detailTextLabel.font = JXFont(14.0f);
    cell.detailTextLabel.textColor = JXColorFromRGB(0x626262);
    if (_dataArray.count>0) {
        GoodsPropertyModel * model = _dataArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.value;
    }
    
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
