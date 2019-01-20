//
//  DSAreaPickerView.m
//  DaiShuYangLao
//
//  Created by tyfinal on 2018/6/12.
//  Copyright © 2018年 tyfinal. All rights reserved.
//

#import "DSAreaPickerView.h"
#import "DSAreaModel.h"
#import "DSAreaDataHelper.h"

static const NSUInteger kSectionCount = 3;
@interface DSAreaPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger currentSelectRows[kSectionCount];
    NSInteger scrollToRows[kSectionCount];
    NSArray * sectionDataArray[kSectionCount];
}



@end

@implementation DSAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 32)];
        accessoryView.backgroundColor = JXColorFromRGB(0xeeeeee);
        for (int i = 0; i < 2; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 10000+i;
            button.frame = CGRectMake(10+(boundsWidth-80)*i, 0, 60, 32);
            [button setTitle:@[@"取消",@"确定"][i] forState:normal];
            [button addTarget:self action:@selector(pickerHasDone:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = i+1;
            button.titleLabel.font = JXFont(13.0f);
            [button setTitleColor:APP_MAIN_COLOR forState:normal];
            [accessoryView addSubview:button];
        }
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, accessoryView.frameBottom, boundsWidth, 216)];
        //    HGPickerView
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        [self addSubview:accessoryView];
    }
    return self;
}

- (void)commonInit{
    for (NSInteger i=0; i<kSectionCount; i++) {
        currentSelectRows[i] = 0;
        scrollToRows[i] = 0;
        sectionDataArray[i] = [NSArray array];
    }
\
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
    sectionDataArray[0] = _dataArray;
    [self reloadSectionDataWithComponent:0 row:0];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)reloadData{
     [self.pickerView reloadAllComponents];
}

//- (void)reloadData{
//    for (NSInteger i=0; i<2; i++) {
//        currentSelectRows[i] = 0;
//        scrollToRows[i] = 0;
//    }
//
//    NSArray * areaListArray = [[DSAreaDataHelper shareInstance]getAreaArray];
//    if (areaListArray.count>0) {
//        for (NSInteger i=0; i<kSectionCount; i++) {
//            if (sectionDataArray[i].count>currentSelectRows[i]) {
//                //记录的行数值必须小于实际拥有的总行数 否则导致崩溃
//
//            }
//        }
//    }
//
//    sectionDataArray[0]= ; //省
//    if (sectionDataArray[0].count>currentSelectRows[0]) {
//        DSAreaModel * provinceModel = sectionDataArray[0][currentSelectRows[0]];
//        sectionDataArray[1] = provinceModel.child; //市
//        if (sectionDataArray[1].count>currentSelectRows[1]) {
//            DSAreaModel * cityModel = sectionDataArray[1][currentSelectRows[1]];
//            sectionDataArray[2] = cityModel.child; //区
//        }
//    }
//    [self.pickerView reloadAllComponents];
//
//
//    for (NSInteger i=0; i<kSectionCount; i++) {
//        if (sectionDataArray[i].count>currentSelectRows[i]) {
//            [self.pickerView selectRow:currentSelectRows[i] inComponent:i animated:YES];
//        }
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView * myView = nil;
    if (view) {
        myView = view;
    }else{
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, boundsWidth/3, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        
        DSAreaModel * areaModel = sectionDataArray[component][row];
        label.text = areaModel.name;
        
        label.font = JXFont(13.0);
        label.textColor = JXColorFromRGB(0x262626);
        myView = label;
    }
    
    return myView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return kSectionCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return sectionDataArray[component].count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self reloadSectionDataWithComponent:component row:row];
    
    
    
    
//
//    if (component == 0) {
//        DSAreaModel * model = sectionDataArray[component][row];
//        scrollToRows[component] = row;
//        cityArray = [JXAreaModel getCitiesArrayWithProvinceId:model.mid];
//        //        zoneArray = [JXAreaModel getZonesArrayWithCitiesId:[cityArray[0] mid]];
//        [_pickerView reloadAllComponents];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
//        //        [pickerView selectRow:0 inComponent:2 animated:YES];
//        scrollToRows[1] = 0;
//        //        scrollToRows[2] = 0;
//    }else if (component == 1){
//        scrollToRows[component] = row;
//        //        JXAreaModel * model = cityArray[row];
//        //        zoneArray = [JXAreaModel getZonesArrayWithCitiesId:model.mid];
//        //        [_pickerView reloadComponent:2];
//        //        [pickerView selectRow:0 inComponent:2 animated:YES];
//        //        scrollToRows[2] = 0;
//    }/*else{
//      scrollToRows[component] = row;
//      }*/
}

//更新下级区的数据
- (void)reloadSectionDataWithComponent:(NSUInteger)component row:(NSUInteger)row{
    if (component!=kSectionCount-1) {
        //不是最后一个区
        if ([sectionDataArray[component] count]>row) {
            currentSelectRows[component] = row;
            DSAreaModel * areaModel = sectionDataArray[component][row];
            NSArray * subArray = areaModel.child;
            if (kSectionCount>component+1) { //总区数 必须大于等于 compnent+2
                sectionDataArray[component+1] = subArray; //更新所选区的下级区数据
                [self.pickerView reloadComponent:component+1]; //更新数据后 刷新
                
                if (subArray.count>0) {
                    [self.pickerView selectRow:0 inComponent:component+1 animated:YES]; //默认选中第一行
                    currentSelectRows[component+1] = 0;
                    [self reloadSectionDataWithComponent:component+1 row:0]; //递归下级区
                }
            }
        }
    }else{
        if (sectionDataArray[kSectionCount-1].count>row) {
             [self.pickerView selectRow:row inComponent:kSectionCount-1 animated:YES];
            currentSelectRows[kSectionCount-1] = row;
        }
        JXLog(@"已经递归到最后一个区了");
    }
}

- (void)pickerHasDone:(UIButton *)button{
    NSInteger index = button.tag-10000;
    NSMutableDictionary * parms = nil;
    if (index==1) {
        parms  = [NSMutableDictionary dictionary];
        
        NSString * key = @"";
        NSInteger currentRow = 0;
        NSArray * sectionArray = nil;
        for (NSInteger i=0; i<kSectionCount; i++) {
            key = [NSString stringWithFormat:@"section_%ld_key",i+1];
            currentRow = currentSelectRows[i]; //获取当前选中的行
            sectionArray = sectionDataArray[i]; //
            if (sectionArray.count>currentRow) {
               parms[key] = sectionArray[currentRow];
            }else{
                parms[key] = @"";
            }
        }
//        for (NSInteger i=0; i<kSectionCount; i++) {
//            currentSelectRows[i] = scrollToRows[i];
//        }
//        parms[@"province"] = proviceArray[currentSelectRows[0]];
//        parms[@"city"] = cityArray[currentSelectRows[1]];
        //        parms[@"zone"] = zoneArray[currentSelectRows[2]];
    }

    
    if (self.AddressPickerClickButtonAtIndex) {
        self.AddressPickerClickButtonAtIndex(index, parms);
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
