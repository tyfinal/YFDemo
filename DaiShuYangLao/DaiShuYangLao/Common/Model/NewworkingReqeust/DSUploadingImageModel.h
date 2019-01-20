//
//  DSUploadingImageModel.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/22.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSUploadingImageModel : DSBaseModel

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, copy) NSData * imageData;
@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, copy) NSString * upload_key;  //上传时对应的key值
@property (nonatomic, copy) NSString * mime;

@end
