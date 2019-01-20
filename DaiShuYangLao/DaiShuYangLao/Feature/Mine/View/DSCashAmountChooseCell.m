//
//  DSCashAmountChooseCell.m==
//  DaiShuYangLao
//
//  Created by YueLiang Song on 2018/9/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSCashAmountChooseCell.h"

@interface DSCashAmountChooseCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIView * seperator;

@end

@implementation DSCashAmountChooseCell

#define kSectionInsets UIEdgeInsetsMake(0, 0, 10, 0)

#define KItemSize UIEdgeInsetsMake(0, 0, 0, 0)

static NSString * cellIdentifer  = @"cell";

static NSString * sectionIdentifer  = @"header";

static CGFloat kSectionViewHeight = 40;

static CGFloat kItemLineSpace  = 10.0f;

static CGFloat kItemInterSpace = 20.0f;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        _seperator = [[UIView alloc]initWithFrame:CGRectZero];
        _seperator.backgroundColor = JXColorFromRGB(0xe4e4e4);
        [self.contentView addSubview:_seperator];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 30, 0, 30));
        }];
        
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(30);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.height.mas_equalTo(1.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = kSectionInsets;
        self.layout.minimumLineSpacing = kItemLineSpace;
        self.layout.minimumInteritemSpacing = kItemInterSpace;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        CGFloat collectionViewW = boundsWidth-30*2;
        self.layout.headerReferenceSize = CGSizeMake(collectionViewW, kSectionViewHeight);
        CGFloat itemW = [DSCashAmountChooseCell getItemWidth];
        self.layout.itemSize = CGSizeMake(floor(itemW), floor(itemW));
//        _collectionView.contentInset = UIEdgeInsetsMake(self.bannerScrollView.frameHeight, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JXColorFromRGB(0xffffff);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ChooseAmountItem class] forCellWithReuseIdentifier:cellIdentifer];
        [_collectionView registerClass:[ChoosetAmountSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIdentifer];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ChoosetAmountSectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionIdentifer forIndexPath:indexPath];
        if ([self.info isNotBlank]) {
            header.textLabel.text = self.info;
        }
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooseAmountItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    if (_dataArray.count>0) {
        NSDecimalNumber * num = _dataArray[indexPath.item];
        cell.textLabel.text = NSStringFormat(@"%ld元",num.integerValue);
    }
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDecimalNumber * num = _dataArray[indexPath.item];
    if (self.DidSelectedItemAtIndexPath) {
        self.DidSelectedItemAtIndexPath(indexPath,num);
    }
}


+ (CGFloat)getItemWidth{
    CGFloat collectionViewW = boundsWidth-30*2;
    CGFloat itemW = (collectionViewW-(kSectionInsets.left+kSectionInsets.right+2*kItemInterSpace))/3.0f;
    return floor(itemW);
}

+ (CGFloat)getCellHeightWithDataArray:(NSArray *)dataArrray{
    if (dataArrray.count>0) {
        NSInteger lineCount = ceil(dataArrray.count/3.0);
        return kSectionViewHeight + kSectionInsets.top+kSectionInsets.bottom+[self getItemWidth]*lineCount+kItemLineSpace*(lineCount-1);
    }
    return kSectionViewHeight;
    
}

+ (CGFloat)getCellHeight{
    return kSectionViewHeight + kSectionInsets.top+kSectionInsets.bottom+[self getItemWidth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation  ChooseAmountItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.containterView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _containterView.image = ImageString(@"mine_withdraw_chooseamount_n");
        [self.contentView addSubview:self.containterView];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(13);
        _textLabel.textColor = JXColorFromRGB(0xadadad);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        
//        _selectedFlag = [[UIView alloc]initWithFrame:CGRectZero];
//        _selectedFlag.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:_selectedFlag];
        
        [self.containterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containterView.mas_centerY);
            make.height.mas_equalTo(20);
            make.left.equalTo(self.containterView.mas_left).with.offset(5);
            make.right.equalTo(self.containterView.mas_right).with.offset(-5);
        }];
        
//        [_selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.
//        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _textLabel.textColor = APP_MAIN_COLOR;
        _containterView.image = ImageString(@"mine_withdraw_chooseamount_s");
    }else{
        _textLabel.textColor = JXColorFromRGB(0xadadad);
        _containterView.image = ImageString(@"mine_withdraw_chooseamount_n");
    }
}

@end


@implementation ChoosetAmountSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(13);
        _textLabel.text = @"提现数额:连续签到3天即可获得提现机会";
        _textLabel.textColor = JXColorFromRGB(0x666666);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-5);
        }];
    }
    return self;
}

@end



