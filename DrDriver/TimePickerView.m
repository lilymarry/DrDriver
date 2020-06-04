//
//  IBTimePickerView.m
//  O2
//
//  Created by 李士杰 on 15/5/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TimePickerView.h"
@interface TimePickerView ()
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIButton *chooseDateButton;
@property(nonatomic,strong)UIButton *cancleBTN;

@end
@implementation TimePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllview];
    }
    return self;
}


-(void)addAllview{
    self.backgroundColor = [UIColor grayColor];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 35, self.frame.size.width, self.frame.size.height);
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //修改pickview的背景色
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //修改字体颜色
   // [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
     [self.datePicker setValue:[UIColor blackColor] forKey:@"textColor"];
    NSDate *nowDate = [NSDate date];
    
    self.datePicker.maximumDate = nowDate;//最大选择日期是今天日期
    
    self.chooseDateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.chooseDateButton.frame = CGRectMake(self.frame.size.width - 60,0, 60, 35);
    [self.chooseDateButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.chooseDateButton setTitleColor: [UIColor whiteColor]forState:(UIControlStateNormal)];
    [self.chooseDateButton addTarget:self action:@selector(getDate) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.chooseDateButton];
    
    self.cancleBTN = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.cancleBTN.frame = CGRectMake(0,0, 60, 35);
    [self.cancleBTN setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.cancleBTN setTitleColor: [UIColor redColor]forState:(UIControlStateNormal)];
    [self.cancleBTN addTarget:self action:@selector(cancelDate) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.cancleBTN];
    [self addSubview:_datePicker];
}

//点击完成按钮
-(void)getDate{
    NSDate *selectDate = [self.datePicker date];//选择日期
        [self.delegate getTime:selectDate];
}
- (void)cancelDate
{
    
    [self.delegate cancleTime];
}
-(void)dealloc{
    self.delegate = nil;
}
@end
