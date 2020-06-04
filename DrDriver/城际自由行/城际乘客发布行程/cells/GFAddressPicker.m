//
//  GFAddressPicker.m
//  地址选择器
//
//  Created by 1暖通商城 on 2017/5/10.
//  Copyright © 2017年 1暖通商城. All rights reserved.
//

#import "GFAddressPicker.h"


@interface GFAddressPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *townArray;
@property(nonatomic,strong)NSArray *china_city_dataArr;
@property (strong, nonatomic) UIPickerView *pickView;
@property(nonatomic,assign)NSInteger citySelect;
@end
@implementation GFAddressPicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.provinceArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.townArray = [NSMutableArray array];
        [self getAddressInformation];
        [self setBaseView];
    }
    return self;
}
// 读取本地JSON文件
-(NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)getAddressInformation {
    self.china_city_dataArr =  [self readLocalFileWithName:@"china_city_data"];
    for (NSDictionary *provinceDic in self.china_city_dataArr) {
        [self.provinceArray addObject:provinceDic[@"name"]];
    }
    NSLog(@"china_city_data%@",self.provinceArray);

    NSDictionary *cityDic = self.china_city_dataArr[0];
    for (NSDictionary *cityListDic in cityDic[@"cityList"]) {
        [self.cityArray addObject:cityListDic[@"name"]];
    }
    NSLog(@"china_city_data%@",self.cityArray);
    NSArray *townArr = cityDic[@"cityList"];
    NSDictionary *townDic = townArr[0];
    for (NSDictionary *townListDic in townDic[@"cityList"]) {
        [self.townArray addObject:townListDic[@"name"]];
    }
    NSLog(@"china_city_data%@",self.townArray);
}

- (void)setBaseView {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIColor *color = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    UIColor *btnColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 210 - k_Height_NavBar - Bottom_Height - 40, width, 30)];
    selectView.backgroundColor = color;
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:btnColor forState:0];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn setTitleColor:btnColor forState:0];
    ensureBtn.frame = CGRectMake(width - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:ensureBtn];
    [self addSubview:selectView];
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height - 180 - k_Height_NavBar - Bottom_Height - 40 , width,  180)];
    self.pickView.delegate   = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = color;
    [self addSubview:self.pickView];
    [self.pickView reloadAllComponents];
    [self updateAddress];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height - k_Height_NavBar - Bottom_Height - 40, width, Bottom_Height)];
    bottomView.backgroundColor = color;
    [self addSubview:bottomView];
    
}

- (void)dateCancleAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(GFAddressPickerCancleAction)]) {
        [self.delegate GFAddressPickerCancleAction];
    }
}

- (void)dateEnsureAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(GFAddressPickerWithProvince:city:area:)]) {
        [self.delegate GFAddressPickerWithProvince:self.province city:self.city area:self.area];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:self.font?:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / 3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *cityDic = self.china_city_dataArr[row];
        [self.cityArray removeAllObjects];
        for (NSDictionary *cityListDic in cityDic[@"cityList"]) {
            [self.cityArray addObject:cityListDic[@"name"]];
        }
        NSArray *townArr = cityDic[@"cityList"];
        NSDictionary *townDic = townArr[0];
        [self.townArray removeAllObjects];
        for (NSDictionary *townListDic in townDic[@"cityList"]) {
            [self.townArray addObject:townListDic[@"name"]];
        }
        self.citySelect = row;
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 1) {
        NSDictionary *cityDic = self.china_city_dataArr[self.citySelect];
        NSArray *townArr = cityDic[@"cityList"];
        NSDictionary *townDic = townArr[row];
        [self.townArray removeAllObjects];
        for (NSDictionary *townListDic in townDic[@"cityList"]) {
            [self.townArray addObject:townListDic[@"name"]];
        }
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 2) {
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    [self updateAddress];
}

- (void)updateAddress {
    self.province = [self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    self.city  = [self.cityArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    self.area  = [self.townArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
