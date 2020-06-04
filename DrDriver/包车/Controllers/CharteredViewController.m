//
//  ViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//包车首页

#import "CharteredViewController.h"
#import "AppDelegate.h"
#import "CYStarView.h"
#import "CYLableView.h"
#import "TripTableViewCell.h"
#import "TripDetailViewController.h"
#import "TripOneTableViewCell.h"
#import "CYButtonView.h"
#import "CYOrderView.h"
#import "OrderRuningViewController.h"
#import "LoginViewController.h"
#import "ShouYeModel.h"
#import "OrdeModel.h"
#import "CompleteOrderModel.h"
#import "NotiMessageModel.h"
#import "MessageViewController.h"
#import "AddBankCardSuccessViewController.h"
#import "CYAlertView.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "JPUSHService.h"

#import "SpeechSynthesizer.h"

#import <AudioToolbox/AudioToolbox.h>//调用系统提示音头文件
#import <sys/utsname.h>
#import "UpdateAlertView.h"

#import "shouYeHeaderView.h"
#import "AppointOrder.h"
//#import "AppointAirListViewController.h"
#import "FaceAlertView.h"

#import "AFNetworking.h"
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "FaceViewController.h"

#import "PeakAndTodayHoursViewController.h"

#import "ScanQRcodeViewController.h"


//static SystemSoundID push = 0;

@interface CharteredViewController () <UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>

{
    UITableView * myTableView;
    
    
    UIView * bgWhiteView;//白色背景视图
    NSString * currentPage;//当前分页数
    
    UIImageView * headImageView;
    UILabel * nickNameLable;
    CYStarView * starView;
    CYLableView * midelView;
    CYLableView * leftView;
    CYLableView * rightView;
    
    
    NSArray * nowOrderArray;//进行中的订单
    NSMutableArray * completeOrderArray;//已完成的订单
    
    BOOL isFirstJoin;//是否是第一次进程序
    
    
    
    
}

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSString * startAddress;//开始位置
@property (nonatomic ,strong) NSTimer * timer;
@property (nonatomic ,strong)CYAlertView * unEndOrderView;//有未完成订单弹出视图
@property (nonatomic ,strong)CYButtonView * midleButtonView;//中间听单视图
@property (nonatomic ,strong)CYOrderView * orderView;//地址视图
@property (nonatomic ,strong)NotiMessageModel * notiMessage;//透传接收的新订单推送消息
@property (nonatomic ,strong)UIButton * stopButton;//停止听单按钮
@property (nonatomic ,assign)NSInteger driver_class;//司机类型 1：快车司机 2：出租车司机
@property (nonatomic ,strong)shouYeHeaderView *headerView;
@property (nonatomic ,strong)CYAlertView * successAppointView;//抢单成功弹出视图

//@property(nonatomic,assign)BOOL  isChange;//是否改变订单弹窗位置

//@property (nonatomic, copy) NSString *listen_face_state;//听单是否需要扫脸,1开启，0关闭
//@property (nonatomic, copy) NSString *receipt_face_state;//接单是否需要扫脸,1开启，0关闭
@property (nonatomic, copy) NSString *face_number;//活体检测需要的检测数量
@property(nonatomic,copy)NSString *driver_face_state;

@property(nonatomic,strong)FaceAlertView *alert;
@property(nonatomic,strong)CYAlertView  *singleAlertView;

@end

@implementation CharteredViewController

//监控网络状态00000000000000
- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"网络连接正常");
            [self refreshDown];//请求司机信息
            
        }else{
            NSLog(@"网络连接错误");
            
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        
        NSURL * url = [NSURL  URLWithString: UIApplicationOpenSettingsURLString];
        
        if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
            
            NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //    StatusBarHeight
    
    self.title=@"网路叫车";
    isFirstJoin=YES;
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    completeOrderArray=[[NSMutableArray alloc]init];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"loginfailed" object:nil];//登录过期
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFront) name:@"change_front" object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopListen) name:@"stop_listen" object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginListen) name:@"beginListen" object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiangqing) name:@"VC_xiangqing" object:nil];

    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self creatWhiteBgView];//创建白色背景视图
    [self creatBottomView];//创建底部视图
    [self creatAlertView];//创建弹出视图
    [self setUpMap];//设置地图
    [self refreshDown];//请求司机信息
    
    [self reachability];//监控网络状态
    [self startLocation];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"jpushMessage"] isEqualToString:@"xiangqing"]) {
        [self xiangqing];
    }
    //检查软件是否需要更新
    [self checkForUpdate];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alert];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {
        NSLog(@"您没有开启了定位权限");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"打开定位开关"
                                                        message:@"定位服务未开启，请进入系统设置允许APP获取位置信息"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"立即开启", nil];
        [alert buttonTitleAtIndex:1];
        
        alert.delegate = self;
        [alert show];
    }
    
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider setPanEnabled:YES];
    
    //    [self stopButtonClicked];
    
    if (self.midleButtonView.buttonState==ALREADY_LISTEN ) {
        
        _stopButton.hidden=NO;
        [self.midleButtonView circlAnimation];//听单动画
        
    }else{
        _stopButton.hidden=YES;
    }
    
    [self refreshDown];//刷新数据
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //关闭视图
    bgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight-102);
    [UIView animateWithDuration:0.3 animations:^{
        
        _orderView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 297);
        
    }];
    
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider setPanEnabled:NO];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
}

#pragma mark ---- 检查软件是否需要更新
-(void)checkForUpdate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [AFRequestManager postRequestWithUrl:DRIVER_VERSION_DRIVER_CLIENT_UPDATE_IOS params:@{@"version":[infoDictionary objectForKey:@"CFBundleShortVersionString"]} tost:YES special:0 success:^(id responseObject) {
        NSLog(@"CFBundleShortVersionString%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            if ([responseObject[@"data"][@"is_force"] isEqualToString:@"1"]) {
                if (![responseObject[@"data"][@"version"]  isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]) {
                    //关闭广告弹窗
#pragma mark ------ 创建更新alertView
                    UpdateAlertView *updateAlertView = [[UpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
                    updateAlertView.descriptionLabel.text = responseObject[@"data"][@"description"];
                    updateAlertView.versionNumberLabel.text = [NSString stringWithFormat:@"V %@",responseObject[@"data"][@"version"]];
                    [[UIApplication sharedApplication].keyWindow addSubview:updateAlertView];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//接受开始听单消息
-(void)beginListen{
    self.midleButtonView.buttonState=ALREADY_LISTEN;
}
-(void)xiangqing{
    MessageViewController *min = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:min animated:YES];
}
-(void)newOrder:(NSNotification *)noti{
    [self.successAppointView hideAlertView];
    //有新订单的时候
    _notiMessage=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
    
    [self closeRobOrderView];
    
    //关闭视图
    bgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight-102);
    _orderView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 297);
#pragma mark -- 判断左侧栏是否弹出
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (mainAppDelegate.leftSlider.mainVC.view.center.x > 50) {
        [mainAppDelegate.leftSlider closeLeftView];
    }
    if ([_orderView.stateFlag isEqualToString:@"3"]) {
        self.orderView.addressView.startCityLB.hidden = NO;
        self.orderView.addressView.cityArrowsImageView.hidden = NO;
        self.orderView.addressView.endCityLB.hidden = NO;
        self.orderView.addressView.personLB.hidden = NO;
        self.orderView.addressView.personImageView.hidden = NO;
        self.orderView.addressView.luggageImageView.hidden = NO;
        self.orderView.addressView.luggageLB.hidden = NO;
        self.orderView.addressView.priceLB.hidden = NO;
        self.orderView.addressView.priceImageView.hidden = NO;
        self.orderView.addressView.startImageView.image = [UIImage imageNamed:@"坐标-起始q"];
        self.orderView.addressView.startImageView.frame=CGRectMake(16, 52, 25, 25);;
        self.orderView.addressView.endImageView.image = [UIImage imageNamed:@"坐标-终点q"];
        [self.orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.top.equalTo(self.orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            
            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-102 - Bottom_Height);
            [UIView animateWithDuration:0.3 animations:^{
                
                _orderView.frame=CGRectMake(20, DeviceHeight - 105 - 337 - Bottom_Height, DeviceWidth-40, 337);
                self.orderView.bgImageView.frame=CGRectMake(0, 0, DeviceWidth-40, 337);
            }];
            
        }];
    }else{
        self.orderView.addressView.startCityLB.hidden = YES;
        self.orderView.addressView.cityArrowsImageView.hidden = YES;
        self.orderView.addressView.endCityLB.hidden = YES;
        self.orderView.addressView.personLB.hidden = YES;
        self.orderView.addressView.personImageView.hidden = YES;
        self.orderView.addressView.luggageImageView.hidden = YES;
        self.orderView.addressView.luggageLB.hidden = YES;
        self.orderView.addressView.priceLB.hidden = YES;
        self.orderView.addressView.priceImageView.hidden = YES;
        self.orderView.addressView.startImageView.image = [UIImage imageNamed:@"start_adreess"];
        self.orderView.addressView.startImageView.frame=CGRectMake(16, 52, 11, 11);
        self.orderView.addressView.endImageView.image = [UIImage imageNamed:@"end_adreess"];
        [self.orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@11);
            make.height.equalTo(@11);
            make.top.equalTo(self.orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            
            bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-102 - Bottom_Height);
            [UIView animateWithDuration:0.3 animations:^{
                
                _orderView.frame=CGRectMake(20, DeviceHeight - 105 - 297 - Bottom_Height, DeviceWidth-40, 297);
                self.orderView.bgImageView.frame=CGRectMake(0, 0, DeviceWidth-40, 297);
            }];
            
        }];
    }
    if ([_notiMessage.extras.remark isEqualToString:@""] || _notiMessage.extras.remark ==nil) {
        _orderView.bottomLb.text = @"";
    }else{
        _orderView.bottomLb.text = [NSString stringWithFormat:@"备注：%@",_notiMessage.extras.remark];
    }
    //弹出视图
    if (_notiMessage.extras.submit_class == 2)
    {
        _orderView.isShake = YES;
        _orderView.endStr = @"目的地待与乘客确认";
    }
    //设置抢单中的时间
    self.midleButtonView.secondeLable.text=@"60秒";
    [self.midleButtonView stropCirclAnimation];
    [self.midleButtonView robOrderAnimation];


}
//接收到透传消息
-(void)TouChuan:(NSNotification *)noti
{
    NSLog(@"CharteredViewController.userInfo%@",noti.userInfo);

        NotiMessageModel * theNotiMessageModel=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
    
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"new_intercity_order"]) {//新订单推送
      
            if ([self backViewController]){
                NSLog(@"backViewControllerbackViewController");
                OrderRuningViewController * vc=[[OrderRuningViewController alloc]init];
                __weak typeof(self) weakSelf = self;
                vc.AlreadyListenBlock = ^{
                    weakSelf.midleButtonView.buttonState=ALREADY_LISTEN;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"orderState"];
//                    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
                };
                vc.orderID = theNotiMessageModel.extras.order_id;
                [self.navigationController pushViewController:vc animated:YES];
                [self.alert removeFromSuperview];
            }
        }
    
    if ([theNotiMessageModel.extras.operate_class isEqualToString:@"intercity_cancel_order"]) {//用户取消推送
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"order_id"];
        if ([self backViewController]){
            
         
            self.singleAlertView.titleStr=@"乘客已取消订单";
            self.singleAlertView.alertStr=[NSString stringWithFormat:@"很抱歉，乘客已取消订单。取消原因：%@。",theNotiMessageModel.extras.refund_reason];
            self.singleAlertView.cancleButtonStr=@"";
            self.singleAlertView.sureButtonStr=@"我知道了";
            [self.singleAlertView setSingleButton];
            [self.singleAlertView setTextFiled:YES];
//            [self.singleAlertView showAlertView];
           
            
            __weak typeof (self.singleAlertView) weakSingleAlertView = self.singleAlertView;
            __weak typeof (self) weakSelf = self;
            self.singleAlertView.phoneBlock = ^{
                [weakSingleAlertView hideAlertView];
                [weakSelf refreshDown];
                
            };
            
           
        
        }
    }
    

}

//从后台变为前台的时候判断是否在听单
-(void)changeFront
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue]==1) {
        if (self.midleButtonView.buttonState==ALREADY_LISTEN ) {
            [self.midleButtonView circlAnimation];//听单动画
        }
    }
}
//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [self creatHttp];
}

//上拉加载
-(void)refreshUp
{
    currentPage=[NSString stringWithFormat:@"%d",[currentPage intValue]+1];
    [self creatHttp];
}

//请求司机信息
-(void)creatHttp
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    __weak typeof(self) weakSelf = self;
//    NSLog(@"driver_id=%@&token=%@&p=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"1");

    [AFRequestManager postRequestWithUrl:DRIVER_INTERCITY_DRIVER_BASE_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage} tost:YES special:0 success:^(id responseObject) {
        [ShouYeModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"unfinished_order":@"OrdeModel"};
            
        }];
        
        [CompleteOrderModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"list":@"OrdeModel"};
            
        }];
        
        ShouYeModel * shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        NSLog(@"DRIVER_INTERCITY_DRIVER_BASE_INFO    =========   %@",responseObject[@"data"]);
        if (shouYe.audit_state==2) {//可以听单
            //移除透传消息的通知
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
            //接受透传消息的通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
            weakSelf.midleButtonView.isCanListen=YES;
        } else {
            weakSelf.midleButtonView.isCanListen=NO;
        }
        
        if (shouYe.unfinished_order.count<=0 && [currentPage isEqualToString:@"1"]) {
            weakSelf.midleButtonView.isHaveUnEndOrder=NO;
        }else{
            OrdeModel *theOrder=shouYe.unfinished_order[0];
            if (theOrder.journey_state == 4 || theOrder.journey_state == 0) {
                weakSelf.midleButtonView.isHaveUnEndOrder=NO;
            }else{
                weakSelf.midleButtonView.isHaveUnEndOrder=YES;
                
                if (isFirstJoin) {
                    
                    weakSelf.unEndOrderView.titleStr=@"温馨提示";
                    weakSelf.unEndOrderView.cancleButtonStr=@"忽略";
                    weakSelf.unEndOrderView.sureButtonStr=@"马上查看";
                    weakSelf.unEndOrderView.alertStr=@"您还有未完成的订单，是否立即查看?";
                    [weakSelf.unEndOrderView showAlertView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:weakSelf userInfo:nil];
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",theOrder.journey_state],@"orderState", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:weakSelf userInfo:dict];
                    
                    
                    weakSelf.unEndOrderView.cancleBlock = ^{
                        
                        [weakSelf.unEndOrderView hideAlertView];
                        
                    };
                    
                    weakSelf.unEndOrderView.phoneBlock = ^{
                        
                        [weakSelf.unEndOrderView hideAlertView];
                        NSLog(@"theOrder.driver_face_statetheOrder.driver_face_state%@",theOrder.driver_face_state);
                        if ([theOrder.driver_face_state isEqualToString:@"1"]) {
                            [weakSelf scanFaceAction:UNFINISHORDER responseObject:@{@"model":theOrder}];
                        }else{
                            [weakSelf unfinishOrder:@{@"model":theOrder}];
                        }
                    };
                    
                }
                
            }
            
        }
        
        isFirstJoin=NO;
        [[NSUserDefaults standardUserDefaults] setObject:shouYe.invite_code forKey:@"invite_code"];
        
        _driver_class=shouYe.driver_class;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:shouYe.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
        nickNameLable.text=shouYe.driver_name;
        int height=[CYTSI planRectWidth:nickNameLable.text font:14];
        [nickNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(height);
        }];
        self.driver_face_state = shouYe.driver_face_state;
        [starView setViewWithNumber:shouYe.appraise_stars width:14 space:2 enable:NO];
        midelView.bottomLable.text=shouYe.today_count;
        leftView.bottomLable.text=[NSString stringWithFormat:@"%ld",(long)shouYe.cumulate_count];
//        NSLog(@"shouYe.cumulate_count ======== %ld",(long)shouYe.cumulate_count);
        rightView.bottomLable.text=shouYe.today_complete_rate;
        [[NSUserDefaults standardUserDefaults] setObject:shouYe.listen_face_state forKey:@"listen_face_state"];
        [[NSUserDefaults standardUserDefaults] setObject:shouYe.receipt_face_state forKey:@"receipt_face_state"];
        self.face_number = shouYe.face_number;
//        NSLog(@"shouYe.face_numbershouYe.face_number%@",shouYe.face_number);
        [[NSUserDefaults standardUserDefaults] setObject:self.face_number forKey:@"face_number"];
        if ([currentPage intValue]==1) {
            [completeOrderArray removeAllObjects];
            nowOrderArray=shouYe.unfinished_order;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_message" object:self userInfo:@{@"message":shouYe}];
        }
        if ([shouYe.online_state isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
            self.midleButtonView.buttonState=ALREADY_LISTEN;
            [self.midleButtonView circlAnimation];
            self.stopButton.hidden=NO;
            [self setNotification];
            [self.alert removeFromSuperview];
        }
        
        [completeOrderArray removeAllObjects];
        
        [completeOrderArray addObjectsFromArray:shouYe.appoint_order];
        weakSelf.headerView.shouye = shouYe;
        [myTableView reloadData];
        
        [myTableView.mj_header endRefreshing];
        if ([currentPage intValue]>[shouYe.complete_order.total_page intValue]) {
            [myTableView .mj_footer endRefreshingWithNoMoreData];
        }else{
            [myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
    }];
}

//登录过期的通知
-(void)loginFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    LoginViewController * vc=[[LoginViewController alloc]init];
    vc.isMainJump=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//先判断是否是在本界面，不在的话先返回本界面
- (BOOL)backViewController
{
    if ([self.navigationController.topViewController isKindOfClass:[CharteredViewController class]]) {
        return YES;
    }else{
        NSArray *vcArray = self.navigationController.viewControllers;
//        NSLog(@"self.navigationController.viewControllers%@",self.navigationController.viewControllers);
        for (CharteredViewController *vc in vcArray) {
            if ([vc isKindOfClass:[CharteredViewController class]]) {
             
                [self.navigationController popToViewController:vc animated:YES];

            }
        }
        return YES;
    }
}

//播放推送标题
-(void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}
//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"shouye_top_left"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *  messageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame=CGRectMake(0, 0, 20, 20);
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    messageButton.layer.masksToBounds=YES;
    [messageButton setTitle:@"" forState:UIControlStateNormal];
    messageButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [messageButton setImage:[UIImage imageNamed:@"shouye_top_right"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:messageButton];
    
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    itemSpace.width = 15;
    
    UIButton *shouye_nav_rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    shouye_nav_rightButton.frame =  CGRectMake(0, 0, 20, 20);
    [shouye_nav_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shouye_nav_rightButton setImage:[UIImage imageNamed:@"二维码"] forState:(UIControlStateNormal)];
    [shouye_nav_rightButton addTarget:self action:@selector(shouye_nav_rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:shouye_nav_rightButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:BtnItem,itemSpace,rightItem,nil]];
}
-(void)shouye_nav_rightButtonClicked{
    ScanQRcodeViewController *sqVC = [[ScanQRcodeViewController alloc] init];
    [self.navigationController pushViewController:sqVC animated:YES];
}

//导航栏右侧按钮点击事件
-(void)messageButtonClicked
{
    MessageViewController * vc=[[MessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//个人中心按钮点击事件
-(void)navBackButtonClicked
{
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider openLeftView];
}

//创建白色背景视图
-(void)creatWhiteBgView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    bgWhiteView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight-102)];
    bgWhiteView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [window addSubview:bgWhiteView];
}

//创建弹出视图
-(void)creatAlertView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    _orderView=[[CYOrderView alloc] initWithFrame:CGRectMake(20, DeviceHeight, DeviceWidth-40, 297)];
    [window addSubview:_orderView];
    _orderView.startStr=@"奉化道/大沽南路（路口）晶采大厦";
    _orderView.endStr=@"南开区盈江里路与华宁道交口西侧63中学旁盈江西里小区";
    [CYTSI setStringWith:_orderView.startDistanceLable.text someStr:@"2.3" lable:_orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    [CYTSI setStringWith:_orderView.allDistanceLable.text someStr:@"7.8" lable:_orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    __weak typeof (self) weakSelf = self;
    //关闭抢单弹窗
    _orderView.closeView = ^{
        [weakSelf closeRobOrderView];
    };
    
    //提示有未完成订单弹窗
    _unEndOrderView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
    _unEndOrderView.isCanHiden=NO;
    [_unEndOrderView setTextFiled:YES];
    [window addSubview:_unEndOrderView];
    
}

//设置接收推送消息
-(void)setReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    NSString *driverLocationLo = @"0";
    NSString *driverLocationLa = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
        driverLocationLo = @"0";
        driverLocationLa = @"0";
    }else{
        driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
        driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_INTERCITY_DRIVER_ONLINE_STATE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"state":@"start",@"driver_lng":driverLocationLo,@"driver_lat":driverLocationLa} tost:NO special:1 success:^(id responseObject) {
        
        NSLog(@"DRIVER_DRIVER_DRIVER_ONLINE_STATE");
        
        [self updateDriver];
        
        
    } failure:^(NSError *error) {
        
    }];
}
//设置不接收推送消息
-(void)setNotReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"receive_noti"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
    }
    NSString *driverLocationLo = @"0";
    NSString *driverLocationLa = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
        driverLocationLo = @"0";
        driverLocationLa = @"0";
    }else{
        driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
        driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_INTERCITY_DRIVER_ONLINE_STATE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"state":@"stop",@"driver_lng":driverLocationLo,@"driver_lat":driverLocationLa} tost:NO special:1 success:^(id responseObject) {
        
        if ([self.timer isValid]) {
            [self.timer invalidate];
            _timer = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ------ 开始上传司机位置
-(void)updateDriver{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types)
    {
        NSLog(@"推送关闭 8.0");
        UIAlertView * myAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [myAlertView show];
        
        [self stopButtonClicked];
        return;
    }
    if ((UIUserNotificationTypeSound & setting.types) == 0) {
        UIAlertView * myAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知声音开启，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [myAlertView show];
        
        [self stopButtonClicked];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
}
//更新司机首页信息
-(void)updateDriverLocation
{
    
    NSLog(@" ===============updateDriverLocation =============================");
    
    NSDictionary * dic1 =@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [AFRequestManager postRequestWithUrl:DRIVER_INTERCITY_ONLINE_TIME params:dic1 tost:NO special:1 success:^(id responseObject) {
        [self.headerView.peakHoursBtn setTitle:responseObject[@"data"][@"peak_time"] forState:UIControlStateNormal];
        [self.headerView.todayHoursBtn setTitle:responseObject[@"data"][@"online_time"] forState:UIControlStateNormal];
        [self.headerView.todayMoneyBtn setTitle:responseObject[@"data"][@"driver_fee"] forState:(UIControlStateNormal)];//今日金额
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)setNotification{

}
//创建底部视图
-(void)creatBottomView
{
    
    UIButton * bgButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.layer.borderWidth=1;
    bgButton.layer.borderColor=TABLEVIEW_BACKCOLOR.CGColor;
    bgButton.layer.cornerRadius=51;
    bgButton.layer.masksToBounds=YES;
    [self.view addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@102);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-92 - Bottom_Height, DeviceWidth, 92 + Bottom_Height)];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.layer.borderWidth=0.8;
    bottomView.layer.borderColor=TABLEVIEW_BACKCOLOR.CGColor;
    [self.view addSubview:bottomView];
    
    UIButton * frontButton=[UIButton buttonWithType:UIButtonTypeCustom];
    frontButton.backgroundColor=[UIColor whiteColor];
    frontButton.layer.cornerRadius=50.5;
    frontButton.layer.masksToBounds=YES;
    [self.view addSubview:frontButton];
    [frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@101);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    self.midleButtonView=[[CYButtonView alloc]initWithFrame:CGRectMake((DeviceWidth-92)/2, DeviceHeight-103 - Bottom_Height, 92, 92) title:@"开始上班"];
    self.midleButtonView.layer.cornerRadius=46;
    self.midleButtonView.layer.masksToBounds=YES;
    self.midleButtonView.buttonState=START_LISTEN;
    self.midleButtonView.layer.shadowColor = [UIColor colorWithRed:110/255.0 green:109/255.0 blue:124/255.0 alpha:1].CGColor;//阴影颜色
    self.midleButtonView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
    self.midleButtonView.layer.shadowOpacity = 0.8;//不透明度
    self.midleButtonView.layer.shadowRadius = 5;//半径
    [self.view addSubview:self.midleButtonView];
    
    
    __weak typeof (bgWhiteView) weakBgWhiteView = bgWhiteView;
    __weak typeof (self) weakSelf = self;
    
#pragma mark ---------------按钮点击事件-----------
    self.midleButtonView.buttonBlock = ^(NSInteger state) {
        
        if (state == ALREADY_LISTEN) {//开始订单按钮点击后接受推送
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"listen_face_state"] isEqualToString:@"1"]) {
                if ([weakSelf.driver_face_state isEqualToString:@"1"]){
                    weakSelf.midleButtonView.buttonState=START_LISTEN;
                    
                    [weakSelf.alert showFaceAlertView:@{} state:@"" orderid:@"" btnSate:START_LISTEN];
                    
                }else{
                    weakSelf.midleButtonView.buttonState=START_LISTEN;
                    FaceViewController *vc = [[FaceViewController alloc] init];
                    vc.face_number = [weakSelf.face_number integerValue];
                    vc.driver_face_state = weakSelf.driver_face_state;
                    vc.reloadDataBlock = ^{
                        
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }else{
                NSLog(@"开始听单计时");
                //移除透传消息的通知
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
                //接受透传消息的通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
                weakSelf.midleButtonView.buttonState=ALREADY_LISTEN;
                [weakSelf.midleButtonView circlAnimation];
                [weakSelf setReceiveNoti];
                [weakSelf setNotification];
                weakSelf.stopButton.hidden=NO;
            }
        }
        
    };
    
    //抢单倒计时结束后的操作
    self.midleButtonView.overTime = ^{
        
        [weakSelf closeRobOrderView];
        
    };
    
    _stopButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_stopButton setImage:[UIImage imageNamed:@"stop_order_button"] forState:UIControlStateNormal];
    [_stopButton setTitle:@"收车下班" forState:UIControlStateNormal];
    [_stopButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _stopButton.titleLabel.font=[UIFont systemFontOfSize:11];
    _stopButton.hidden=YES;
    [self setButtonSpace:_stopButton buttonTitle:@"收车下班"];
    [_stopButton addTarget:self action:@selector(stopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopButton];
    [_stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DeviceHeight - 88 - Bottom_Height);
        make.left.equalTo(self.view.mas_centerX).offset(76);
        make.width.and.height.equalTo(@60);
    }];
    
}
-(FaceAlertView *)alert{
    if (!_alert) {
        _alert = [[FaceAlertView alloc] initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight)];
        __weak typeof(self) weakSelf = self;
        _alert.scanFaceBlock = ^(NSDictionary *dataDic, NSString *str, NSString *orderID, NSInteger btnState) {
            [weakSelf scanFaceAction:btnState responseObject:dataDic];
        };
    }
    return _alert;
}
#pragma mark -- 扫脸认证
-(void)scanFaceAction:(NSInteger)state responseObject:(NSDictionary *)dic{
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
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
            if (state == START_LISTEN) {
                dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
            }else if (state == ROB_ORDER){
                dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":self.notiMessage.extras.order_id};
            }else if(state == UNFINISHORDER){
                OrdeModel *theOrder  = dic[@"model"];
                dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":theOrder.order_id};
            }
            // NSLog(@"=======%@",dict);
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
            
            [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSString * dateString=[CYTSI getDateStr];
                NSString * dateStr=[NSString stringWithFormat:@"%@face_img.png",dateString];
                NSLog(@"dateStr%@",dateStr);
                [CYTSI saveImage:[UIImage fixOrientation:[CYTSI compressImageQuality:image  toByte:1024*1024] ] withName:dateStr];
                
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"face_img" fileName:dateStr mimeType:@"image/png" error:nil];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                //打印下上传进度
                CYLog(@"上传进度=========%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //请求成功
                CYLog(@"请求成功：%@",responseObject);
                CYLog(@"提示信息：%@",[responseObject objectForKey:@"message"]);
                CYLog(@"请求地址:%@",urlString);
                CYLog(@"请求参数:%@",dict);
                if ([responseObject[@"flag"] isEqualToString:@"error"]) {
                    
                }
                [HUD removeFromSuperview];
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    if ([responseObject[@"message"] isEqualToString:@"认证成功"]) {
                        if (state == START_LISTEN) {
                            //开始听单动画
                            [self alreadyListenAction];
                        }else if (state == ROB_ORDER){
                            [self robOrderAction:dic];
                        }else if (state == UNFINISHORDER){
                            [self unfinishOrder:dic];
                        }
                        [CYTSI otherShowTostWithString:responseObject[@"message"]];
                    }else{
                        [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    }
                } else {
                    [HUD removeFromSuperview];
                    [CYTSI otherShowTostWithString:@"认证失败，请重试"];
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
    [lvc livenesswithList:@[] order:0  numberOfLiveness:[self.face_number integerValue]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}
//开始听单
-(void)alreadyListenAction{
    NSLog(@"===============alreadyListenAction=================");
    self.midleButtonView.buttonState=ALREADY_LISTEN;
    [self.midleButtonView circlAnimation];
    [self setReceiveNoti];
    self.stopButton.hidden=NO;
    [self setNotification];
    [self.alert removeFromSuperview];
    
}
//抢单成功
-(void)robOrderAction:(NSDictionary *)dic{
    
//    OrdeModel * qiangOrder=[OrdeModel mj_objectWithKeyValues:dic[@"data"]];
////    [CYTSI otherShowTostWithString:@"抢单成功，快去接驾吧~"];
//    //停止语音
////    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
//    self.stopButton.hidden=YES;
//
//    OrderRuningViewController * vc=[[OrderRuningViewController alloc]init];
//    __weak typeof(self) weakSelf = self;
//    vc.AlreadyListenBlock = ^{
//        weakSelf.midleButtonView.buttonState=ALREADY_LISTEN;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:@"orderState"];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
//    };
//    vc.remarkStr = qiangOrder.remark;
//    vc.appoint_time = qiangOrder.appoint_time;
//    vc.endCoordinate=CLLocationCoordinate2DMake(qiangOrder.end_lat, qiangOrder.end_lng);
//    vc.endAddress=qiangOrder.end_address;
//    vc.flight_date= qiangOrder.appoint_time;
//    vc.userStartCoordinate=CLLocationCoordinate2DMake(qiangOrder.start_lat, qiangOrder.start_lng);
//    vc.userStartAddress=qiangOrder.start_address;
//    vc.orderID=weakSelf.notiMessage.extras.order_id;
//    [[NSUserDefaults standardUserDefaults] setObject:self.notiMessage.extras.order_id forKey:@"order_id"];
//    vc.userName=qiangOrder.passenger_name;
//    vc.userPhone=qiangOrder.passenger_phone;
//    vc.m_header=qiangOrder.m_head;
//    vc.journey_fee=weakSelf.notiMessage.extras.journey_fee;
//    vc.order_class= weakSelf.driver_class;
//    vc.submit_class = qiangOrder.submit_class;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.alert removeFromSuperview];
}
//行程中的订单 已完成扫脸
-(void)unfinishOrder:(NSDictionary *)dic{
    OrdeModel *theOrder  = dic[@"model"];
//    OrderRuningViewController * vc=[[OrderRuningViewController alloc]init];
//    __weak typeof(self) weakSelf = self;
//    vc.AlreadyListenBlock = ^{
//        weakSelf.midleButtonView.buttonState=ALREADY_LISTEN;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"orderState"];
////        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
//    };
//    vc.orderID=theOrder.order_id;
//    [[NSUserDefaults standardUserDefaults] setObject:theOrder.order_id forKey:@"order_id"];
//
//    [self.navigationController pushViewController:vc animated:YES];
    OrderRuningViewController * vc=[[OrderRuningViewController alloc]init];
    vc.orderID=theOrder.order_id;
    vc.endCoordinate=CLLocationCoordinate2DMake(theOrder.end_lat, theOrder.end_lng);
    vc.endAddress=theOrder.end_address;
    vc.userStartCoordinate=CLLocationCoordinate2DMake(theOrder.start_lat, theOrder.start_lng);
    vc.userStartAddress=theOrder.start_address;
    vc.userName=theOrder.passenger_name;
    vc.userPhone=theOrder.passenger_phone;
    vc.m_header=theOrder.m_head;
    vc.isOrderList=YES;
    vc.orderState=theOrder.journey_state;
    vc.appoint_type = theOrder.appoint_type;
    vc.appoint_time = theOrder.appoint_time;
    vc.flight_number = theOrder.flight_number;
    vc.flight_date = theOrder.appoint_time;
    vc.remarkStr = theOrder.remark;
    vc.submit_class = theOrder.submit_class;
    vc.order_class=theOrder.order_class;
    vc.journey_fee=theOrder.journey_fee;
    vc.AlreadyListenBlock = ^{
        
    };
    [[NSUserDefaults standardUserDefaults] setObject:theOrder.order_id forKey:@"order_id"];
    //    NSLog(@"order.journey_stateorder.journey_state%ld",order.journey_state);
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)theOrder.journey_state],@"orderState", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//关闭抢单弹窗
-(void)closeRobOrderView
{
    //关闭视图
    bgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight-102);
    [UIView animateWithDuration:0.3 animations:^{
        
        _orderView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 297);
        
    }];
    [self.midleButtonView failedAfter];//继续听单
    _stopButton.hidden = NO;
}

//停止接单按钮点击事件
-(void)stopButtonClicked
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    __weak typeof(self) weakSelf = self;

    [AFRequestManager postRequestWithUrl:DRIVER_INTERCITY_DRIVER_BASE_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":@"1"} tost:YES special:0 success:^(id responseObject) {
        [ShouYeModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"unfinished_order":@"OrdeModel"};
            
        }];
        ShouYeModel * shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (shouYe.unfinished_order.count<=0 && [currentPage isEqualToString:@"1"]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否确认收车下班" message:@"收车下班后将不会收到新的订单并不计数在线时长" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf stop];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            OrdeModel *theOrder=shouYe.unfinished_order[0];
            if (theOrder.journey_state == 4 || theOrder.journey_state == 0) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否确认收车下班" message:@"收车下班后将不会收到新的订单并不计数在线时长" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf stop];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                [CYTSI otherShowTostWithString:@"您有未完成的订单，暂时不能下班"];
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)stopListen
{
    [self stop];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
}
-(void)stop{
    _stopButton.hidden=YES;
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self setNotReceiveNoti];//不接收推送
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    [self.midleButtonView stropCirclAnimation];
    //关闭视图
    bgWhiteView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight-102);
    [UIView animateWithDuration:0.3 animations:^{
        
        _orderView.frame=CGRectMake(20, DeviceHeight, DeviceWidth-40, 297);
        
    }];
}
//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-92) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
//    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    myTableView.tableHeaderView = self.headerView;
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return nowOrderArray.count;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIView * smallView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 40)];
    smallView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:smallView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 120, 20)];
    label.textColor=[CYTSI colorWithHexString:@"#2488ef"];
    label.font=[UIFont systemFontOfSize:15];

    label.text=@"进行中的订单";
   
    [smallView addSubview:label];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
if (nowOrderArray.count ==  0) {
            return 50;
        }else{
            return 0.5;
        }
  
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIView * smallView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 40)];
    smallView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [bgView addSubview:smallView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 120, 20)];
    label.textColor= [UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"暂无订单";
    [smallView addSubview:label];
   
        if (nowOrderArray.count ==  0) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }

    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 62;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && nowOrderArray.count!=0) {
        
        TripOneTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"triponecell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"TripOneTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        //        if (indexPath.row==nowOrderArray.count-1) {
        //            cell.lineView.hidden=YES;
        //        }
        
        OrdeModel * order= nowOrderArray[indexPath.row];
        cell.startLable.text=[NSString stringWithFormat:@"%@:%@",order.start_city_name,order.start_site_name];
        cell.endLable.text=[NSString stringWithFormat:@"%@:%@",order.end_city_name,order.end_site_name];
        
        return cell;
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否s人脸识别（原因：先接单后扫脸）
    if (indexPath.section==0 && nowOrderArray.count!=0) {
        OrdeModel * order=nowOrderArray[indexPath.row];
        if ([order.driver_face_state isEqualToString:@"1"]) {//未进行人脸识别
            [self scanFaceAction:UNFINISHORDER responseObject:@{@"model":order}];
        }else{//人脸识别成功
            [self unfinishOrder:@{@"model":order}];
        }
    }
}

//设置button的文字图片间距
-(void)setButtonSpace:(UIButton *)button buttonTitle:(NSString *)title
{
    CGFloat buttonWidth =60;//按钮的宽度
    CGFloat textWidth = [CYTSI planRectWidth:title font:11];//按钮上的文字宽度
    CGFloat imageTopGap = 1;//图片距上部距离
    CGFloat textTopGap = 5;//文字距离图片的距离
    
    //CGFloat buttonImageWidth=button.imageView.frame.size.width;
    //if (buttonImageWidth>50) {
    CGFloat buttonImageWidth=buttonImageWidth=55;
    //}
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake((buttonImageWidth + imageTopGap) + textTopGap,(buttonWidth - textWidth)/2 - buttonImageWidth,0,0 )];
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTopGap,(buttonWidth-buttonImageWidth)/2,0, 0)];
    
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0 )];
}


#pragma mark - 地图相关
//设置地图
-(void)setUpMap
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
}

//开始定位
-(void)startLocation
{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            //  NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        //  NSLog(@"location:%@-----%f", location,[location.timestamp timeIntervalSince1970]);
        // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            
            self.startAddress=regeocode.formattedAddress;
            if (regeocode.city != nil)
            {
                [[NSUserDefaults standardUserDefaults] setObject:regeocode.city forKey:@"current_city"];
            }
            
        }
    }];
}

- (shouYeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [shouYeHeaderView createView];
//        __weak typeof(self) weakSelf = self;
        _headerView.peakHoursBlock = ^(NSString *state) {
//            PeakAndTodayHoursViewController *vc = [[PeakAndTodayHoursViewController alloc] init];
//            vc.state = state;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _headerView.todayHoursBlock = ^(NSString *state) {
//            PeakAndTodayHoursViewController *vc = [[PeakAndTodayHoursViewController alloc] init];
//            vc.state = state;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _headerView;
}

- (CYAlertView *)singleAlertView{
    if (!_singleAlertView) {
    
       UIWindow *window =[UIApplication sharedApplication].delegate.window;
        _singleAlertView =[[CYAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        [window addSubview:_singleAlertView];
    }
    
    return _singleAlertView;
}

@end

