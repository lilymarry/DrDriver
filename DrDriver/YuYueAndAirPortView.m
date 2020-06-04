
//
//  YuYueAndAirPortView.m
//  DrUser
//
//  Created by qqqqqqq on 2018/9/19.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "YuYueAndAirPortView.h"
#import "OrderDetailModel.h"
@interface YuYueAndAirPortView ()

@property (weak, nonatomic) IBOutlet UILabel *planeNumlb;
@property (weak, nonatomic) IBOutlet UILabel *planeDateLB;

@property (weak, nonatomic) IBOutlet UILabel *startAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *endAdressLB;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNubLB;
- (IBAction)callBtnCLick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView  *yuyueView;
@property (weak, nonatomic) IBOutlet UILabel *yuyueDateLb;
@property (weak, nonatomic) IBOutlet UILabel *remarkLb;


- (IBAction)cancelBtnClick:(id)sender;


@end


@implementation YuYueAndAirPortView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
}


+ (instancetype)createView{
    return [[[NSBundle mainBundle] loadNibNamed:@"YuYueAndAirPortView" owner:self options:nil] lastObject];
}


- (IBAction)callBtnCLick:(id)sender {
    
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",_orderModel.passenger_phone];
    UIWebView * callWebview = [[UIWebView alloc] init];[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self addSubview:callWebview];
    
}

- (void)setOrderModel:(OrderDetailModel *)orderModel{
    _orderModel = orderModel;
    if ([_orderModel.appoint_type isEqualToString:@"1"]) {//预约单
        self.yuyueView.hidden = NO;
        self.yuyueDateLb.text = [NSString stringWithFormat:@"预约出发时间：%@",_orderModel.appoint_time];
    }else{
        self.yuyueView.hidden = YES;
    }
    self.planeNumlb.text = [NSString stringWithFormat:@"航班号:%@",_orderModel.flight_number];
    self.planeDateLB.text = [NSString stringWithFormat:@"日期:%@",_orderModel.appoint_time];
    self.startAddressLB.text = _orderModel.start_address;
    self.endAdressLB.text = _orderModel.end_address;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.m_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
    self.nameLabel.text = _orderModel.passenger_name;
    [CYTSI setPhoneSecretWithLable:self.carNubLB string:_orderModel.passenger_phone];
    
    if (_orderModel.remark == nil) {
        self.remarkLb.text = @"";
    }else{
        self.remarkLb.text = [NSString stringWithFormat:@"备注：%@",_orderModel.remark];
    }
    
    if (_orderModel.journey_state == 7 || _orderModel.journey_state == 8) {
        self.cancelBtn.hidden = YES;
    }else{
        self.cancelBtn.hidden = NO;
    }
   
}
- (IBAction)cancelBtnClick:(id)sender {
    if([self.delegate respondsToSelector:@selector(didClickCanCelbtn:)]){
        [self.delegate didClickCanCelbtn:self.orderModel.order_id];
    }
}
@end
