//
//  YJGuideController.m
//  YJRRT
//
//  Created by keiyi on 16-3-6.
//  Copyright © 2016年 Think_lion. All rights reserved.
//

#import "YJGuideController.h"

@interface YJGuideController ()<UIScrollViewDelegate>

@property (nonatomic,weak)UIPageControl* pageControl;

@property (nonatomic,weak)UIScrollView* scrollView;
@end

@implementation YJGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self changeNavigationBarTransparent:YES];
    //1.创建一个scrollView显示所有新特性的图片
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    self.scrollView = scrollView;
    
    //添加图片到scrollView中
    CGFloat scrollW = scrollView.frameWidth;
    CGFloat scrollH = scrollView.frameHeight;
    
    NSArray *guideArr = @[@"01",@"02",@"03"];
    
    for (int i = 0; i < [guideArr count]; i++) {
        UIImageView* imageView = [[UIImageView alloc]init];
        
        imageView.frameWidth = scrollW;
        imageView.frameHeight = scrollH;
        imageView.frameY = 0;
        imageView.frameX = i * scrollW;
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guidance_%@",guideArr[i]]];
        
        [scrollView addSubview:imageView];
        //如果是最后一个imageView,就往里面添加其他内容
        if (i == [guideArr count] - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    
    //3设置scrollView的其他属性
    //如果想要某个方向不能滚动，那个这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake([guideArr count] * scrollW, 0);
    scrollView.bounces = NO;//去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    //4添加pageCntrol: 分页 展示目前看的第几页
    UIPageControl* pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = [guideArr count];
    pageControl.currentPageIndicatorTintColor = JXColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = JXColor(189, 189, 189);
    pageControl.frameCenterX = scrollW * 0.5;
    pageControl.frameCenterY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double page = scrollView.contentOffset.x /scrollView.frameWidth;
    //四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView*)imageView{
    //开启交互功能
    imageView.userInteractionEnabled = YES;
    
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setTitleColor:JXColorFromRGB(0x757575) forState:UIControlStateNormal];
    [startBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    startBtn.titleLabel.font = JXFont(18.0f);
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ceil(boundsWidth*0.45));
        make.height.equalTo(startBtn.mas_width).multipliedBy(0.26);
        make.centerX.equalTo(imageView.mas_centerX);
        make.bottom.equalTo(imageView.mas_bottom).with.offset(-ceil(0.13*boundsHeight));
    }];
    startBtn.layer.cornerRadius = 5.0f;
    startBtn.layer.masksToBounds = YES;
    startBtn.layer.borderWidth = 1.0f;
    startBtn.layer.borderColor = JXColorFromRGB(0x757575).CGColor;
}

- (void)startClick{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"startLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [DSAppDelegate goToHomePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    return NO;
}

//当前viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
