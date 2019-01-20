//
//  DSClassificationMainView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/7/27.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSClassificationMainView.h"
#import "DSClassificationModel.h"

@interface DSClassificationMainView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

//@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, assign) BOOL shouldHandleScrollEvent;  /**< 需要处理滑动事件 */

@end

@implementation DSClassificationMainView
@synthesize currentSelectSection = _currentSelectSection;

static NSString * cellIdentifer = @"contentItem";

static NSString * headerIdentifer = @"sectionheader";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat viewW = frame.size.width;
        _shouldHandleScrollEvent = YES;
        _currentSelectSection = 0;
        self.backgroundColor = JXColorFromRGB(0xffffff);
        [self addSubview:self.collectionView];
        CGFloat collectionViewW = viewW-(12+12);
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CGFloat itemW = (collectionViewW - (_layout.sectionInset.left+_layout.sectionInset.right+_layout.minimumInteritemSpacing*2))/3.0f;
        CGFloat itemH = [ClassificationContentItem getItemHeightWithItemWidth:floor(itemW)];
        [self layoutIfNeeded];
        self.layout.itemSize = CGSizeMake(floor(itemW), itemH);
        self.layout.headerReferenceSize = CGSizeMake(self.collectionView.frameWidth, 30);
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.sectionInset = UIEdgeInsetsMake(10,12, 10, 12);
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count>0 ? _dataArray.count:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataArray.count>0) {
        DSClassificationModel * model = _dataArray[section];
        return model.subClassifications.count>0? model.subClassifications.count:0;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassificationContentItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
//    cell.backgroundColor = JXColorAlpha(255, 0, 0, 0.2);
    if (_dataArray.count>indexPath.section) {
       DSClassificationModel * sectionModel = _dataArray[indexPath.section];
        NSArray * sectionArray = sectionModel.subClassifications;
        if (sectionArray.count>indexPath.item) {
            DSClassificationModel * model =  sectionArray[indexPath.item];
            cell.classificationModel = model;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ClassificationContentSectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifer forIndexPath:indexPath];
        headerView.contentView.backgroundColor = JXColorFromRGB(0xf8f8f8);
        if (self.dataArray.count>indexPath.section) {
            DSClassificationModel * model = _dataArray[indexPath.section];
            headerView.classificationModel = model;
        }
        return headerView;
    }
    return Nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationMainView:didSelectItemaAtIndexPath:model:)]) {
        
        DSClassificationModel * model = self.dataArray[indexPath.section];
        if (model.subClassifications.count>indexPath.row) {
            DSClassificationModel * itemModel = model.subClassifications[indexPath.item];
           [self.delegate ds_classificationMainView:self didSelectItemaAtIndexPath:indexPath model:itemModel];
        }
     
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
        if (self.collectionView.frameHeight>self.collectionView.contentSize.height) {
            //内容视图 小于 collection 的高度 不管点击什么 都不滚动
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
            //区头的布局信息
            UICollectionViewLayoutAttributes * attributes = [self.layout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            if (attributes) {
                if (self.collectionView.contentSize.height-attributes.frame.origin.y<self.collectionView.frameHeight) {
                    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height-self.collectionView.frameHeight) animated:YES];
                }else{
                    [self.collectionView setContentOffset:CGPointMake(0, attributes.frame.origin.y) animated:YES];
                }
                _shouldHandleScrollEvent = NO; //点击切换时 不处理滑动事件
            }
        }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _shouldHandleScrollEvent = YES; //开始拖拽时 处理滑动事件
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_shouldHandleScrollEvent == NO) {
        return;
    }
    NSArray * attributesarray = [self.layout layoutAttributesForElementsInRect:CGRectMake(self.layout.sectionInset.right+20, self.collectionView.contentOffset.y+self.collectionView.frameHeight/2.0, 20, 20)];
    if (attributesarray.count>0) {
        UICollectionViewLayoutAttributes * attributes = attributesarray[0];
        if (attributes&&attributes.indexPath!=nil) {
            if (attributes.indexPath.section!=_currentSelectSection) {
                _currentSelectSection = attributes.indexPath.section;
                if (self.delegate && [self.delegate respondsToSelector:@selector(ds_classificationMainView:selectSection:)]) {
                    [self.delegate ds_classificationMainView:self selectSection:_currentSelectSection];
                }
            }
        }
    }
//    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.layout.sectionInset.right+20, self.collectionView.contentOffset.y+self.collectionView.frameHeight/2.0)];
//    if (indexPath!=nil) {
//        if (indexPath.section!=_currentSelectSection) {
//
//        }
//    }

}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
    //    [self selctSection:_currentSelectSection];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
