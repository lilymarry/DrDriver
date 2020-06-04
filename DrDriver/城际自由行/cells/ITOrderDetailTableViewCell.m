//
//  ITOrderDetailTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITOrderDetailTableViewCell.h"
#import "SpeechSynthesizer.h"

@implementation ITOrderDetailTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor =TABLEVIEW_BACKCOLOR;
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        
        self.headerImageView = [[UIImageView alloc] init];
        self.headerImageView.layer.cornerRadius = 20;
        self.headerImageView.layer.masksToBounds = YES;
        self.headerImageView.backgroundColor = TABLEVIEW_BACKCOLOR;
        [self.bgView addSubview:self.headerImageView];
        
        self.userNameLB = [[UILabel alloc] init];
        self.userNameLB.text = @"------";
        [self.bgView addSubview:self.userNameLB];
        
        self.cyStarView=[[CYStarView alloc]init];
        [self.cyStarView setViewWithNumber:5 width:15 space:2 enable:NO];
        [self.bgView addSubview:self.cyStarView];
        
        
        UITapGestureRecognizer *stateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        self.stateLB = [[UILabel alloc] init];
        [self.stateLB addGestureRecognizer:stateTap];
        self.stateLB.font = [UIFont systemFontOfSize:15];
        self.stateLB.text = @"-----";
        self.stateLB.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.stateLB];
        
        self.phoneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.phoneBtn setTitle:@"联系乘客" forState:(UIControlStateNormal)];
        [self.phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.phoneBtn setImage:[UIImage imageNamed:@"电话"] forState:(UIControlStateNormal)];
        [self.phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.phoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.phoneBtn];
        
        
        self.vipLb = [[UILabel alloc] init];
        self.vipLb.font = [UIFont systemFontOfSize:15];
        self.vipLb.textColor = [CYTSI colorWithHexString:@"#f5a623"];
        [self.bgView addSubview:self.vipLb];
        
        self.vipImageView = [[UIImageView alloc] init];
        self.vipImageView.image = [UIImage imageNamed:@"VIP"];
        [self.bgView addSubview:self.vipImageView];
        
        self.vipLb.hidden = YES;
        self.vipImageView.hidden = YES;
        
        
        self.idCarLB = [[UILabel alloc] init];
        self.idCarLB.font = [UIFont systemFontOfSize:15];
        self.idCarLB.text = @"身份证号:---";
        [self.bgView addSubview:self.idCarLB];
        
        self.phoneNumberLB = [[UILabel alloc] init];
        self.phoneNumberLB.font = [UIFont systemFontOfSize:15];
        self.phoneNumberLB.text = @"手机号:---";
        [self.bgView addSubview:self.phoneNumberLB];
        
        self.userNumberLB = [[UILabel alloc] init];
        self.userNumberLB.font = [UIFont systemFontOfSize:15];
        self.userNumberLB.text = @"乘车人数 -- 位";
        [self.bgView addSubview:self.userNumberLB];
        
        self.startDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"乘车点"]];
        [self addSubview:self.startDetailImageView];
        
        self.startDetailNameLB = [[UILabel alloc] init];
        self.startDetailNameLB.text = @"------";
        self.startDetailNameLB.font = [UIFont systemFontOfSize:15];
        self.startDetailNameLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self addSubview:self.startDetailNameLB];
        
        self.startDetailAddressLB = [[UILabel alloc] init];
        self.startDetailAddressLB.text = @"------";
        self.startDetailAddressLB.font = [UIFont systemFontOfSize:9];
        self.startDetailAddressLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.startDetailAddressLB];
        
        self.endDetailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"到达点"]];
        [self addSubview:self.endDetailImageView];
        
        self.endDetailNameLB = [[UILabel alloc] init];
        self.endDetailNameLB.text = @"------";
        self.endDetailNameLB.font = [UIFont systemFontOfSize:15];
        self.endDetailNameLB.textColor = [CYTSI colorWithHexString:@"#333333"];
        [self addSubview:self.endDetailNameLB];
        
        self.endDetailAddressLB = [[UILabel alloc] init];
        self.endDetailAddressLB.text = @"------";
        self.endDetailAddressLB.font = [UIFont systemFontOfSize:9];
        self.endDetailAddressLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.endDetailAddressLB];
        
        self.userRemarkLB = [[UILabel alloc] init];
        self.userRemarkLB.font = [UIFont systemFontOfSize:15];
        self.userRemarkLB.text = @"备注: ---------";
        self.userRemarkLB.numberOfLines = 2;
        [self.bgView addSubview:self.userRemarkLB];
        
        self.orderNumberLB = [[UILabel alloc] init];
        self.orderNumberLB.font = [UIFont systemFontOfSize:15];
        self.orderNumberLB.text = @"订单号---------------------";
        [self.bgView addSubview:self.orderNumberLB];
        
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:15];
        self.timeLB.text = @"下单时间--:--";
        [self.bgView addSubview:self.timeLB];
        
        self.priceLB = [[UILabel alloc] init];
        self.priceLB.font = [UIFont systemFontOfSize:13];
        [CYTSI setDefrientColorWith:@"微信支付--元" someStr:@"--" theLable:self.priceLB theColor:RGBA(253, 173, 10, 1)];
        [self.bgView addSubview:self.priceLB];
        
        self.reasonLB = [[UILabel alloc] init];
        self.reasonLB.font = [UIFont systemFontOfSize:15];
        self.reasonLB.numberOfLines = 0;
        self.reasonLB.text = @"取消原因-------------";
        [self.bgView addSubview:self.reasonLB];
        
        self.bottomTimeLB = [[UILabel alloc] init];
        self.bottomTimeLB.font = [UIFont systemFontOfSize:15];
        self.bottomTimeLB.text = @"上车时间--:--";
        [self.bgView addSubview:self.bottomTimeLB];
        
        self.cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        self.cancelBtn.layer.cornerRadius=5;
        self.cancelBtn.layer.masksToBounds=YES;
        self.cancelBtn.backgroundColor=[CYTSI colorWithHexString:@"#d8d8d8"];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.cancelBtn];
        
        self.confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmBtn setTitle:@"乘客上车" forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        self.confirmBtn.layer.cornerRadius=5;
        self.confirmBtn.layer.masksToBounds=YES;
        self.confirmBtn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
        [self.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.confirmBtn];
        
        
        self.driverStarView=[[CYStarView alloc]init];
        self.driverStarView.userInteractionEnabled = YES;
        [self.driverStarView setViewWithNumber:0 width:20 space:2 enable:NO];
        [self.bgView addSubview:self.driverStarView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pingjiaAction)];
        self.pingjiaView = [[UIView alloc] init];
        [self.pingjiaView addGestureRecognizer:tap];
        self.pingjiaView.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:self.pingjiaView];
        
        self.rightBottomLB = [[UILabel alloc] init];
        self.rightBottomLB.font = [UIFont systemFontOfSize:15];
        self.rightBottomLB.text = @"暂未评价";
        self.rightBottomLB.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.rightBottomLB];
        
        self.pingjiaLB = [[UILabel alloc] init];
        self.pingjiaLB.font = [UIFont systemFontOfSize:13];
        self.pingjiaLB.text = @"--------";
        self.pingjiaLB.textColor = [UIColor lightGrayColor];
        [self.bgView addSubview:self.pingjiaLB];
        
    }
    return self;
}
-(void)tapAction{
    self.userTravelBlock(self.start_lat, self.start_lng);
}
-(void)pingjiaAction{
    NSDictionary *dic = @{@"orderID":self.order_id,@"head":self.head,@"name":self.name};
    self.pingjiaBlock(dic);
}
-(void)phoneAction{
    if ([self.user_phone isEqualToString:@""]) {
        self.callCustPhone(self.cust_phone);
    }else{
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.user_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
-(void)cancelBtnAction{
    self.cancelBlock(self.order_id);
}
-(void)confirmBtnAction{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_UPDATE_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":self.order_id,@"state":@"2",@"aboard_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],@"aboard_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"]} tost:YES special:0 success:^(id responseObject) {
        if ([responseObject[@"message"] isEqualToString:@"操作成功"]) {
            if (self.user_phone  != nil) {
            NSString *userPhoneStr1 = [self.user_phone substringWithRange:NSMakeRange(7,1)];//截取掉下标7之后的字符串
            NSString *userPhoneStr2 = [self.user_phone substringWithRange:NSMakeRange(8,1)];
            NSString *userPhoneStr3 = [self.user_phone substringWithRange:NSMakeRange(9,1)];
            NSString *userPhoneStr4 = [self.user_phone substringFromIndex:10];
            [self playVideo:[NSString stringWithFormat:@"尾号%@-%@-%@-%@的乘客以上车",userPhoneStr1,userPhoneStr2,userPhoneStr3,userPhoneStr4]];
            }
            self.confirmBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)layoutSubviews{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.and.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.height.and.width.mas_offset(40);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    [self.userNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(7);
        make.bottom.equalTo(self.headerImageView.mas_centerY);
    }];
    
    
    [self.cyStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_centerY).offset(6);
        make.width.mas_offset(40.0);
        make.height.mas_offset(5);
        make.left.equalTo(self.headerImageView.mas_right).offset(7);
    }];
    
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(15);
        make.height.mas_offset(25);
        make.width.mas_offset(90);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLB.mas_bottom).offset(10);
        make.right.equalTo(self.bgView).offset(-10);
        make.width.mas_offset(100);
        make.height.mas_offset(25);
    }];
    
    [self.vipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneBtn);
        make.top.equalTo(self.phoneBtn.mas_bottom).offset(10);
    }];
    
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipLb.mas_left).offset(3);
        make.centerY.equalTo(self.vipLb);
        make.height.and.width.mas_offset(20);
    }];
    
    [self.idCarLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(10);
        make.right.equalTo(self.phoneBtn.mas_left);
    }];
    
    [self.phoneNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.idCarLB.mas_bottom).offset(10);
        make.right.equalTo(self.phoneBtn.mas_left);
    }];
    
    [self.userNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.phoneNumberLB.mas_bottom).offset(10);
    }];
    
    [self.startDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNumberLB.mas_bottom).offset(10);
        make.left.equalTo(self.userNumberLB);
        make.width.mas_offset(52);
        make.height.mas_offset(13);
    }];

    [self.startDetailNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startDetailImageView);
        make.left.equalTo(self.startDetailImageView.mas_right).offset(3);
        make.right.equalTo(self).offset(-5);
    }];

    [self.startDetailAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startDetailNameLB.mas_left);
        make.top.equalTo(self.startDetailNameLB.mas_bottom);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.endDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startDetailAddressLB.mas_bottom).offset(10);
        make.left.equalTo(self.userNumberLB);
        make.width.mas_offset(52);
        make.height.mas_offset(13);
    }];
    
    [self.endDetailNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endDetailImageView);
        make.left.equalTo(self.endDetailImageView.mas_right).offset(3);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.endDetailAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endDetailNameLB.mas_left);
        make.top.equalTo(self.endDetailNameLB.mas_bottom);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.userRemarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.endDetailAddressLB.mas_bottom).offset(10);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    [self.orderNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.userRemarkLB.mas_bottom).offset(10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.orderNumberLB.mas_bottom).offset(10);
    }];
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.orderNumberLB.mas_bottom).offset(10);
    }];
    
    [self.reasonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
    }];
    
    [self.bottomTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX).offset(-DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2 - 40);
        make.height.mas_offset(30);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX).offset(DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2 - 40);
        make.height.mas_offset(30);
        make.top.equalTo(self.cancelBtn);
    }];
    
    [self.driverStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
        make.width.mas_offset(80.0);
        make.height.mas_offset(15);
    }];
    
    [self.pingjiaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
        make.width.mas_offset(120.0);
        make.height.mas_offset(30);
    }];
    
    [self.rightBottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
    }];
    
    
    [self.pingjiaLB mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.driverStarView.mas_bottom).offset(5);
    }];
}

-(void)setWithModel:(ITUserOrderModel *)model state:(NSString *)orderState travelStartName:(NSString *)startName tarvelEndName:(NSString *)endName{
    self.user_phone = model.m_phone;
    self.cust_phone = model.cust_phone;
    self.head = model.m_head;
    self.name = model.m_name;
    self.start_lat = model.start_lat;
    self.start_lng = model.start_lng;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.m_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
    self.userNameLB.text = model.m_name;
    [self.cyStarView setViewWithNumber:[model.appraise_stars intValue] width:15 space:2 enable:NO];
    self.userNumberLB.text = model.state;
//    if ([model.is_baoche isEqualToString:@"0"]) {
//        self.userNumberLB.text = [NSString stringWithFormat:@"拼团 人数%@人 行李%@件",model.passenger_num,model.luggage_num];
//    }else if ([model.is_baoche isEqualToString:@"1"]){
//        self.userNumberLB.text = [NSString stringWithFormat:@"轿车包车 行李%@件",model.luggage_num];
//    }else{
//        self.userNumberLB.text = [NSString stringWithFormat:@"商务七人座包车 行李%@件",model.luggage_num];
//    }
    self.idCarLB.text = [NSString stringWithFormat:@"身份证号:%@",model.m_card_number];
    self.userRemarkLB.text = [NSString stringWithFormat:@"备注:%@",model.remark];
    self.orderNumberLB.text = [NSString stringWithFormat:@"订单号:%@",model.order_sn];
    NSLog(@"model.passenger_phone%@",model.passenger_phone);
    if (model.passenger_phone.length>7) {
        NSString * secretStr=[model.passenger_phone substringWithRange:NSMakeRange(3,4)];
        NSString * sectet=[model.passenger_phone stringByReplacingOccurrencesOfString:secretStr withString:@"****"];
        self.phoneNumberLB.text = [NSString stringWithFormat:@"手机号:%@",sectet];
    }else{
        self.phoneNumberLB.text = [NSString stringWithFormat:@"手机号:%@",model.passenger_phone];
    }
    self.timeLB.text = [NSString stringWithFormat:@"下单时间:%@",model.ctime];
    self.pingjiaLB.text = [NSString stringWithFormat:@"评价:%@",model.driver_reason];
    if ([model.pay_type_name isEqualToString:@"微信公众号支付"]) {
        [CYTSI setDefrientColorWith:[NSString stringWithFormat:@"公众号支付%@元",model.driver_money] someStr:model.driver_money theLable:self.priceLB theColor:RGBA(253, 173, 10, 1)];
    }else if ([model.pay_type_name isEqualToString:@"微信小程序支付"]){
        [CYTSI setDefrientColorWith:[NSString stringWithFormat:@"小程序支付%@元",model.driver_money] someStr:model.driver_money theLable:self.priceLB theColor:RGBA(253, 173, 10, 1)];
    }else{
        [CYTSI setDefrientColorWith:[NSString stringWithFormat:@"%@%@元",model.pay_type_name,model.driver_money] someStr:model.actual_money theLable:self.priceLB theColor:RGBA(253, 173, 10, 1)];
    }
    self.order_id = model.order_id;
    self.pingjiaLB.hidden = YES;
    if ([model.order_state isEqualToString:@"1"]) {
        self.cancelBtn.hidden = NO;
        self.confirmBtn.hidden = NO;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }else if ([model.order_state isEqualToString:@"2"]){
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = NO;
        self.pingjiaView.hidden = YES;
        self.bottomTimeLB.text = [NSString stringWithFormat:@"上车时间:%@",model.aboard_time];
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }else if ([model.order_state isEqualToString:@"3"]){
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = NO;
        self.pingjiaView.hidden = YES;
        self.bottomTimeLB.text = [NSString stringWithFormat:@"上车时间:%@",model.aboard_time];
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }else if([model.order_state isEqualToString:@"4"]){
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = YES;
        self.driverStarView.hidden = NO;
        self.pingjiaView.hidden = NO;
        self.rightBottomLB.hidden = NO;
        if ([model.driver_appraise isEqualToString:@"0"]) {
            [self.driverStarView setViewWithNumber:0 width:20 space:2 enable:NO];
            self.rightBottomLB.hidden = NO;
            self.pingjiaView.userInteractionEnabled = YES;
            
        }else{
            [self.driverStarView setViewWithNumber:[model.driver_star intValue] width:20 space:2 enable:NO];
            self.rightBottomLB.hidden = YES;
            self.pingjiaView.userInteractionEnabled = NO;
            self.pingjiaLB.hidden = NO;
        }
    }else if ([model.order_state isEqualToString:@"7"] || [model.order_state isEqualToString:@"8"]){
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = NO;
        self.bottomTimeLB.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
        if ([model.order_state isEqualToString:@"7"]) {
            self.reasonLB.text = [NSString stringWithFormat:@"取消原因:%@",model.user_cancel_reason];
        }else{
            self.reasonLB.text = [NSString stringWithFormat:@"取消原因:%@",model.driver_cancel_reason];
        }
    }else if ([model.order_state isEqualToString:@"9"]) {
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }else if ([model.order_state isEqualToString:@"10"]) {
        self.cancelBtn.hidden = YES;
        self.confirmBtn.hidden = YES;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }else if ([model.order_state isEqualToString:@"11"]) {
        self.cancelBtn.hidden = NO;
        self.confirmBtn.hidden = NO;
        self.reasonLB.hidden = YES;
        self.bottomTimeLB.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.driverStarView.hidden = YES;
        self.pingjiaView.hidden = YES;
        self.rightBottomLB.hidden = YES;
    }
    if ([model.start_distance isEqualToString:@"0.00"]) {
        self.startDetailNameLB.text = @"使用默认上车地点";
        self.startDetailAddressLB.hidden = YES;
    }else{
        self.startDetailNameLB.text = model.start_name;
        self.startDetailAddressLB.text = model.start_address;
    }
    if ([model.end_distance isEqualToString:@"0.00"]) {
        self.endDetailNameLB.text = @"使用默认下车地点";
        self.endDetailAddressLB.hidden = YES;
    }else{
        self.endDetailNameLB.text = model.end_name;
        self.endDetailAddressLB.text = model.end_address;
    }
    self.stateLB.text = model.state_name;
    NSLog(@"model.state_name%@",model.state_name);
    if ([model.state_name isEqualToString:@"待上车"]) {
        self.stateLB.text = @"去接乘客";
        self.stateLB.layer.cornerRadius  =  5;
        self.stateLB.textColor = [UIColor whiteColor];
        self.stateLB.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
        self.stateLB.layer.masksToBounds = YES;
        self.stateLB.userInteractionEnabled = YES;
    }else{
        self.stateLB.userInteractionEnabled = NO;
        self.stateLB.layer.cornerRadius  =  0;
        self.stateLB.textColor = [UIColor blackColor];
        self.stateLB.backgroundColor = [UIColor whiteColor];
        self.stateLB.layer.masksToBounds = NO;
    }
    if ([model.vip_name isEqualToString:@""]) {
        self.vipLb.hidden = YES;
        self.vipImageView.hidden = YES;
    }else{
        self.vipLb.hidden = NO;
        self.vipImageView.hidden = NO;
        self.vipLb.text = model.vip_name;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//播放推送标题
-(void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
