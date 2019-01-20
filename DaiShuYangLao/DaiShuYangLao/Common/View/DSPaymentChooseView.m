//
//  DSPaymentChooseView.m
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/8/30.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSPaymentChooseView.h"
#import "DSItemModel.h"

@interface DSPaymentChooseView ()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation DSPaymentChooseView

static CGFloat const kTopViewHeight = 37.0f;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.backgroundColor = [UIColor whiteColor];
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.contentView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(15);
        _titleLabel.textColor = JXColorFromRGB(0x282828);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    
        [self.contentView addSubview:self.tableView];
        
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xd8d8d8);
        [self addSubview:_seperator];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.mas_top).with.offset(kTopViewHeight);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.priorityLow();
            make.height.mas_lessThanOrEqualTo(self.maxHeight);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_top).with.offset(kTopViewHeight/2.0);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.offset(kTopViewHeight);
            make.height.mas_equalTo(_maxHeight-kTopViewHeight);
        }];
        
    }
    return self;
}



- (void)commonInit{
    _rowHeight = 68;
    NSMutableArray * mu = @[].mutableCopy;
    for (NSInteger i=0; i<2; i++) {
        DSItemModel * model = [[DSItemModel alloc]init];
        model.name = @[@"支付宝",@"微信"][i];
        model.icon = @[@"public_payment_alipay",@"public_payment_wechatpay"][i];
        model.disclosedEnable = YES;
        [mu addObject:model];
    }
    _dataArray = mu.copy;
    _maxHeight = _dataArray.count*_rowHeight+kTopViewHeight;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.rowHeight = _rowHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [tableView setTableFooterView:[UIView new]];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0? _dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_dataArray.count>0) {
        DSItemModel * model = _dataArray[indexPath.row];
        cell.imageView.image = ImageString(model.icon);
        cell.textLabel.text = model.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.DidSelectRowAtIndex) {
        self.DidSelectRowAtIndex(indexPath.row);
    }
}

#pragma mark setter && getter

- (void)setMaxHeight:(CGFloat)maxHeight{
    _maxHeight = maxHeight;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_maxHeight-kTopViewHeight);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if ([title isNotBlank]) {
       _titleLabel.text = title;
    }
}

- (void)setDataArray:(NSArray<DSItemModel *> *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
    self.maxHeight = _dataArray.count*_rowHeight+kTopViewHeight;
}

@end
