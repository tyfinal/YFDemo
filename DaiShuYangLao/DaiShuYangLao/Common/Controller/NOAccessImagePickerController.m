//
//  NOAccessImagePickerController.m
//  YJRRT
//
//  Created by MOCO on 16/4/26.
//  Copyright © 2016年 jimneylee. All rights reserved.
//

#import "NOAccessImagePickerController.h"

@interface NOAccessImagePickerController ()

@end

@implementation NOAccessImagePickerController
@synthesize cLabelString;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, boundsWidth, 64);
    headView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:headView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //取消
    UIView *cacheView = [[UIView alloc] initWithFrame:CGRectMake(boundsWidth - 50, (64 - 40)/2 + 10, 40, 40)];
    cacheView.backgroundColor = [UIColor clearColor];
    [headView addSubview:cacheView];
    
    UIImageView *cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake((40-20)/2, (40-20)/2, 20, 20)];
    cancelImage.image = [UIImage imageNamed:@"classDetail_cancel"];
    [cacheView addSubview:cancelImage];
    
    cacheView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    [cacheView addGestureRecognizer:tapRecognizer];
    
    //noaccesss
    UIImageView *noaccesssImageView = [[UIImageView alloc] init];
    noaccesssImageView.image = [UIImage imageNamed:@"noaccesss"];
    noaccesssImageView.frame = CGRectMake((boundsWidth - 553/2)/2, (boundsHeight - 420/2)/2 - 64, 553/2, 420/2);
    [self.view addSubview:noaccesssImageView];
    
    //请在iPhone的"设置－隐私－照片"选项中，允许人人通访问你的手机相册
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(noaccesssImageView.frameX + 5, noaccesssImageView.frameBottom + 20, noaccesssImageView.frameWidth, 50);
    tipLabel.text = cLabelString;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:1.0] ;
    [self.view addSubview:tipLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:cLabelString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [cLabelString length])];
    [tipLabel setAttributedText:attributedString1];
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
