//
//  ChangeSeatingCapacityView.m
//  DrDriver
//
//  Created by fy on 2019/2/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ChangeSeatingCapacityView.h"

@implementation ChangeSeatingCapacityView

-(instancetype)initWithFrame:(CGRect)frame Number:(NSString *)number pintuan:(NSString *)pintuanStr yikojia:(NSString *)yikojiaStr remark:(NSString *)remarkStr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatViewNumber:number pintuan:pintuanStr yikojia:yikojiaStr remark:remarkStr];
    }
    return self;
}

-(void)creatViewNumber:(NSString *)number pintuan:(NSString *)pintuanStr yikojia:(NSString *)yikojiaStr remark:(NSString *)remarkStr{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(DeviceWidth - 30);
        make.height.mas_offset(350);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-80);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"更改当前信息";
    [self.bgView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    UILabel *titleLineLB = [[UILabel alloc] init];
    titleLineLB.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:titleLineLB];
    [titleLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).mas_offset(15);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_offset(1);
        make.width.mas_offset(DeviceWidth - 40);
    }];
    //  剩余座位数
    self.capacityTitleLB = [[UILabel alloc] init];
    self.capacityTitleLB.text = @"剩余座位数";
    [self.bgView addSubview:self.capacityTitleLB];
    [self.capacityTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLineLB.mas_bottom).offset(20);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    self.capacityTF = [[UITextField alloc] init];
    self.capacityTF.placeholder = @"座位数";
    self.capacityTF.keyboardType = UIKeyboardTypeNumberPad;
    self.capacityTF.text = number;
    [self.bgView addSubview:self.capacityTF];
    [self.capacityTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.capacityTitleLB);
        make.left.equalTo(self.capacityTitleLB.mas_right);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    
    UILabel *linelb = [[UILabel alloc] init];
    linelb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:linelb];
    [linelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.capacityTF.mas_bottom).offset(1);
        make.height.mas_offset(1);
        make.left.and.right.equalTo(self.capacityTF);
    }];
    
    UILabel *capacityLB = [[UILabel alloc] init];
    capacityLB.text = @"位";
    [self.bgView addSubview:capacityLB];
    [capacityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.capacityTF);
        make.left.equalTo(self.capacityTF.mas_right);
    }];
    
    //拼团价格
    UILabel *pintuanTitleLB = [[UILabel alloc] init];
    pintuanTitleLB.text = @"拼团价位";
    [self.bgView addSubview:pintuanTitleLB];
    [pintuanTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.capacityTitleLB.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    self.pintuanTF = [[UITextField alloc] init];
    self.pintuanTF.placeholder = @"拼团价";
    self.pintuanTF.keyboardType = UIKeyboardTypeNumberPad;
    self.pintuanTF.text = pintuanStr;
    [self.bgView addSubview:self.pintuanTF];
    [self.pintuanTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pintuanTitleLB);
        make.left.equalTo(pintuanTitleLB.mas_right);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    
    UILabel *pintuanlinelb = [[UILabel alloc] init];
    pintuanlinelb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:pintuanlinelb];
    [pintuanlinelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pintuanTF.mas_bottom).offset(1);
        make.height.mas_offset(1);
        make.left.and.right.equalTo(self.pintuanTF);
    }];
    
    UILabel *pintuanLB = [[UILabel alloc] init];
    pintuanLB.text = @"元/人";
    [self.bgView addSubview:pintuanLB];
    [pintuanLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pintuanTF);
        make.left.equalTo(self.pintuanTF.mas_right);
    }];
    
    //一口价包车
    UILabel *yikojiaTitleLB = [[UILabel alloc] init];
    yikojiaTitleLB.text = @"一口价包车";
    [self.bgView addSubview:yikojiaTitleLB];
    [yikojiaTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pintuanTitleLB.mas_bottom).offset(15);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    self.yikojiaTF = [[UITextField alloc] init];
    self.yikojiaTF.placeholder = @"包车价";
    self.yikojiaTF.keyboardType = UIKeyboardTypeNumberPad;
    self.yikojiaTF.text = yikojiaStr;
    [self.bgView addSubview:self.yikojiaTF];
    [self.yikojiaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yikojiaTitleLB);
        make.left.equalTo(yikojiaTitleLB.mas_right);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    
    UILabel *yikojialinelb = [[UILabel alloc] init];
    yikojialinelb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:yikojialinelb];
    [yikojialinelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yikojiaTF.mas_bottom).offset(1);
        make.height.mas_offset(1);
        make.left.and.right.equalTo(self.yikojiaTF);
    }];
    
    UILabel *yikojiaLB = [[UILabel alloc] init];
    yikojiaLB.text = @"元";
    [self.bgView addSubview:yikojiaLB];
    [yikojiaLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yikojiaTF);
        make.left.equalTo(self.yikojiaTF.mas_right);
    }];
    
    //备注
    self.remarkLB = [[UILabel alloc] init];
    self.remarkLB.text = @"备注:(选填)";
    [self.bgView addSubview:self.remarkLB];
    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yikojiaTitleLB.mas_bottom).offset(25);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    self.remarkTV=[[UITextView alloc]init];
    self.remarkTV.delegate=self;
    self.remarkTV.layer.cornerRadius=3;
    self.remarkTV.layer.masksToBounds=YES;
    self.remarkTV.text = remarkStr;
    self.remarkTV.backgroundColor=[CYTSI colorWithHexString:@"#eeeeee"];
    [self.bgView addSubview:self.remarkTV];
    [self.remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(self.bgView.mas_right).with.offset(-16);
        make.height.equalTo(@82);
        make.top.equalTo(self.remarkLB.mas_bottom).offset(10);
    }];
    
    self.placeHolderLable=[[UILabel alloc]init];
    self.placeHolderLable.textColor=[CYTSI colorWithHexString:@"#999999"];
    self.placeHolderLable.font=[UIFont systemFontOfSize:12];
    self.placeHolderLable.text=@"请输入...";
    [self.remarkTV addSubview:self.placeHolderLable];
    [self.placeHolderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(self.remarkTV.mas_top).with.offset(7);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    if (remarkStr.length > 0) {
        self.placeHolderLable.hidden = YES;
    }
    
    self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.bgView addSubview:self.cancelBtn];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0]];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.bgView).offset(-10);
        make.left.equalTo(self.bgView.mas_centerX).offset(10);
    }];
    
    self.coffimBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.bgView addSubview:self.coffimBtn];
    self.coffimBtn.layer.cornerRadius = 5;
    self.coffimBtn.layer.masksToBounds = YES;
    [self.coffimBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.coffimBtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0]];
    [self.coffimBtn addTarget:self action:@selector(coffimAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.coffimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.bgView).offset(-10);
        make.right.equalTo(self.bgView.mas_centerX).offset(-10);
    }];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.remarkTV) {
        if ([self.remarkTV.text length] == 0) {
            [self.placeHolderLable setHidden:NO];
        }else{
            [self.placeHolderLable setHidden:YES];
        }
    }
}
-(void)cancelAction{
    self.cancelBlock(self.capacityTF.text, self.remarkTV.text, self.pintuanTF.text, self.yikojiaTF.text);
}
-(void)coffimAction{
    self.coffimBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
