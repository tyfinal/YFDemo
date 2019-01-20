//
//  DSHttpHeader.h
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/11.
//  Copyright © 2018年 tyfinal. All rights reserved.
///Users/yueliangsong/Desktop/袋鼠养老Git/DaiShuYangLao/DaiShuYangLao

#ifndef DSHttpHeader_h
#define DSHttpHeader_h


#endif /* DSHttpHeader_h */

// extraInfo 额外信息
typedef void(^completeBlock)(id info ,BOOL succeed,id extraInfo);

//使用生产环境时 需将ATS 设置为 NO,并添加Allow Arbitrary Loads in Web Content 并设置为YES 
#ifdef DEBUG
#define IS_Release NO    //测试环境
#else
#define IS_Release YES  //生产环境  使用ad_hoc发布测试版本时可将值设置为NO 并修改ATS 为YES 删除web content
#endif

#define DS_APP_SERVER (IS_Release==NO) ? @"http://api.sit.dscs123.com:8081/v1/" : @"https://api.dscs123.com/v1/"

////DEBUG  模式下打印日志,当前行
//#ifdef DEBUG
//#   define DS_APP_SERVER @"http://api.sit.dscs123.com:8081/v1/" //测试
//#else
//#   define DS_APP_SERVER @"https://api.dscs123.com/v1/" //生产
//#endif


#define kAlipay_App_Id  @"2018060260315562"

#define KAlipay_App_Public_key @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqXCqhq6GSWbj8eYIt5Vu8w7Z3GM/iKxpEfTCuD1VUhNGOctpekGz6TL1zXZma/eF+X1Iy8T6XZfNEfy3FibO2GoxuVoQ7pAOS7FuBhXuDTstRxRBxpeOM87Hrbd5HjHkFeIQI47Pbu8PtP7HtiKkoScErP/jsOLcT2jL8YxqpKQ/56ysrPqfz7gtTIqHYEQNJY7q+OOGEN2OY7MY/VQJc1QRPrfu0y6oYsPAmZAkBixbwdpk7nYKU+e6f5cA85y0wKJvycPDJtd6nvl/KQuaOcTJQFIWvKICJoL2ieLoSQhx2rh6ywpNb8NfETY0HEOEDAU+oFiGQ22SGai/KmF9jwIDAQAB"


