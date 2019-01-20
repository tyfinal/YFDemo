//
//  DSGoodsDetailsHeaderView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/6.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSGoodsDetailsHeaderView.h"
#import "DSBannerModel.h"
@interface DSGoodsDetailsHeaderView()<SDCycleScrollViewDelegate>{
    
}

@property (nonatomic, strong) SDCycleScrollView * bannerScollView;
@property (nonatomic, strong) UIView * pageControlView;
@property (nonatomic, strong) UILabel * pageLabel;

@end

@implementation DSGoodsDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JXColorFromRGB(0xf8f8f8);
        self.bannerScollView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        // 网络加载 --- 创建带标题的图片轮播器
        _bannerScollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"public_banner_placeholder"]];
        _bannerScollView.delegate = self;
        _bannerScollView.backgroundColor = [UIColor whiteColor];
        _bannerScollView.autoScroll = NO;
        _bannerScollView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerScollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        [self addSubview:_bannerScollView];
        
        _pageControlView = [[UIView alloc]initWithFrame:CGRectZero];
        _pageControlView.backgroundColor = JXColorAlpha(115, 128, 119, 0.5);
        [self addSubview:_pageControlView];
        
        _pageLabel = [[UILabel alloc]init];
        _pageLabel.font = JXFont(12);
        _pageLabel.textColor = JXColorFromRGB(0xffffff);
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [_pageControlView addSubview:_pageLabel];
        _pageControlView.hidden = YES;
        
        [_bannerScollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12+kLabelHeightOffset);
            make.centerY.equalTo(_pageControlView.mas_centerY);
            make.left.equalTo(_pageControlView.mas_left).with.offset(12);
            make.right.equalTo(_pageControlView.mas_right).with.offset(-12);
        }];
        
        [_pageControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.mas_equalTo(23);
            make.centerY.equalTo(self.mas_bottom).with.offset(-(15+23));
        }];
        
        [self layoutIfNeeded];
        _pageControlView.layer.cornerRadius = _pageControlView.frameHeight/2.0f;
        _pageLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setBannersArray:(NSArray *)bannersArray{
    _bannersArray = bannersArray;
    NSMutableArray * mu = @[].mutableCopy;
    if (bannersArray.count>0) {
        for (DSBannerModel  * bannerModel in bannersArray) {
            if ([bannerModel.pic isNotBlank]) {
                [mu addObject:bannerModel.pic];
            }else{
                [mu addObject:@"banner_empty_bg"]; //添加默认图片
            }
        }
    }
    _bannerScollView.imageURLStringsGroup = mu;
    if (mu.count>0) {
        _pageControlView.hidden = NO;
        _pageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,mu.count];
    }else{
        _pageControlView.hidden = YES;
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (_bannersArray.count>0) {
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,_bannersArray.count];
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
