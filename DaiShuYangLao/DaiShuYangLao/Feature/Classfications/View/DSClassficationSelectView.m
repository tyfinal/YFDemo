//
//  DSClassficationSelectView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassficationSelectView.h"
#import "DSClassificationModel.h"

@interface DSClassficationSelectView()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation DSClassficationSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 50;
        _currentSelectRow = 0; //默认选中第0行
        CGFloat viewH = frame.size.height;
        CGFloat viewW = frame.size.width;
        self.categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        self.categoryTableView.delegate = self;
        self.categoryTableView.dataSource = self;
        self.categoryTableView.showsVerticalScrollIndicator = NO;
        self.categoryTableView.showsHorizontalScrollIndicator = NO;
        self.categoryTableView.rowHeight = _itemHeight;
        self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.categoryTableView setTableFooterView:[UIView new]];
        [self addSubview:self.categoryTableView];
        //        self.categoryTableView
    }
    return self;
}

- (void)setItemHeight:(CGFloat)itemHeight{
    _itemHeight = itemHeight;
    self.categoryTableView.rowHeight = itemHeight;
}

- (void)setCurrentSelectRow:(NSInteger)currentSelectRow{
    if (_currentSelectRow!=currentSelectRow) {
        [self selectRow:currentSelectRow];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    self.categoryTableView.backgroundColor = backgroundColor;
}

/**< 选中制定行 */
- (void)selectRow:(NSInteger)row{
    if (_dataArray.count>row&&row>0) {
        //默认选中指定行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        _currentSelectRow = row;
    }else if (_dataArray.count>0){
        //默认选中第0行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        _currentSelectRow = 0;
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.categoryTableView reloadData];
    [self selectRow:_currentSelectRow];
}


#pragma mark UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"identifer";
    ClassificationSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ClassificationSelectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count>0) {
        cell.classificationModel = _dataArray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=_currentSelectRow) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationSelectView:didSelectRowAtIndexPath:withClassificationModel:)]) {
            [self.delegate ds_classificationSelectView:self didSelectRowAtIndexPath:indexPath withClassificationModel:self.dataArray[indexPath.row]];
        }
        _currentSelectRow = indexPath.row;
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


@interface ClassificationSelectCell(){
    
}

@property (nonatomic, strong) UILabel * categoryNameLabel;
@property (nonatomic, strong) UILabel * selectIcon;
@property (nonatomic, strong) UILabel * lineLabel;

@end


@implementation ClassificationSelectCell
static CGFloat const kTextFontSize = 14;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = JXColorFromRGB(0xffffff);
        self.selectIcon = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, 25)];
        self.selectIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.selectIcon];
        
        self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.categoryNameLabel.font = JXFont(kTextFontSize);
        self.categoryNameLabel.backgroundColor = [UIColor clearColor];
        self.categoryNameLabel.textColor = JXColorFromRGB(0x666666);
        self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.categoryNameLabel];
        
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.lineLabel.backgroundColor = [UIColor clearColor];//JXColorFromRGB(0xe8e8e8);
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.categoryNameLabel.frame = CGRectMake(10, 0, self.frameWidth-20, 20);
    self.lineLabel.frame = CGRectMake(0, self.frameHeight-0.5, self.frameWidth, 0.5);
    self.categoryNameLabel.frameCenterY = self.frameHeight/2.0;
    self.selectIcon.frameCenterY = self.categoryNameLabel.frameCenterY;
}

- (void)setClassificationModel:(DSClassificationModel *)classificationModel{
    _classificationModel = classificationModel;
    self.categoryNameLabel.text = classificationModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectIcon.backgroundColor = APP_MAIN_COLOR;
        self.backgroundColor = JXColorFromRGB(0xffffff);
        self.categoryNameLabel.textColor = APP_MAIN_COLOR;
        self.categoryNameLabel.font = JXFont(floor(kTextFontSize*ScreenAdaptFator_W*1.15));
    }else{
        self.selectIcon.backgroundColor = [UIColor whiteColor];
        self.categoryNameLabel.font = JXFont(floor(kTextFontSize*ScreenAdaptFator_W*1.0));
        self.backgroundColor = JXColorFromRGB(0xf6f6f6);
        self.categoryNameLabel.textColor = JXColorFromRGB(0x666666);
    }
    // Configure the view for the selected state
}


@end

