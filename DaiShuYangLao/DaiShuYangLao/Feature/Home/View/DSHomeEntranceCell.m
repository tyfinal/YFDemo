//
//  DSHomeEntranceCell.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/7.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSHomeEntranceCell.h"
#import <YYImage.h>
#import "DSHomeClassificationModel.h"
#import "DSGoodsInfoModel.h"
#import "DSBannerModel.h"
#import <FLAnimatedImageView+WebCache.h>

//#import ""

@implementation DSHomeEntranceCell

@end


@implementation HomeMenbershipNumberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.backgroundImageView.image = ImageString(@"home_menbershipnumber_bg");
        [self.contentView addSubview:self.backgroundImageView];
        
        NSMutableArray * labelMuArray = @[].mutableCopy;
         CGFloat fontSize = floor(ScreenAdaptFator_W*18);
        for (NSInteger i=0; i<9; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.font = [UIFont boldSystemFontOfSize:fontSize];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"0";
//            label.backgroundColor = [UIColor redColor];
            [self.backgroundImageView addSubview:label];
            label.tag = 10+i;
            [labelMuArray addObject:label];
        }
        
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UILabel * label = [self.backgroundImageView viewWithTag:10];
        [labelMuArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundImageView.mas_bottom).with.multipliedBy(0.545);
//            make.top.equalTo(self.backgroundImageView.mas_top);
            make.height.mas_equalTo(label.mas_width).multipliedBy(1);
        }];
        
        [labelMuArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:boundsWidth*(12.0/375.0) leadSpacing:boundsWidth*(35.0/375.0) tailSpacing:boundsWidth*(35.0/375.0)];
        
    }
    return self;
}


- (void)setMembershipNumber:(NSString *)membershipNumber{
    if ([membershipNumber isNotBlank]) {
        for (NSInteger i=0; i<9; i++) {
            UILabel * label = [self.backgroundImageView viewWithTag:10+9-membershipNumber.length+i];
            if (membershipNumber.length>=i+1) {
                NSString * string = [membershipNumber substringWithRange:NSMakeRange(i, 1)];
                label.text = string;
            }else{
                label.text = @"0";
            }
        }
    }else{
        for (NSInteger i=0; i<9; i++) {
            UILabel * label = [self.backgroundImageView viewWithTag:10+i];
            label.text = @"0";
        }
    }
}


@end


@interface HomeClassificationCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end

static NSString * ClassificationItemIdentifer = @"classificationitem";
@implementation HomeClassificationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(8, 10, 10,10);
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
        CGFloat itemW = (boundsWidth-(_layout.sectionInset.left+_layout.sectionInset.right+_layout.minimumInteritemSpacing*3))/5.0f;
        CGFloat itemH = [ClassificationItem getClassificationItemWithWidth:floor(itemW)];
        self.layout.itemSize = CGSizeMake(itemW, itemH);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ClassificationItem class] forCellWithReuseIdentifier:ClassificationItemIdentifer];
    }
    return _collectionView;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark UIColletionViewDelegate && UICollectionViewDataSource && UICollectionIVewFlowLayoutDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassificationItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassificationItemIdentifer forIndexPath:indexPath];
    
    if (_dataArray.count>0) {
        DSHomeClassificationModel * model = _dataArray[indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:ImageString(@"public_clearbg_placeholder")];
        cell.titleLabel.text = model.name;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DSHomeClassificationModel * model = _dataArray[indexPath.item];
    if (self.ClickItemHandle) {
        self.ClickItemHandle(indexPath, model);
    }
}

+ (CGFloat)getCellHeight{
    CGFloat itemW = (boundsWidth-20)/5.0f;
    return 8+10+[ClassificationItem getClassificationItemWithWidth:floor(itemW)];
}

@end

@interface HomeHotSaleCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end

@implementation HomeHotSaleCell
static NSString * const itemIdentifer = @"hotitemidentifer";
static CGFloat const kImageRatio = 0.312;
static CGFloat const kItemLineSpace  = 10;
static CGFloat const kItemInterSpace = 10;

static CGFloat itemWidth  = 0;
static CGFloat itemHeight = 0;


#define KSectionInsets UIEdgeInsetsMake(17, 10, 11, 10)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JXColorFromRGB(0xffffff);
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBannerEvent:)]];
        [self.contentView addSubview:self.imageView];
        
        self.seperator = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperator.backgroundColor = JXColorFromRGB(0xeaeaea);
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.seperator];
         [HomeHotSaleCell itemHeight];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.contentView);
            make.height.mas_equalTo(self.contentView.mas_width).multipliedBy(kImageRatio);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom);
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(itemHeight+KSectionInsets.top+KSectionInsets.bottom);
        }];
        
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.and.right.equalTo(self.collectionView);
            make.top.equalTo(self.collectionView.mas_bottom);
        }];
        
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = KSectionInsets;
        self.layout.minimumLineSpacing = kItemLineSpace;
        self.layout.minimumInteritemSpacing = kItemInterSpace;
        self.layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JXColorFromRGB(0xffffff);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HotSaleGoodsItem class] forCellWithReuseIdentifier:itemIdentifer];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.model isKindOfClass:[DSBannerModel class]]) {
        DSBannerModel * bannerModel = (DSBannerModel *)self.model;
        if (bannerModel.products.count>0) {
            return bannerModel.products.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotSaleGoodsItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifer forIndexPath:indexPath];
    DSBannerModel * bannerModel = (DSBannerModel *)self.model;
    if (bannerModel.products.count>0) {
        cell.productModel = bannerModel.products[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DSBannerModel * bannerModel = (DSBannerModel *)self.model;
    DSGoodsInfoModel * productModel = bannerModel.products[indexPath.item];
    if (self.clickItemAtIndexPathHandle) {
        self.clickItemAtIndexPathHandle(bannerModel, indexPath, productModel);
    }
}

+ (CGFloat)itemHeight{
    if (itemWidth<=0) {
        itemWidth = (boundsWidth-(3*kItemInterSpace+KSectionInsets.left+KSectionInsets.right))/3.5;
        itemHeight = [HotSaleGoodsItem getCellHeightWithItemWidth:itemWidth];
    }
    return itemHeight;
}

+ (CGFloat)getCellHeightWithModel:(DSBannerModel *)model{
    CGFloat cellHeight = boundsWidth*kImageRatio+5;
    if (model.products.count>0) {
        //存在商品则增加
        [HomeHotSaleCell itemHeight];
        cellHeight = itemHeight+KSectionInsets.top+KSectionInsets.bottom+boundsWidth*kImageRatio+10;
    }
    return cellHeight;
}

- (void)setModel:(id)model{
    [super setModel:model];
    if ([self.model isKindOfClass:[DSBannerModel class]]) {
        DSBannerModel * bannerModel = (DSBannerModel *)self.model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.pic]];
        self.collectionView.hidden = bannerModel.products.count>0? NO:YES;
        self.seperator.hidden = bannerModel.products.count>0? NO:YES;
        if (bannerModel.products.count>0) {
            [self.collectionView reloadData];
        }
    }
}

- (void)clickBannerEvent:(UITapGestureRecognizer *)ges{
    if (self.clickAtBannerHandle) {
        self.clickAtBannerHandle(self.model);
    }
}



@end



@implementation HomeMembershipRightIntroduceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JXColorFromRGB(0xffffff);
        
        self.imageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        _topLine = [[UIView alloc]initWithFrame:CGRectZero];
        _topLine.backgroundColor = JXColorFromRGB(0xececec);
        [self.contentView addSubview:_topLine];
        
        _rightLine = [[UIView alloc]initWithFrame:CGRectZero];
        _rightLine.backgroundColor = JXColorFromRGB(0xececec);
        [self.contentView addSubview:_rightLine];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = JXColorFromRGB(0xececec);
        [self.contentView addSubview:_bottomLine];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    
        _topLine.hidden = YES;
        _bottomLine.hidden = YES;
        _rightLine.hidden = YES;
        
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end



static CGFloat HomeGoodsItemHeight = 0.0f;
@implementation HomeGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_coverImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(floor(13*ScreenAdaptFator_W));
        _titleLabel.textColor = JXColorFromRGB(0x2f2f2f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(floor(13*ScreenAdaptFator_W));
        _priceLabel.textColor = JXColorFromRGB(0xff242f);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
        
        _salesLabel = [[UILabel alloc]init];
        _salesLabel.font = JXFont(floor(10*ScreenAdaptFator_W));
        _salesLabel.textColor = JXColorFromRGB(0x8c8c8c);
        _salesLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_salesLabel];
        
        _shoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shoppingCartButton setImage:ImageString(@"home_shoppingcart") forState:UIControlStateNormal];
        _shoppingCartButton.hidden = YES;
        [self.contentView addSubview:_shoppingCartButton];
        
        _rewardImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rewardImageView.image = ImageString(@"home_reward_bg");
        [self.contentView addSubview:_rewardImageView];
        
        _rewardLabel = [[UILabel alloc]init];
        _rewardLabel.font = JXFont(10);
        _rewardLabel.textColor = APP_MAIN_COLOR;
        _rewardLabel.textAlignment = NSTextAlignmentCenter;
        [_rewardImageView addSubview:_rewardLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
    }
    return self;
}

- (void)updateConstraints{
    
    if (!self.didSetupLayout) {
        self.didSetupLayout = YES;
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(_coverImageView.mas_width).multipliedBy(1.0);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImageView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(11);
            make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_bottom).with.offset(-20);
            make.left.equalTo(_titleLabel.mas_left);
            make.height.mas_equalTo(13+kLabelHeightOffset);
        }];
        
        [_salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_priceLabel.mas_right).with.offset(floor(10*ScreenAdaptFator_W));
            make.height.mas_equalTo(10+kLabelHeightOffset);
            make.centerY.equalTo(_priceLabel.mas_centerY);
//            make.right.lessThanOrEqualTo(_shoppingCartButton.mas_left).with.offset(-floor(10*ScreenAdaptFator_W));
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_shoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_priceLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-4);
        }];
        
        [_rewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(19);
            make.left.equalTo(_priceLabel.mas_left);
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(8);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-10);
        }];
        
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14);
            make.centerY.equalTo(_rewardImageView.mas_centerY);
            make.left.equalTo(_rewardImageView.mas_left).with.offset(5);
            make.right.equalTo(_rewardImageView.mas_right).with.offset(-5);
        }];
    }
    [super updateConstraints];
}

+ (CGFloat)getItemHeightWithItemWidth:(CGFloat)itemWidth{
    if (HomeGoodsItemHeight<=0) {
        HomeGoodsItemHeight  = itemWidth+104;
    }
    return HomeGoodsItemHeight;
    
}

- (void)setModel:(id)model{
    [super setModel:model];
    DSGoodsInfoModel *aModel = (DSGoodsInfoModel *)model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:aModel.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    self.titleLabel.text = aModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",aModel.price.floatValue];
    self.salesLabel.text = [NSString stringWithFormat:@"已售出%@件",aModel.sellNum];
    self.rewardLabel.text = aModel.info1;
    self.rewardImageView.hidden = YES;
    if ([aModel.info1 isNotBlank]) {
        self.rewardImageView.hidden = NO;
        self.rewardLabel.text = aModel.info1;
    }
}

@end







static CGFloat ClassificationItemHeight = 0;
@implementation ClassificationItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor greenColor];
        
        self.imageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(floor(12*ScreenAdaptFator_W));
        _titleLabel.textColor = JXColorFromRGB(0x272727);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.79);
            make.height.equalTo(self.contentView.mas_width).multipliedBy(0.79);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).with.offset(floor(13*ScreenAdaptFator_H));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).with.offset(floor(13*ScreenAdaptFator_H)-kLabelHeightOffset/2.0);
            make.height.mas_equalTo(kLabelHeightOffset+12);
            make.left.equalTo(self.contentView.mas_left).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-5);
        }];
        
    }
    return self;
}

+ (CGFloat)getClassificationItemWithWidth:(CGFloat)itemWidth{
    if (ClassificationItemHeight<=0) {
        ClassificationItemHeight = itemWidth*0.79+floor(13*ScreenAdaptFator_H)+floor(13*ScreenAdaptFator_H)+12+10;
    }
    return ClassificationItemHeight;
}


@end

@interface HotSaleGoodsItem(){
    
}

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIImageView * rewardImageView;
@property (nonatomic, strong) UILabel * rewardLabel;
@property (nonatomic, assign) BOOL didSetupLayout;

@end

@implementation HotSaleGoodsItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_coverImageView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JXFont(11);
        _titleLabel.textColor = JXColorFromRGB(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(13);
        _priceLabel.textColor = JXColorFromRGB(0xFF0000);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
        
        _rewardImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_rewardImageView];
        _rewardImageView.image = ImageString(@"home_goodslist_bg");
        
        _rewardLabel = [[UILabel alloc]init];
        _rewardLabel.font = JXFont(8);
        _rewardLabel.textColor = [UIColor whiteColor];
        _rewardLabel.textAlignment = NSTextAlignmentCenter;
        [_rewardImageView addSubview:_rewardLabel];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)updateConstraints{
    
    if (!self.didSetupLayout) {
        self.didSetupLayout = YES;
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(_coverImageView.mas_width).multipliedBy(1.0);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImageView.mas_bottom).with.offset(10-kLabelHeightOffset/2.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(2);
            make.right.equalTo(self.contentView.mas_right).with.offset(-2);
            make.height.mas_equalTo(kLabelHeightOffset+11);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(8-kLabelHeightOffset);
            make.left.and.right.equalTo(_titleLabel);
            make.height.mas_equalTo(13+kLabelHeightOffset);
        }];
        
        [_rewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.left.mas_greaterThanOrEqualTo(self.contentView.mas_left).with.offset(2);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).with.offset(-2);
            make.top.equalTo(_priceLabel.mas_bottom).with.offset(2-kLabelHeightOffset/2.0);
        }];
        
        [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.centerY.equalTo(_rewardImageView.mas_centerY);
            make.left.equalTo(_rewardImageView.mas_left).with.offset(5);
            make.right.equalTo(_rewardImageView.mas_right).with.offset(-5);
        }];
    }
    [super updateConstraints];
}

- (void)setProductModel:(DSGoodsInfoModel *)productModel{
    _productModel = productModel;
    DSGoodsInfoModel *aModel = productModel;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:aModel.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    self.titleLabel.text = aModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",aModel.price.floatValue];
    self.rewardLabel.text = aModel.info1;
    self.rewardImageView.hidden = YES;
    if ([aModel.info1 isNotBlank]) {
        self.rewardImageView.hidden = NO;
        self.rewardLabel.text = aModel.info1;
    }
}

+ (CGFloat)getCellHeightWithItemWidth:(CGFloat)itemWidth{
    if (itemHeight<=0) {
        itemHeight = itemWidth+10+10+8+13+2+13+3;
    }
    return itemHeight;
}

@end
