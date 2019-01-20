//
//  DSPensionDetailDropDownMenu.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/5.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSPensionDetailDropDownMenu.h"

@interface DSPensionDetailDropDownMenu()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView * tableView;


@end

@implementation DSPensionDetailDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSArray array];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).priorityLow();
        }];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = JXColorFromRGB(0xffffff);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled = NO;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 40;
        [tableView setTableFooterView:[UIView new]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    DropDownmenuItem * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DropDownmenuItem alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickAtIndexPathBlock) {
        self.clickAtIndexPathBlock(indexPath);
    }
}

- (void)selectIndex:(NSInteger)index{
    if (index<4) {
        NSIndexPath * indexPath = [NSIndexPath indexPathWithIndex:index];
       [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:YES scrollPosition:UITableViewScrollPositionNone];
        if (self.clickAtIndexPathBlock) {
            self.clickAtIndexPathBlock(indexPath);
        }
    }
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
    if (_dataArray.count>0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        if (self.clickAtIndexPathBlock) {
            self.clickAtIndexPathBlock(indexPath);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation DropDownmenuItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selctedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selctedButton setImage:ImageString(@"address_defaultaddress_n") forState:UIControlStateNormal];
        [_selctedButton setImage:ImageString(@"address_defaultaddress_s") forState:UIControlStateSelected];
        _selctedButton.adjustsImageWhenDisabled = NO;
        _selctedButton.adjustsImageWhenHighlighted = NO;
        _selctedButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_selctedButton];

        [_selctedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(self.contentView.mas_right).with.offset(-28);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.selctedButton.selected = selected;
}



@end

