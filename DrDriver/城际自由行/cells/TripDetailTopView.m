//
//  TripDetailTopView.m
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TripDetailTopView.h"

@implementation TripDetailTopView
//if ([dic[@"status"] isEqualToString:@"0"] || [dic[@"status"] isEqualToString:@"1"]) {
//    if ([dic[@"remain_seat"] isEqualToString:@"0"]) {
-(instancetype)initWithFrame:(CGRect)frame status:(NSString *)status remain_seat:(NSString *)remain_seat{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatViewStatus:status remain_seat:remain_seat];
    }
    return self;
}

-(void)creatViewStatus:(NSString *)status remain_seat:(NSString *)remain_seat{
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"当前行程";
    self.titleLB.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLB];
    
    self.travelIDLB = [[UILabel alloc] init];
    self.travelIDLB.font = [UIFont systemFontOfSize:15];
    self.travelIDLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    [self addSubview:self.travelIDLB];
    
    self.topArrowImageView = [[UIImageView alloc] init];
    self.topArrowImageView.image = [UIImage imageNamed:@"下拉箭头"];
    [self addSubview:self.topArrowImageView];
    
    self.topLineLB = [[UILabel alloc] init];
    self.topLineLB.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self addSubview:self.topLineLB];
    
    self.dateLB = [[UILabel alloc] init];
    self.dateLB.text = @"----年--月--日";
    self.dateLB.font = [UIFont systemFontOfSize:15];
    self.dateLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.dateLB];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.text = @"发车时间 --:--";
    self.timeLB.font = [UIFont systemFontOfSize:15];
    self.timeLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.timeLB];
    
    self.startCityLB = [[UILabel alloc] init];
    self.startCityLB.text = @"--";
    self.startCityLB.font = [UIFont systemFontOfSize:15];
    self.startCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.startCityLB];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    [self addSubview:self.arrowImageView];
    
    self.endCityLB = [[UILabel alloc] init];
    self.endCityLB.text = @"--";
    self.endCityLB.font = [UIFont systemFontOfSize:15];
    self.endCityLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.endCityLB];

    self.startImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-起始q"]];
    [self addSubview:self.startImageLB];
    
    self.startMapBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if ([status isEqualToString:@"3"]) {
        [self.startMapBtn setImage:[UIImage imageNamed:@"popo"] forState:(UIControlStateNormal)];
    }else{
        [self.startMapBtn setImage:[UIImage imageNamed:@"导航q"] forState:(UIControlStateNormal)];
    }
    [self.startMapBtn addTarget:self action:@selector(mapAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.startMapBtn];
    [self.startMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startCityLB.mas_bottom).offset(5);
        make.right.equalTo(self).mas_offset(-10);
        make.width.and.height.mas_offset(90);
    }];
    
    
    self.startAdLB = [[UILabel alloc] init];
    self.startAdLB.text = @"---------";
    self.startAdLB.font = [UIFont systemFontOfSize:15];
    self.startAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.startAdLB];
    
    self.startAddressLB = [[UILabel alloc] init];
    self.startAddressLB.text = @"-------------------------";
    self.startAddressLB.font = [UIFont systemFontOfSize:9];
    self.startAddressLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    [self addSubview:self.startAddressLB];
    
    self.endImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
    [self addSubview:self.endImageLB];
    
    
    self.endAdLB = [[UILabel alloc] init];
    self.endAdLB.text = @"---------";
    self.endAdLB.font = [UIFont systemFontOfSize:15];
    self.endAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.endAdLB];
    
    self.endAddressLB = [[UILabel alloc] init];
    self.endAddressLB.text = @"-------------------------";
    self.endAddressLB.font = [UIFont systemFontOfSize:9];
    self.endAddressLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    [self addSubview:self.endAddressLB];
    
    self.numberImageView = [[UIImageView alloc] init];
    self.numberImageView.image = [UIImage imageNamed:@"座位"];
    [self addSubview:self.numberImageView];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.travelIDLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.topArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(5);
        make.centerY.equalTo(self.titleLB);
        make.height.and.with.mas_offset(15);
    }];
    
    [self.topLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(1);
        make.width.mas_offset(DeviceWidth - 30);
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self.dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.topLineLB.mas_bottom).offset(10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.topLineLB.mas_bottom).offset(10);
    }];
    
    
    [self.startCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLB.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.endCityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.dateLB.mas_bottom).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.startCityLB);
        make.width.and.height.mas_offset(30);
    }];
    
    
    
    [self.startImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startCityLB.mas_bottom).offset(15);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.startAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.startImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.top.equalTo(self.startAdLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    
    
    [self.endImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startImageLB.mas_bottom).offset(15);
        make.left.equalTo(self).offset(10);
        
    }];
    
    [self.endAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.endImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.top.equalTo(self.endAdLB.mas_bottom);
        make.right.equalTo(self.startMapBtn.mas_left);
    }];
    
    
    
    [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(15);
        make.width.and.height.mas_offset(20);
    }];
    
   
    
    self.numberLB = [[UILabel alloc] init];
    self.numberLB.text = @"已定乘客 -- 位";
    self.numberLB.font = [UIFont systemFontOfSize:15];
    self.numberLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.numberLB];
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberImageView.mas_right).offset(5);
        make.centerY.equalTo(self.numberImageView);
    }];
    
    self.userBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.userBtn setTitle:@"(接送顺序)" forState:(UIControlStateNormal)];
    self.userBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.userBtn setTitleColor:[CYTSI colorWithHexString:@"#f5a623"] forState:(UIControlStateNormal)];
    [self.userBtn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.userBtn];
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberLB);
        make.left.equalTo(self.numberLB.mas_right).offset(5);
        make.height.mas_offset(20);
        make.width.mas_offset(80);
    }];
    
    self.remainderLB = [[UILabel alloc] init];
    self.remainderLB.text = @"剩余座位 -- 位";
    self.remainderLB.font = [UIFont systemFontOfSize:15];
    self.remainderLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self addSubview:self.remainderLB];

    [self.remainderLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.numberLB);
    }];
    
    
    self.startbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.startbtn setTitle:@"开始行程" forState:UIControlStateNormal];
    self.startbtn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.startbtn.layer.cornerRadius=5;
    self.startbtn.layer.masksToBounds=YES;
    self.startbtn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    [self.startbtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startbtn];
    [self.startbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(- DeviceWidth / 4);
        make.width.mas_offset((DeviceWidth - 33) / 2);
        make.height.mas_offset(35);
        make.top.equalTo(self.numberLB.mas_bottom).offset(20);
    }];
    
    
    self.btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"更改" forState:UIControlStateNormal];
    self.btn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.btn.layer.cornerRadius=5;
    self.btn.layer.masksToBounds=YES;
    self.btn.backgroundColor=[CYTSI colorWithHexString:@"#f5a623"];
    [self.btn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(DeviceWidth / 4);
        make.width.mas_offset((DeviceWidth - 33)/2);
        make.height.mas_offset(35);
        make.top.equalTo(self.numberLB.mas_bottom).offset(20);
    }];
    
    self.stopBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopBtn setTitle:@"结束行程" forState:UIControlStateNormal];
    self.stopBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.stopBtn.hidden = YES;
    self.stopBtn.layer.cornerRadius=5;
    self.stopBtn.layer.masksToBounds=YES;
    self.stopBtn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    [self.stopBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(DeviceWidth - 33);
        make.height.mas_offset(35);
        make.top.equalTo(self.numberLB.mas_bottom).offset(20);
    }];
    
    
    self.bottomBGView = [[UILabel alloc] init];
    self.bottomBGView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.bottomBGView.userInteractionEnabled = YES;
    [self addSubview:self.bottomBGView];    
    if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"]) {
        if ([remain_seat isEqualToString:@"0"]) {
            [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(DeviceWidth);
                make.height.mas_offset(10);
                make.top.equalTo(self.startbtn.mas_bottom).offset(10);
                make.centerX.equalTo(self);
            }];
        }else{
            [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(DeviceWidth);
                make.height.mas_offset(62);
                make.top.equalTo(self.startbtn.mas_bottom).offset(10);
                make.centerX.equalTo(self);
            }];
        }
    }else{
        [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(DeviceWidth);
            make.height.mas_offset(10);
            make.top.equalTo(self.startbtn.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
    }
    
    self.findUserBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.findUserBtn setTitle:@"发现匹配乘客" forState:UIControlStateNormal];
    self.findUserBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    self.findUserBtn.layer.cornerRadius=5;
    self.findUserBtn.layer.masksToBounds=YES;
    self.findUserBtn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    [self.findUserBtn addTarget:self action:@selector(findUserClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBGView addSubview:self.findUserBtn];
    [self.findUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_offset(DeviceWidth - 33);
        make.height.mas_offset(35);
        make.top.equalTo(self.bottomBGView.mas_top).offset(7);
    }];
    
    self.redImageLB = [[UILabel alloc] init];
    self.redImageLB.backgroundColor = [UIColor redColor];
    self.redImageLB.layer.cornerRadius = 5;
    self.redImageLB.layer.masksToBounds = 5;
    self.redImageLB.userInteractionEnabled = YES;
    [self.bottomBGView addSubview:self.redImageLB];
    [self.redImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(10);
        make.centerX.equalTo(self.findUserBtn.mas_right);
        make.centerY.equalTo(self.findUserBtn.mas_top);
    }];
    
    self.remarkLB = [[UILabel alloc] init];
    self.remarkLB.text = @"注：当乘客不足时，可以点击按钮筛选可匹配的乘客订单。";
    self.remarkLB.textColor = [UIColor lightGrayColor];
    self.remarkLB.font = [UIFont systemFontOfSize:9];
    [self addSubview:self.remarkLB];
    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.findUserBtn.mas_bottom).offset(5);
    }];
    
    if ([status isEqualToString:@"0"] || [status isEqualToString:@"1"]) {
        if ([remain_seat isEqualToString:@"0"]) {
            self.findUserBtn.hidden = YES;
            self.redImageLB.hidden = YES;
            self.remarkLB.hidden = YES;
        }else{
            self.findUserBtn.hidden = NO;
            self.redImageLB.hidden = NO;
            self.remarkLB.hidden = NO;
        }
    }else{
        self.findUserBtn.hidden = YES;
        self.redImageLB.hidden = YES;
        self.remarkLB.hidden = YES;
    }
    
    self.bottomTitleLB = [[UILabel alloc] init];
    self.bottomTitleLB.font = [UIFont systemFontOfSize:15];
    self.bottomTitleLB.text = @"乘客信息";
    [self addSubview:self.bottomTitleLB];
    [self.bottomTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomBGView.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    
    self.bottomLineLB = [[UILabel alloc] init];
    self.bottomLineLB.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self addSubview:self.bottomLineLB];
    [self.bottomLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bottomTitleLB.mas_bottom).offset(10);
        make.height.mas_offset(1);
        make.width.mas_offset(DeviceWidth - 30);
    }];
    
   
}
-(void)btnAction{
    if (self.takeArr.count != 0) {
        self.btnBlock(self.takeArr, self.sendArr);
    }
}
-(void)mapAction{
    self.mapBlock(self.dic);
}
-(void)startBtnAction{
    self.startBlock();
}
-(void)changeAction{
    self.changeBlock();
}
-(void)stopAction{
    self.stopBlock();
}
-(void)setTravelDate:(NSDictionary *)dic{
    self.dateLB.text = dic[@"travel_date"];
    self.travelIDLB.text = [NSString stringWithFormat:@"行程号:%@",dic[@"travel_id"]];
    self.timeLB.text = [NSString stringWithFormat:@"发车时间 %@",dic[@"travel_time"]];
    self.startCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"start_city"],dic[@"start_county"]];
    self.endCityLB.text = [NSString stringWithFormat:@"%@%@",dic[@"end_city"],dic[@"end_county"]];
    self.startAdLB.text = dic[@"start_name"];
    self.startAddressLB.text = dic[@"start_address"];
    self.endAdLB.text = dic[@"end_name"];
    self.endAddressLB.text = dic[@"end_address"];
    if ([dic[@"fix_num"] isKindOfClass:[NSNull class]]) {
        self.numberLB.text = @"已定乘客0位";
    }else{
        self.numberLB.text = [NSString stringWithFormat:@"已定乘客%@位",dic[@"fix_num"]];
    }
    self.remainderLB.text = [NSString stringWithFormat:@"剩余座位%@位",dic[@"remain_seat"]];
    self.dic = @{@"start_lat":dic[@"start_lat"],@"start_lng":dic[@"start_lng"],@"end_lat":dic[@"end_lat"],@"end_lng":dic[@"end_lng"]};
    if ([dic[@"state"] isEqualToString:@"行程中"]) {
        [self.startMapBtn setImage:[UIImage imageNamed:@"popo"] forState:(UIControlStateNormal)];
        self.startbtn.hidden = YES;
        self.btn.hidden = YES;
        self.stopBtn.hidden = NO;
    }else if ([dic[@"state"] isEqualToString:@"已完成"]){
        self.startbtn.hidden = YES;
        self.btn.hidden = YES;
        self.stopBtn.hidden = NO;
        [self.stopBtn setTitle:@"行程已结束" forState:(UIControlStateNormal)];
        self.stopBtn.backgroundColor = [UIColor lightGrayColor];
        [self.stopBtn setTintColor:[UIColor blackColor]];
        self.stopBtn.userInteractionEnabled = NO;
    }else if ([dic[@"state"] isEqualToString:@"已取消"]){
        self.startbtn.hidden = YES;
        self.btn.hidden = YES;
    }
    
    
    if (![dic[@"recive_list"] isKindOfClass:[NSNull class]]) {
        self.takeArr = [NSArray arrayWithArray:dic[@"recive_list"]];
    }
    if (![dic[@"send_list"] isKindOfClass:[NSNull class]]) {
        self.sendArr = [NSArray arrayWithArray:dic[@"send_list"]];
    }
    if (self.takeArr.count == 0) {
        self.userBtn.hidden = YES;
    }else{
        self.userBtn.hidden = NO;
    }
    
}
-(void)findUserClicked{
    self.findUserBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
