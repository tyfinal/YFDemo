//
//  DSClassificationContentView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/23.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationContentView.h"
#import "DSClassificationModel.h"

@interface DSClassificationContentView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end


static NSString * cellIdentifer = @"contentItem";

static NSString * headerIdentifer = @"sectionheader";


@implementation DSClassificationContentView
@synthesize currentSelectSection = _currentSelectSection;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat viewW = frame.size.width;
        _currentSelectSection = 0;
        self.backgroundColor = JXColorFromRGB(0xffffff);
        [self addSubview:self.collectionView];
        CGFloat collectionViewW = viewW-(13+12);
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 13, 0, 12));
        }];
        
        CGFloat itemW = (collectionViewW - (_layout.sectionInset.left+_layout.sectionInset.right+_layout.minimumInteritemSpacing*2))/3.0f;
        CGFloat itemH = [ClassificationContentItem getItemHeightWithItemWidth:floor(itemW)];
        [self layoutIfNeeded];
        self.layout.itemSize = CGSizeMake(floor(itemW), itemH);
//        self.layout.headerReferenceSize = CGSizeMake(self.collectionView.frameWidth, 50);
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 14;
        
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ClassificationContentItem class] forCellWithReuseIdentifier:cellIdentifer];
        [_collectionView registerClass:[ClassificationContentSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifer];
    }
    return _collectionView;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return _dataArray.count>0?_dataArray.count:0;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (_dataArray.count>0) {
//        DSClassificationModel * model = _dataArray[section];
//        return model.subClassifications.count>0? model.subClassifications.count:0;
//    }
//    return 0;
    return _dataArray.count>0?_dataArray.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassificationContentItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    if (_dataArray.count>0) {
        DSClassificationModel * model = _dataArray[indexPath.item];
        cell.classificationModel = model;
    }
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        ClassificationContentSectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifer forIndexPath:indexPath];
//        if (self.dataArray.count>indexPath.section) {
//            DSClassificationModel * model = _dataArray[indexPath.section];
//            headerView.classificationModel = model;
//        }
//        return headerView;
//    }
//    return Nil;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DSClassificationModel * model = self.dataArray[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationContentView:didSelectItemaAtIndexPath:model:)]) {
        [self.delegate ds_classificationContentView:self didSelectItemaAtIndexPath:indexPath model:model];
    }
}

- (void)setCurrentSelectSection:(NSInteger)currentSelectSection{
    if (currentSelectSection!=_currentSelectSection) {
        _currentSelectSection = currentSelectSection;
        [self selctSection:_currentSelectSection];
    }
}

- (void)selctSection:(NSInteger)section{
    if (_dataArray.count>section) {
        UICollectionViewLayoutAttributes * attributes = [self.layout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (attributes) {
            [self.collectionView setContentOffset:CGPointMake(0, attributes.frame.origin.y-attributes.frame.size.height) animated:YES];
//            [self.collectionView scrollRectToVisible:attributes.frame animated:YES];
        }
        
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
}

- (NSInteger)currentSelectSection{
    CGPoint contentOffset = self.collectionView.contentOffset;
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(contentOffset.x, contentOffset.y+(boundsHeight-KTabbarHeight-kNavigationBarHeight)/2.0)];
    if (self.dataArray.count>indexPath.section) {
        return indexPath.section;
    }
    return 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y<0) {
        //向下拉
        if (scrollView.contentOffset.y<=-100) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationContentView:loadPage:)]) {
                [self.delegate ds_classificationContentView:self loadPage:-1];
            }
        }
    }else{
        if (scrollView.contentSize.height<=scrollView.frameHeight){
            //内容不足
            if (scrollView.contentOffset.y>=100) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationContentView:loadPage:)]) {
                    [self.delegate ds_classificationContentView:self loadPage:1];
                }
            }
        }else{
            //内容大于scrollView高度
            if (scrollView.contentOffset.y+scrollView.frameHeight>=scrollView.contentSize.height+100) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationContentView:loadPage:)]) {
                    [self.delegate ds_classificationContentView:self loadPage:1];
                }
            }
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
//    [self selctSection:_currentSelectSection];
}


@end


@implementation ClassificationContentItem
static CGFloat titleFontSize = 14.0;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coverIV = [[UIImageView alloc]init];
//        self.coverIV.backgroundColor = JXColorAlpha(255, 0, 0, 0.2);
//        self.coverIV.backgroundColor = [UIColor redColor];
        self.coverIV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.coverIV];
        
        UILabel * label = [[UILabel alloc]init];
        label.font = JXFont(floor(titleFontSize*ScreenAdaptFator_W));
//        label.backgroundColor = [UIColor greenColor];
        label.textColor = JXColorFromRGB(0x141414);
        label.textAlignment = NSTextAlignmentCenter;
        self.classificationNameLabel = label;
        [self.contentView addSubview:label];
        
        [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(floor(9*ScreenAdaptFator_W));
            make.right.equalTo(self.contentView.mas_right).with.offset(-floor(9*ScreenAdaptFator_W));
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.height.equalTo(_coverIV.mas_width).multipliedBy(1.0);
        }];
        
        [self.classificationNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(3);
            make.right.equalTo(self.contentView.mas_right).with.offset(-3);
            make.height.mas_equalTo(kLabelHeightOffset+14);
            make.top.equalTo(_coverIV.mas_bottom).with.offset(15-kLabelHeightOffset/2.0);
        }];
        
    }
    return self;
}

- (void)setClassificationModel:(DSClassificationModel *)classificationModel{
    _classificationModel = classificationModel;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:classificationModel.icon] placeholderImage:ImageString(@"public_clearbg_placeholder")];
    self.classificationNameLabel.text = classificationModel.name;
}

+ (CGFloat)getItemHeightWithItemWidth:(CGFloat)itemWidth{
    CGFloat coverW = itemWidth-floor(9*ScreenAdaptFator_W)*2;
    CGFloat coverH = coverW*1.0;
    return 10+coverH+15+11+10;
}


@end

@implementation ClassificationContentSectionHeaderView
static CGFloat kSectionTitleFontSize = 15;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _sectionTitleLabel = [[UILabel alloc]init];
        _sectionTitleLabel.font = JXFont(floor(kSectionTitleFontSize*ScreenAdaptFator_W));
        _sectionTitleLabel.textColor = JXColorFromRGB(0x666666);
        _sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_sectionTitleLabel];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        
        [self.sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(16);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(kLabelHeightOffset+11);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setClassificationModel:(DSClassificationModel *)classificationModel{
    _classificationModel = classificationModel;
    self.sectionTitleLabel.text = classificationModel.name;
}

@end

