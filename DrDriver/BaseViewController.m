//
//  BaseViewController.m
//  DrDriver
//
//  Created by fy on 2018/10/11.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "BaseViewController.h"
#import "NotiMessageModel.h"
#import "SpeechSynthesizer.h"
#import "CYOrderView.h"
#import "CYButtonView.h"
#import "FaceAlertView.h"
#import "CYAlertView.h"
#import "AFNetworking.h"
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"

@interface BaseViewController (){
    NotiMessageModel * notiMessage;//推送信息
    CYOrderView * orderView;//抢单视图
    CYButtonView * midleButtonView;//中间听单视图
    UIView * bgWhiteView;//白色背景视图
    UIView * orderBgView;//订单视图的背景视图
    CYAlertView * alertView;
}
@property(nonatomic,strong)FaceAlertView *faceAlert;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatWhiteBgView];
    [self creatRobOrderView];
    [self creatAlertView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.faceAlert];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrder:) name:@"newOrder" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newOrder" object:nil];
}
-(void)creatAlertView{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    alertView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    alertView.titleStr=@"开始计费";
    alertView.alertStr=@"您确定乘客已上车并开始计费吗？";
    alertView.cancleButtonStr=@"取消";
    alertView.sureButtonStr=@"确认";
    [alertView setTextFiled:YES];
    [window addSubview:alertView];
    
    __weak typeof (alertView) weakAlertView = alertView;
    alertView.cancleBlock = ^{
        
        [weakAlertView hideAlertView];
        
    };
#pragma mark ---- 开始计费Block
    alertView.phoneBlock = ^{
        
    };
}
-(void)dealloc{
    
}
-(void)newOrder:(NSNotification *)noti{
    notiMessage=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
//    NSLog(@"baseviewnoti.userInfo%@",noti.userInfo);
    //新订单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order"]) {
        
        [self takeOrder:noti];
        
        orderView.stateFlag = @"0";
        orderView.startStr=notiMessage.extras.start_name;
        orderView.endStr=notiMessage.extras.end_name;
        orderView.addressView.startAddressLB.text = notiMessage.extras.start_address;
        orderView.addressView.endAddressLB.text = notiMessage.extras.end_address;
     
        orderView.startDistanceLable.text=[NSString stringWithFormat:@"接驾%.2f公里",[notiMessage.extras.distance floatValue]];
        orderView.allDistanceLable.text=[NSString stringWithFormat:@"全程%.2f公里",[notiMessage.extras.journey_mile floatValue]];
        orderView.remark = notiMessage.extras.remark;
        [CYTSI setStringWith:orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.distance floatValue]] lable:orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
        [CYTSI setStringWith:orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.journey_mile floatValue]] lable:orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
        
        if (notiMessage.extras.submit_class == 2) {
            orderView.endStr = @"目的地待与乘客确认";
            orderView.allDistanceLable.text= @"";
        }
    }
    //一口价新订单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_user_order"]) {
//        NSLog(@"new_user_order");
//        NSLog(@"backViewControllerbackViewController");
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
            //                    NSLog(@"receive_notireceive_notireceive_notireceive_noti");
            
            orderView.stateFlag = @"3";
            [self takeOrder:noti];
            orderView.titleLable.text = notiMessage.extras.order_name;
            orderView.startStr=notiMessage.extras.start_name;
            orderView.endStr=notiMessage.extras.end_name;
            orderView.addressView.startAddressLB.text = notiMessage.extras.start_address;
            orderView.addressView.endAddressLB.text = notiMessage.extras.end_address;
            orderView.addressView.startCityLB.text = notiMessage.extras.start_city;
            orderView.addressView.endCityLB.text = notiMessage.extras.end_city;
            orderView.addressView.personLB.text = [NSString stringWithFormat:@"共%@人",notiMessage.extras.passenger_num];
            orderView.addressView.luggageLB.text = [NSString stringWithFormat:@"共%@件",notiMessage.extras.luggage_num];
            orderView.addressView.priceLB.text = [NSString stringWithFormat:@"%@元",notiMessage.extras.journey_fee];
            
            
            orderView.startDistanceLable.text=[NSString stringWithFormat:@"接驾%.2f公里",[notiMessage.extras.distance floatValue]];
            orderView.allDistanceLable.text=[NSString stringWithFormat:@"全程%.2f公里",[notiMessage.extras.journey_mile floatValue]];
            orderView.remark = notiMessage.extras.remark;
            [CYTSI setStringWith:orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.distance floatValue]] lable:orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
            [CYTSI setStringWith:orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.journey_mile floatValue]] lable:orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
            if (notiMessage.extras.submit_class == 2) {
                orderView.endStr = @"目的地待与乘客确认";
                orderView.allDistanceLable.text= @"";
            }
        }
        return;
    }
    //预约单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order_appoint"]){//预约单
        [self takeOrder:noti];
        orderView.stateFlag = @"1";
        orderView.startStr=notiMessage.extras.start_name;
        orderView.endStr=notiMessage.extras.end_name;
        orderView.addressView.startAddressLB.text = notiMessage.extras.start_address;
        orderView.addressView.endAddressLB.text = notiMessage.extras.end_address;
        orderView.yuYueLable.text = notiMessage.extras.appoint_time;
        orderView.remark = notiMessage.extras.remark;
        
    }
    //接机单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order_flight"]){//接机单
        [self takeOrder:noti];
        orderView.stateFlag = @"2";
        orderView.startStr=notiMessage.extras.start_name;
        orderView.endStr=notiMessage.extras.end_name;
        orderView.addressView.startAddressLB.text = notiMessage.extras.start_address;
        orderView.addressView.endAddressLB.text = notiMessage.extras.end_address;
        orderView.airPortLable.text = [NSString stringWithFormat:@"航班号：%@",notiMessage.extras.flight_number];
        orderView.airPortDateLable.text = [NSString stringWithFormat:@"%@到达",notiMessage.extras.appoint_time];
        orderView.remark = notiMessage.extras.remark;
    }
}
-(void)takeOrder:(NSNotification *)noti{
    if ([orderView.stateFlag isEqualToString:@"3"]) {
        orderView.addressView.startCityLB.hidden = NO;
        orderView.addressView.cityArrowsImageView.hidden = NO;
        orderView.addressView.endCityLB.hidden = NO;
        orderView.addressView.personLB.hidden = NO;
        orderView.addressView.personImageView.hidden = NO;
        orderView.addressView.luggageImageView.hidden = NO;
        orderView.addressView.luggageLB.hidden = NO;
        orderView.addressView.priceLB.hidden = NO;
        orderView.addressView.priceImageView.hidden = NO;
        orderView.addressView.startImageView.image = [UIImage imageNamed:@"坐标-起始q"];
        orderView.addressView.startImageView.frame=CGRectMake(16, 52, 25, 25);;
        orderView.addressView.endImageView.image = [UIImage imageNamed:@"坐标-终点q"];
        [orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.top.equalTo(orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            
//            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-102 - Bottom_Height);
//            [UIView animateWithDuration:0.3 animations:^{
//
//                orderView.frame=CGRectMake(20, DeviceHeight - 105 - 337 - Bottom_Height, DeviceWidth-40, 337);
//                orderView.bgImageView.frame=CGRectMake(0, 0, DeviceWidth-40, 337);
//            }];
            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
            [UIView animateWithDuration:0.3 animations:^{
                
                orderBgView.frame=CGRectMake(20, (DeviceHeight-369)/2, DeviceWidth-40, 369);
                
            }];
            
        }];
    }else{
        orderView.addressView.startCityLB.hidden = YES;
        orderView.addressView.cityArrowsImageView.hidden = YES;
        orderView.addressView.endCityLB.hidden = YES;
        orderView.addressView.personLB.hidden = YES;
        orderView.addressView.personImageView.hidden = YES;
        orderView.addressView.luggageImageView.hidden = YES;
        orderView.addressView.luggageLB.hidden = YES;
        orderView.addressView.priceLB.hidden = YES;
        orderView.addressView.priceImageView.hidden = YES;
        orderView.addressView.startImageView.image = [UIImage imageNamed:@"start_adreess"];
        orderView.addressView.startImageView.frame=CGRectMake(16, 52, 11, 11);
        orderView.addressView.endImageView.image = [UIImage imageNamed:@"end_adreess"];
        [orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@11);
            make.height.equalTo(@11);
            make.top.equalTo(orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            
//            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-102 - Bottom_Height);
//            [UIView animateWithDuration:0.3 animations:^{
//
//                orderView.frame=CGRectMake(20, DeviceHeight - 105 - 297 - Bottom_Height, DeviceWidth-40, 297);
//                orderView.bgImageView.frame=CGRectMake(0, 0, DeviceWidth-40, 297);
//            }];
            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
            [UIView animateWithDuration:0.3 animations:^{
                
                orderBgView.frame=CGRectMake(20, (DeviceHeight-369)/2, DeviceWidth-40, 369);
                
            }];
            
        }];
    }
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:notiMessage.content];
    if ([notiMessage.extras.remark isEqualToString:@""] || notiMessage.extras.remark ==nil) {
        orderView.bottomLb.text = @"";
    }else{
        orderView.bottomLb.text = [NSString stringWithFormat:@"备注：%@",notiMessage.extras.remark];
    }
    //弹出视图
    if (notiMessage.extras.submit_class == 2)
    {
        orderView.isShake = YES;
        orderView.endStr = @"目的地待与乘客确认";
    }
   
    
    midleButtonView.secondeLable.text=@"60秒";
    [midleButtonView stropCirclAnimation];
    [midleButtonView robOrderAnimation];
    notiMessage=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
    [self orderPushReceipt:notiMessage.extras.order_id];
}
#pragma mark  ------   收到订单推送的回执
-(void)orderPushReceipt:(NSString *)order_id{
    NSString *app_state = @"1";
    if ([CYTSI runningInBackground]) {
        app_state = @"2";
    }else{
        app_state = @"1";
    }
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_ORDER_PUSH_RECEIPT params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"app_state":app_state} tost:YES special:0 success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}
//创建白色背景视图
-(void)creatWhiteBgView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    bgWhiteView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
    bgWhiteView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [window addSubview:bgWhiteView];
}

//创建抢单视图
-(void)creatRobOrderView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    orderBgView=[[UIView alloc]initWithFrame:CGRectMake(20, DeviceHeight, DeviceWidth-40, 369)];
    orderBgView.backgroundColor=[UIColor whiteColor];
    [window addSubview:orderBgView];
    
    orderView = [[CYOrderView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth-40, 297)];
    orderView.backgroundColor = [UIColor yellowColor];
    [orderBgView addSubview:orderView];
    orderView.stateFlag = @"0";
    orderView.startStr=@"奉化道/大沽南路（路口）晶采大厦";
    orderView.endStr=@"南开区盈江里路与华宁道交口西侧63中学旁盈江西里小区";
    [CYTSI setStringWith:orderView.startDistanceLable.text someStr:@"2.3" lable:orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    [CYTSI setStringWith:orderView.allDistanceLable.text someStr:@"7.8" lable:orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    
    __weak typeof (bgWhiteView) weakBgWhiteView = bgWhiteView;
    __weak typeof (orderBgView) weakOrderBgView = orderBgView;
    
    orderView.closeView = ^{
        
        //关闭视图
        weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
        [UIView animateWithDuration:0.3 animations:^{
            
            weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
            
        }];
        
        [midleButtonView stropCirclAnimation];//停止抢单
        
    };
    
    //创建抢单按钮
    UIView * whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 267, DeviceWidth-40, 51)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [orderBgView addSubview:whiteView];
    
    UIButton * bgButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.backgroundColor=[UIColor whiteColor];
    bgButton.layer.cornerRadius=51;
    bgButton.layer.masksToBounds=YES;
    [orderBgView addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@267);
        make.width.and.height.equalTo(@102);
        make.centerX.equalTo(orderBgView.mas_centerX);
    }];
    
    CALayer * layer=[[CALayer alloc]init];
    layer.frame=CGRectMake((DeviceWidth-40-93)/2, 271, 93, 93);
    layer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    layer.cornerRadius=46.5;
    layer.masksToBounds=YES;
    [orderBgView.layer addSublayer:layer];
    
    
    midleButtonView=[[CYButtonView alloc]initWithFrame:CGRectMake((DeviceWidth-40-92)/2, 272, 92, 92) title:@"开始上班"];
    midleButtonView.layer.cornerRadius=46;
    midleButtonView.layer.masksToBounds=YES;
    midleButtonView.buttonState=START_LISTEN;
    [orderBgView addSubview:midleButtonView];
    midleButtonView.buttonState=ALREADY_LISTEN;
    [midleButtonView circlAnimation];
    __weak typeof(self) weakSelf = self;
    //抢单按钮点击事件
    midleButtonView.buttonBlock = ^(NSInteger state) {
        if (state==ROB_ORDER) {
            //关闭视图
            weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                
            } completion:^(BOOL finished) {
                if (![notiMessage.extras.appoint_type isEqualToString:@"new_user_order"]) {
                if ([notiMessage.extras.appoint_type isEqualToString:@"0"]) {//及时单
                    [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":notiMessage.extras.order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:1 success:^(id responseObject) {
//                        NSLog(@"responseObjectresponseObjectresponseObject%@",responseObject);
                        //抢单成功
                        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"] isEqualToString:@"1"]){
                                [weakSelf.faceAlert showFaceAlertView:@{} state:@"1" orderid:notiMessage.extras.order_id btnSate:0];

                                
                                weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                                weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                            }else{
                                [CYTSI otherShowTostWithString:@"抢单成功，可在首页列表查看"];
                            }
                        } else {
                            //抢单失败
                            weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                            weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                        }
                        midleButtonView.buttonState=ALREADY_LISTEN;
                        [midleButtonView circlAnimation];
                        
                    } failure:^(NSError *error) {
                        
                        //抢单失败
                        weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                        weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                        
                    }];
                }else{
                    [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id": notiMessage.extras.order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:1 success:^(id responseObject) {
//                        NSLog(@"responseObjectresponseObjectresponseObjectresponseObject%@",responseObject);
                        //抢单成功
                        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                            UIWindow * window=[UIApplication sharedApplication].delegate.window;
                            alertView=[[CYAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
                            alertView.titleStr=@"抢单成功";
                            alertView.alertStr=@"您已经抢单成功，可到首页预约列表查看";
                            alertView.cancleButtonStr=@"";
                            alertView.sureButtonStr=@"我知道了";
                            [alertView setSingleButton];
                            [alertView setTextFiled:YES];
                            [window addSubview:alertView];
                            
                            alertView.phoneBlock = ^{
                                //重新加载数据
                                [alertView hideAlertView];
                            };
                        } else {
                            //抢单失败
                            weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                            weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                        }
                        midleButtonView.buttonState=ALREADY_LISTEN;
                        [midleButtonView circlAnimation];
                        
                    } failure:^(NSError *error) {
                        weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                        weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                    }];
                }
                } else{
                    //一口价订单抢单
//                    NSLog(@"一口价订单抢单");
                    NSDictionary *dic = [NSDictionary dictionary];
                    dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":notiMessage.extras.order_id};
                    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_GRAB_ORDER params:dic tost:YES special:1 success:^(id responseObject) {
                        //抢单成功
                        if ([responseObject[@"flag"] isEqualToString:@"success"]) {

                                [CYTSI otherShowTostWithString:@"抢单成功，可在首页列表查看"];
                        } else {
                            //抢单失败
                            weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                            weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                        }
                        midleButtonView.buttonState=ALREADY_LISTEN;
                        [midleButtonView circlAnimation];
                    } failure:^(NSError *error) {
                        weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
                        weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
                    }];
                }
            }];
        }
    };
    
    //超时操作
    midleButtonView.overTime = ^{
        
        //关闭视图
        weakBgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakOrderBgView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 369);
            
        } completion:^(BOOL finished) {
            
        }];
        
    };
    
}
-(FaceAlertView *)faceAlert{
    if (!_faceAlert) {
        _faceAlert = [[FaceAlertView alloc] initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight)];
        __weak typeof(self)  weakSelf = self;
        _faceAlert.scanFaceBlock = ^(NSDictionary *dataDic, NSString *str, NSString *orderID, NSInteger btnState) {
            [weakSelf scanFaceAction:str orderId:orderID];
        };
    }
    return _faceAlert;
}
#pragma mark -- 扫脸认证
-(void)scanFaceAction:(NSString *)state orderId:(NSString *)orderId{
    
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    lvc.isFount = YES;
    lvc.liveBlock = ^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //初始化进度框，置于当前的View当中
            UIWindow * window=[UIApplication sharedApplication].delegate.window;
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:window];
            
            [window addSubview:HUD];
            
            HUD.bezelView.backgroundColor=[UIColor blackColor];
            HUD.bezelView.alpha=1;
            HUD.label.textColor=[UIColor whiteColor];
            HUD.activityIndicatorColor=[UIColor whiteColor];
            //如果设置此属性则当前的view置于后台
            HUD.dimBackground = YES;
            //设置对话框文字
            HUD.labelText = @"请稍等";
            [HUD showAnimated:YES];
            
            NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_FACE_MATCH];
            
            //1.创建管理者对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *dict;
            dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":orderId};
            // NSLog(@"=======%@",dict);
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
            
            [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSString * dateString=[CYTSI getDateStr];
                NSString * dateStr=[NSString stringWithFormat:@"%@face_img.png",dateString];
//                NSLog(@"dateStr%@",dateStr);
                [CYTSI saveImage:[UIImage fixOrientation:[CYTSI compressImageQuality:image  toByte:1024*1024] ] withName:dateStr];
                
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"face_img" fileName:dateStr mimeType:@"image/png" error:nil];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"flag"] isEqualToString:@"error"]) {
                    
                }
                [HUD removeFromSuperview];
                
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    [CYTSI otherShowTostWithString:responseObject[@"message"]];
                    if ([responseObject[@"message"] isEqualToString:@"认证成功"]){
                         [self.faceAlert removeFromSuperview];
                        [CYTSI otherShowTostWithString:@"抢单成功，可在首页列表查看"];
                    }
                } else {
                    [HUD removeFromSuperview];
                    [CYTSI otherShowTostWithString:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求失败
                [HUD removeFromSuperview];
                CYLog(@"请求失败：%@",error);
                CYLog(@"请求地址:%@",urlString);
                CYLog(@"请求参数:%@",dict);
            }];
        });
    };
    [lvc livenesswithList:@[] order:0  numberOfLiveness:[[[NSUserDefaults standardUserDefaults] objectForKey:@"face_number"] integerValue]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
