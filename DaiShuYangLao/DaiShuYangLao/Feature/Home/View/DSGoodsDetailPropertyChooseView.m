//
//  DSGoodsDetailPropertyChooseView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/26.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsDetailPropertyChooseView.h"
#import "PPNumberButton.h"
#import "DSGoodsInfoModel.h"

@interface DSGoodsDetailPropertyChooseView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) PropertyHeaderView * headerView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) PropertyItemFlowLayout * layout;
@property (nonatomic, strong) UIButton * shopCartButton;
@property (nonatomic, strong) UIButton * payButton;
@property (nonatomic, strong) UIButton * buyButton;
@property (nonatomic, strong) UIView * buttonView;
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@end

static NSString * cellIdentifer = @"propertyitem";
static NSString * headerIdentifer = @"propertysectionheader";
static NSString * footerIdentifer = @"propertysectionfooter";
@implementation DSGoodsDetailPropertyChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.dataArray = [NSArray array];
        [self addSubview:self.collectionView];
        _buttonView = [[UIView alloc]initWithFrame:CGRectZero];
//        _buttonView.backgroundColor = APP_MAIN_COLOR;
        [self addSubview:_buttonView];
        
        NSArray * imageNames = @[@"home_gooddetail_property_buy",@"home_gooddetail_property_cart"];
        NSMutableArray * buttonsMu = @[].mutableCopy;
        for (NSInteger i=0; i<2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@[@"加入购物车",@"立即购买"][i] forState:UIControlStateNormal];
            [button setBackgroundImage:ImageString(imageNames[i]) forState:UIControlStateNormal];
            button.tag = 10+i;
            [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = JXFont(16);
            [button setTitleColor:JXColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [_buttonView addSubview:button];
            [buttonsMu addObject:button];
            if(i==0) _shopCartButton = button;
            if(i==1) _payButton = button;
        }
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:JXColorFromRGB(0xffffff)forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:ImageString(@"home_gooddetail_property_cart") forState:UIControlStateNormal];
        _buyButton.titleLabel.font = JXFont(15.0f);
        [_buyButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        _buyButton.hidden = YES;
        _buyButton.tag = 12;
        [self addSubview:_buyButton];

        
        
        _headerView = [[PropertyHeaderView alloc]initWithFrame:CGRectZero];
        [_headerView.closeButton addTarget:self action:@selector(closePresentView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self.mas_top);
            make.height.mas_equalTo(114);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(_headerView.mas_bottom);
        }];
        
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.mas_bottom);
            make.left.and.right.equalTo(self);
            make.height.mas_equalTo(50);
            if (@available(iOS 11.0,*)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            }else{
                make.bottom.equalTo(self);
            }
        }];
        
        [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_buttonView);
        }];
        
        [buttonsMu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_buttonView);
        }];
        
        [buttonsMu mas_distributeViewsAlongAxis:0 withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[PropertyItemFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.layout.minimumLineSpacing = 10;
        self.layout.minimumInteritemSpacing = 10;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.headerReferenceSize = CGSizeMake(boundsWidth, 30);
        self.layout.footerReferenceSize = CGSizeMake(boundsWidth, 50);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GoodsPropertyItem class] forCellWithReuseIdentifier:cellIdentifer];
        [_collectionView registerClass:[PropertySectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifer];
        [_collectionView registerClass:[PropertySectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifer];
    }
    return _collectionView;
}

#pragma mark UIColletionViewDelegate && UICollectionViewDataSource && UICollectionIVewFlowLayoutDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        GoodsDetailSaleInfo * model = self.dataArray[indexPath.item];
        if ([model.info isNotBlank]) {
            CGFloat textW = [model.info sizeWithFont:JXFont(15) maxHeight:20].width;
            CGFloat itemW = textW+20;
            if (itemW+self.layout.sectionInset.left+self.layout.sectionInset.right>boundsWidth) {
                //限制 最大宽度
                itemW = boundsWidth-(self.layout.sectionInset.left+self.layout.sectionInset.right);
            }
            return CGSizeMake(ceil(itemW), 21);
        }
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsPropertyItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    //    [cell configureCellWithModel:nil];
    if (self.dataArray.count>0) {
        cell.skuModel = self.dataArray[indexPath.item];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PropertySectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifer forIndexPath:indexPath];
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        PropertySectionFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifer forIndexPath:indexPath];
        footerView.goodsModel = self.goodsModel;
        return footerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_currentIndexPath.row) {
        return; 
    }
    if (_currentIndexPath) {
        if (self.dataArray.count>_currentIndexPath.row) {
            GoodsDetailSaleInfo * oldModel = self.dataArray[_currentIndexPath.row];
            oldModel.selected = NO; //取消上次选择
        }
    }
    GoodsDetailSaleInfo * model = self.dataArray[indexPath.item];
    model.selected = YES;
    _headerView.skuModel = model; //更新价格信息
    _currentIndexPath = indexPath;
    [self.collectionView reloadData];
}

- (void)setGoodsModel:(DSGoodsDetailInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    _headerView.goodsInfoModel = _goodsModel;
    self.dataArray = goodsModel.skus;
    
    _buttonView.hidden = NO;
    _buyButton.hidden = YES;
    if (goodsModel.isExclusive.integerValue==1||goodsModel.serviceFlag.boolValue==YES) {
        //新人未购买 或者 是服务型商品
        _buttonView.hidden = YES;
        _buyButton.hidden = NO;
    }else if (goodsModel.isExclusive.integerValue==2){
        _buttonView.hidden = YES;
        _buyButton.hidden = YES;
    }
    
    if (self.dataArray.count>0) {
        if (self.dataArray.count>_currentIndexPath.row) {
            GoodsDetailSaleInfo * model = self.dataArray[_currentIndexPath.row];
            model.selected = YES;
            _headerView.skuModel = model; 
        }
        [self.collectionView reloadData];
    }
}

- (void)closePresentView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_GoodsDetailPropertyView:didSelectProperty:)]) {
        GoodsDetailSaleInfo * model = nil;
        if (self.dataArray.count>_currentIndexPath.row) {
            model = self.dataArray[_currentIndexPath.row];
        }
        [self.delegate ds_GoodsDetailPropertyView:self didSelectProperty:model];
    }
}

- (void)clickEvent:(UIButton *)button{
    NSInteger buttonIndex = button.tag - 10;
    if (button==_buyButton) {
        buttonIndex = 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_GoodsDetailPropertyView:clickButtonAtIndex:button: skuModel:)]) {
        GoodsDetailSaleInfo * model = nil;
        if (self.dataArray.count>_currentIndexPath.row) {
            model = self.dataArray[_currentIndexPath.row];
        }
        [self.delegate ds_GoodsDetailPropertyView:self clickButtonAtIndex:buttonIndex button:button skuModel:model];
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



@implementation GoodsPropertyItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.backgroundIV];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(15);
        _textLabel.textColor = JXColorFromRGB(0x939393);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
        
        [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
    }
    return self;
}

- (void)setSkuModel:(GoodsDetailSaleInfo *)skuModel{
    _skuModel = skuModel;
    self.textLabel.text = skuModel.info;
    if (skuModel.selected) {
        self.backgroundIV.image = [ImageString(@"home_gooddetail_propertybg_s")  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        self.textLabel.textColor = APP_MAIN_COLOR;
    }else{
        self.backgroundIV.image = [ImageString(@"home_gooddetail_propertybg_n") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        self.textLabel.textColor = JXColorFromRGB(0x939393);
    }
    
}

//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if (selected) {
//        self.backgroundIV.image = [ImageString(@"home_gooddetail_propertybg_s")  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
//        self.textLabel.textColor = APP_MAIN_COLOR;
//    }else{
//        self.backgroundIV.image = [ImageString(@"home_gooddetail_propertybg_n") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
//        self.textLabel.textColor = JXColorFromRGB(0x939393);
//    }
//}

@end


@implementation PropertyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:ImageString(@"public_close_black") forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        
        
        self.coverIV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.coverIV];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(16);
        _textLabel.textColor = JXColorFromRGB(0x797979);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_textLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = JXFont(20);
        _priceLabel.textColor = JXColorFromRGB(0xff5000);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_priceLabel];
        
        _inventoryLabel = [[UILabel alloc]init];
        _inventoryLabel.font = JXFont(16);
        _inventoryLabel.textColor = JXColorFromRGB(0x797979);
        _inventoryLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_inventoryLabel];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(self.mas_top).with.offset(24);
            make.centerX.equalTo(self.mas_right).with.offset(-19);
        }];
        
        [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72, 72));
            make.left.equalTo(self.mas_left).with.offset(12);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.coverIV.mas_centerY).with.offset(-8);
            make.left.equalTo(_coverIV.mas_right).with.offset(20);
            make.height.mas_equalTo(16+kLabelHeightOffset);
            make.right.equalTo(self.mas_right).with.offset(-20);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.coverIV.mas_centerY).with.offset(22);
            make.left.equalTo(_textLabel.mas_left);
            make.height.mas_equalTo(22+kLabelHeightOffset);
            make.width.mas_equalTo(100);
        }];
        
        [self.inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_priceLabel.mas_centerY);
            make.left.equalTo(_priceLabel.mas_right).with.offset(10);
            make.height.mas_equalTo(22+kLabelHeightOffset);
            make.right.equalTo(self.mas_right).with.offset(-20);
        }];
    }
    return self;
}

- (void)setGoodsInfoModel:(DSGoodsDetailInfoModel *)goodsInfoModel{
    _goodsInfoModel = goodsInfoModel;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:goodsInfoModel.minPic] placeholderImage:ImageString(@"public_clearbg_placeholder")];
}

- (void)setSkuModel:(GoodsDetailSaleInfo *)skuModel{
    _skuModel = skuModel;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",skuModel.price.floatValue];
    self.textLabel.text = skuModel.info;
    self.inventoryLabel.text = [NSString stringWithFormat:@"库存：%ld",skuModel.inventoryNum.integerValue];
}

@end


@interface PropertyItemFlowLayout(){
    CGFloat _sumCellWidth ;
}

@end

@implementation PropertyItemFlowLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumCellWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell在本行，这开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    nowWidth = self.sectionInset.left;
    for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
        CGRect nowFrame = attributes.frame;
        nowFrame.origin.x = nowWidth;
        attributes.frame = nowFrame;
        nowWidth += nowFrame.size.width + 10;
    }
    _sumCellWidth = 0.0;
    [layoutAttributes removeAllObjects];
}


@end

@implementation PropertySectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(15);
        _textLabel.text = @"规格";
        _textLabel.textColor = JXColorFromRGB(0x979797);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
        }];
    }
    return self;
}

@end

@implementation PropertySectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = JXFont(15);
        _textLabel.text = @"购买数量";
        _textLabel.textColor = JXColorFromRGB(0x979797);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
        
        _numberButton = [[PPNumberButton alloc]initWithFrame:CGRectZero];
        _numberButton.minValue = 1;
        _numberButton.increaseImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        _numberButton.decreaseImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
        _numberButton.backgroundColor = JXColorFromRGB(0xf8f8f8);
        // 设置最大值
        _numberButton.maxValue = 99;
        _numberButton.editing = NO;
        //        _goodsNumberStepperView.borderColor = APP_MAIN_COLOR;
        // 设置输入框中的字体大小
        _numberButton.inputFieldFont = 10;
        _numberButton.increaseTitle = @"＋";
        _numberButton.decreaseTitle = @"－";
        _numberButton.currentNumber = 1;
        _numberButton.decimalNum = NO;
        __weak typeof (self)weakSelf = self;
        _numberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
            weakSelf.goodsModel.buyNumber = number;
        };
        _numberButton.longPressSpaceTime = CGFLOAT_MAX;
        [self.contentView addSubview:_numberButton];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
        }];
        
        [_numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
        
    }
    return self;
}

- (void)setGoodsModel:(DSGoodsDetailInfoModel *)goodsModel{
    _goodsModel = goodsModel;
    if (goodsModel.isExclusive.integerValue==1||goodsModel.isExclusive.integerValue==2) {
        _numberButton.maxValue = 1;
    }else{
        _numberButton.maxValue = 99;
    }
    _numberButton.currentNumber = goodsModel.buyNumber;
}

@end




