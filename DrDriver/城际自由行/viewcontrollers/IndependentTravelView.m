//
//  IndependentTravelView.m
//  DrDriver
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "IndependentTravelView.h"

#import "AppDelegate.h"
#import "CYStarView.h"
#import "CYLableView.h"
#import "TripTableViewCell.h"
#import "TripDetailViewController.h"
#import "TripOneTableViewCell.h"

#import "CYOrderView.h"
//#import "LoginViewController.h"
#import "QuickLoginViewController.h"
#import "CompleteOrderModel.h"
#import "MessageViewController.h"
#import "CYAlertView.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "JPUSHService.h"

#import "SpeechSynthesizer.h"
#import "AFNetworking.h"

#import <AudioToolbox/AudioToolbox.h>//调用系统提示音头文件
#import <sys/utsname.h>

#import "UpdateAlertView.h"
#import "ITTripDetailViewController.h"
#import "ITDriverModel.h"
#import "ShouYeModel.h"
#import "TopTypeView.h"
#import "ITDriverOrderViewController.h"
#import "ITUserOrderViewController.h"
#import "SelectPathViewController.h"
#import "ITUserDetailViewController.h"

#import "ScanQRcodeViewController.h"


@interface IndependentTravelView () <UIScrollViewDelegate,AMapLocationManagerDelegate>
{
    UIButton * stopButton;//停止听单按钮
    
    UIView * bgWhiteView;//白色背景视图
    
    UIImageView * headImageView;
    UILabel * nickNameLable;
    CYStarView * starView;
    CYLableView * midelView;
    CYLableView * leftView;
    CYLableView * rightView;
    NSString *touchuanStr;
    
    NSMutableArray * nowOrderArray;//进行中的订单
    
    BOOL isFirstJoin;//是否是第一次进程序
    
    //    NSInteger driver_class;//司机类型 1：快车司机 2：出租车司机
}


@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSString * startAddress;//开始位置
@property (nonatomic,strong) NSTimer * timer;


@property (nonatomic ,assign)NSInteger driver_class;//司机类型 1：快车司机 2：出租车司机


@property(nonatomic,strong)TopTypeView *ITTopView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)ITDriverOrderViewController *ITDView;
@property(nonatomic,strong)ITUserOrderViewController *ITUView;


@property(nonatomic,copy)NSString *start_province;
@property(nonatomic,copy)NSString *start_city;
@property(nonatomic,copy)NSString *start_county;

@end

@implementation IndependentTravelView

//监控网络状态
- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            NSLog(@"网络连接正常");
            
            [self refreshDown];//请求司机信息
            
        }else{
//            NSLog(@"网络连接错误");
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {
//        NSLog(@"您没有开启了定位权限");
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
    
    if (self.ITDView.midleButtonView.buttonState==ALREADY_LISTEN) {
        
        stopButton.hidden=NO;
        [self.ITDView.midleButtonView circlAnimation];//听单动画
        
    }else{
        
        stopButton.hidden=YES;
    }
    
    if (_isNeedReload) {
        [self refreshDown];//刷新数据
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chengjiMessage:) name:@"chengjiMessage" object:nil];
}
//定位事件
-(void)startLocation
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout =2;
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
//        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
//            NSLog(@"reGeocode:%@    %@",regeocode.province,regeocode.city);
            NSString *cityName = @"";
            if (regeocode.city  == nil) {
                cityName = @"天津市";
                
                self.start_province = @"天津市";
                self.start_city = @"天津市";
                self.start_county = @"不限";
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_province"];
                //                [self.ITUView.searchModel setValue:self.start_city forKey:@"start_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_county"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_province"];
                //                [self.ITUView.searchModel setValue:self.start_city forKey:@"end_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_county"];
                //                [self.ITUView.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getCurrentTime]] forKey:@"start_date"];
                //                [self.ITUView.searchModel setValue:@"00:00" forKey:@"start_time"];
                //                [self.ITUView.searchModel setValue:@"23:59" forKey:@"end_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_date"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"passenger_num"];
                //                self.ITUView.ITstartLB.text = self.start_city;
                self.ITUView.ITstartLB.text = @"不限";
                //                self.ITUView.ITendLB.text = self.start_city;
                self.ITUView.ITendLB.text = @"不限";
                [self.ITUView.ITTimeBtn setTitle:@"不限" forState:(UIControlStateNormal)];
                [self.ITUView.ITNumberBtn setTitle:@"乘车人数" forState:(UIControlStateNormal)];
                [self.ITUView creatHttp];
            }else{
                cityName = regeocode.city;
                
                self.start_province = regeocode.province;
                self.start_city = regeocode.city;
                self.start_county = @"不限";
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_province"];
                //                [self.ITUView.searchModel setValue:self.start_city forKey:@"start_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_county"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_province"];
                //                [self.ITUView.searchModel setValue:self.start_city forKey:@"end_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_city"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_county"];
                //                [self.ITUView.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getCurrentTime]] forKey:@"start_date"];
                //                [self.ITUView.searchModel setValue:@"00:00" forKey:@"start_time"];
                //                [self.ITUView.searchModel setValue:@"23:59" forKey:@"end_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_date"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"start_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"end_time"];
                [self.ITUView.searchModel setValue:@"-" forKey:@"passenger_num"];
                //                self.ITUView.ITstartLB.text = self.start_city;
                self.ITUView.ITstartLB.text = @"不限";
                //                self.ITUView.ITendLB.text = self.start_city;
                self.ITUView.ITendLB.text = @"不限";
                [self.ITUView.ITTimeBtn setTitle:@"不限" forState:(UIControlStateNormal)];
                [self.ITUView.ITNumberBtn setTitle:@"乘车人数" forState:(UIControlStateNormal)];
                [self.ITUView creatHttp];
            }
            
        }
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chengjiMessage" object:nil];
    
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider setPanEnabled:NO];
}
-(void)stopListen{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chengjiMessage" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    touchuanStr = @"";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //    StatusBarHeight
    nowOrderArray = [NSMutableArray array];
    self.title=@"网路出行";
    isFirstJoin=YES;
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopListen) name:@"stop_listen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"loginfailed" object:nil];//登录过期
    
    //接受透传消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTouChuan:) name:@"touchuan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiangqing) name:@"SCANVC_xiangqing" object:nil];
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self creatWhiteBgView];//创建白色背景视图
    [self reachability];//监控网络状态
    //检查软件是否需要更新
    [self checkForUpdate];
    [self startLocation];
}
-(void)xiangqing{
    MessageViewController *min = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:min animated:YES];
}
#pragma mark ------  程序没有运行时点击通知事件
-(void)backGroundMessage{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSString *state = [users objectForKey:@"messagePushState"];
    if ([state isEqualToString:@"yes"]) {
        [users setObject:@"no" forKey:@"messagePushState"];
        [users synchronize];
        NSString *travelID = [users objectForKey:@"messagePushData"];
        __weak typeof(self) weakSelf = self;
        ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
        vc.travelID = travelID;
        vc.state = @"driver";
        vc.isCanListen = weakSelf.ITDView.isCanListen;
        vc.getDateBlock = ^{
            [weakSelf refreshUp];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ------  程序在后台运行时是点击通知事件
-(void)chengjiMessage:(NSNotification *)noti
{
    if ([noti.userInfo[@"operate_class"] isEqualToString:@"driver_travel_msg"]) {
        NSString *str =noti.userInfo[@"travel_id"];
        __weak typeof(self) weakSelf = self;
        ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
        vc.travelID = str;
        vc.dateStr = @"";
        vc.timeStr = @"";
        vc.state = @"driver";
        vc.isCanListen = weakSelf.ITDView.isCanListen;
        vc.getDateBlock = ^{
            [weakSelf refreshUp];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark---------------------- 接收到透传消息
-(void)receiveTouChuan:(NSNotification *)noti
{
//    NSLog(@"城际自由行透传消息%@",noti.userInfo);
    if ([noti.userInfo[@"extras"][@"operate_class"] isEqualToString:@"new_travel_order"]) {
        [self playVideo:noti.userInfo[@"content"]];
        [self refreshDown];
    }
    if ([noti.userInfo[@"extras"][@"operate_class"] isEqualToString:@"cancel_travel_order"]) {
        [self playVideo:noti.userInfo[@"content"]];
        [self refreshDown];
    }
    if ([noti.userInfo[@"extras"][@"operate_class"] isEqualToString:@"new_user_order"]) {
        [self playVideo:noti.userInfo[@"content"]];
        [self.ITUView creatHttp];
    }
    
    
    //乘客已付款
    if ([noti.userInfo[@"extras"][@"operate_class"] isEqualToString:@"passenger_payment"]) {
//        NSLog(@"网路出行收款%@元",noti.userInfo[@"extras"][@"journey_fee"]);
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:[NSString stringWithFormat:@"网路出行收款%@元",noti.userInfo[@"extras"][@"journey_fee"]]];
    }
}
//播放推送标题
-(void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}
//登录过期的通知
-(void)loginFailed
{
    QuickLoginViewController * vc=[[QuickLoginViewController alloc]init];
    vc.isMainJump=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//上拉加载------------------
-(void)refreshUp
{
    self.ITDView.currentPage=[NSString stringWithFormat:@"%d",[self.ITDView.currentPage intValue]+1];
    [self creatHttp];
}
//下拉刷新
-(void)refreshDown
{
    self.ITDView.currentPage=@"1";
    [nowOrderArray removeAllObjects];
    [self creatHttp];
}
#pragma mark --------------  请求司机信息
-(void)creatHttp{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_DRIVER_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        ShouYeModel * shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([self.ITDView.currentPage intValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_message" object:self userInfo:@{@"message":shouYe}];
        }
        ITDriverModel *driverModel = [ITDriverModel mj_objectWithKeyValues:responseObject[@"data"]];
        NSArray *arr = responseObject[@"data"][@"travel_list"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"title"] isEqualToString:@"today"]) {
                self.ITDView.today_list = dic[@"list"];
            }else if ([dic[@"title"] isEqualToString:@"tomorrow"]){
                self.ITDView.tomorrow_list = dic[@"list"];
            }else if ([dic[@"title"] isEqualToString:@"after_tomorrow"]){
                self.ITDView.after_tomorrow_list = dic[@"list"];
            }
        }
        self.ITUView.seat_num = responseObject[@"data"][@"seat_num"];
//        NSLog(@"responseObject    =========   %@",responseObject[@"data"]);
        if (driverModel.audit_state == 2) {//可以听单
            self.ITDView.isCanListen=YES;
            self.ITUView.isCanListen = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCanListen"];
        } else {
            self.ITDView.isCanListen=NO;
            self.ITUView.isCanListen = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCanListen"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:driverModel.invite_code forKey:@"invite_code"];
        
        _driver_class=driverModel.driver_class;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:driverModel.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
        nickNameLable.text=driverModel.driver_name;
        int height=[CYTSI planRectWidth:nickNameLable.text font:14];
        [nickNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(height);
        }];
        
        leftView.bottomLable.text=[NSString stringWithFormat:@"%ld",(long)driverModel.cumulate_count];
        
        [self backGroundMessage];
        [self.ITDView.foldingTableView reloadData];
        
        [self.ITDView.foldingTableView.mj_header endRefreshing];
        //        if ([currentPage intValue]>[driverModel.complete_order.total_page intValue]) {
        //            [self.foldingTableView .mj_footer endRefreshingWithNoMoreData];
        //        }else{
        [self.ITDView.foldingTableView.mj_footer endRefreshing];
        //        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
        
    } failure:^(NSError *error) {
        
        [self.ITDView.foldingTableView.mj_header endRefreshing];
        [self.ITDView.foldingTableView.mj_footer endRefreshing];
        
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView) {
        if (scrollView.contentOffset.x == 0) {
            [self.ITTopView.ITDriverBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
            [self.ITTopView.ITUserBtn setTintColor:[UIColor blackColor]];
            [self.ITUView.searchModel setValue:@"-" forKey:@"start_province"];
            //                [self.ITUView.searchModel setValue:self.start_city forKey:@"start_city"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"start_city"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"start_county"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"end_province"];
            //                [self.ITUView.searchModel setValue:self.start_city forKey:@"end_city"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"end_city"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"end_county"];
            //                [self.ITUView.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getCurrentTime]] forKey:@"start_date"];
            //                [self.ITUView.searchModel setValue:@"00:00" forKey:@"start_time"];
            //                [self.ITUView.searchModel setValue:@"23:59" forKey:@"end_time"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"start_date"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"start_time"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"end_time"];
            [self.ITUView.searchModel setValue:@"-" forKey:@"passenger_num"];
            //                self.ITUView.ITstartLB.text = self.start_city;
            self.ITUView.ITstartLB.text = @"不限";
            //                self.ITUView.ITendLB.text = self.start_city;
            self.ITUView.ITendLB.text = @"不限";
            [self.ITUView.ITTimeBtn setTitle:@"不限" forState:(UIControlStateNormal)];
            [self.ITUView.ITNumberBtn setTitle:@"乘车人数" forState:(UIControlStateNormal)];
            [self.ITUView creatHttp];
            
        }else if(scrollView.contentOffset.x == DeviceWidth){
            [self.ITTopView.ITDriverBtn setTintColor:[UIColor blackColor]];
            [self.ITTopView.ITUserBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
            
            
            [self.ITDView refreshDown];
        }
    }
}
//创建主要视图
-(void)creatMainView
{
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, topHeight, DeviceWidth, 164)];
    [self.view addSubview:headerView];
    headerView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye"]];
    bgImageView.frame = CGRectMake(0, 0, DeviceWidth, 164);
    [headerView addSubview:bgImageView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake((DeviceWidth-81)/2, 25, 81, 81);
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    layer.shadowOpacity=0.3;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.cornerRadius=40.5;
    [headerView.layer addSublayer:layer];
    
    
    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/2 - 41, 25, 82, 82)];
    headImageView.layer.cornerRadius=41;
    headImageView.layer.masksToBounds=YES;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:headImageView];
    
    nickNameLable=[[UILabel alloc]init];
    nickNameLable.text=@"----";
    nickNameLable.textColor=[UIColor whiteColor];
    nickNameLable.font=[UIFont systemFontOfSize:14];
    nickNameLable.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:nickNameLable];
    [nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        make.top.equalTo(headImageView.mas_bottom).with.offset(11);
    }];
    
#pragma mark ---选项卡
    __weak typeof(self) weakSelf = self;
    self.ITTopView = [[TopTypeView alloc] initWithFrame:CGRectMake(0, 169 + topHeight, DeviceWidth, 40)];
    self.ITTopView.ITDriverActionBlock = ^{
        [weakSelf.ITTopView.ITDriverBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
        [weakSelf.ITTopView.ITUserBtn setTintColor:[UIColor blackColor]];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"start_province"];
        //        [weakSelf.ITUView.searchModel setValue:weakSelf.start_city forKey:@"start_city"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"start_city"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"start_county"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"end_province"];
        //        [weakSelf.ITUView.searchModel setValue:weakSelf.start_city forKey:@"end_city"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"end_city"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"end_county"];
        //        [weakSelf.ITUView.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getCurrentTime]] forKey:@"start_date"];
        //        [weakSelf.ITUView.searchModel setValue:@"00:00" forKey:@"start_time"];
        //        [weakSelf.ITUView.searchModel setValue:@"23:59" forKey:@"end_time"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"start_date"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"start_time"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"end_time"];
        [weakSelf.ITUView.searchModel setValue:@"-" forKey:@"passenger_num"];
        //        weakSelf.ITUView.ITstartLB.text = weakSelf.start_city;
        //        weakSelf.ITUView.ITendLB.text = weakSelf.start_city;
        weakSelf.ITUView.ITstartLB.text = @"不限";
        weakSelf.ITUView.ITendLB.text = @"不限";
        [weakSelf.ITUView.ITTimeBtn setTitle:@"不限" forState:(UIControlStateNormal)];
        [weakSelf.ITUView.ITNumberBtn setTitle:@"乘车人数" forState:(UIControlStateNormal)];
        [weakSelf.ITUView creatHttp];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    };
    self.ITTopView.ITUserActionBlock = ^{
        [weakSelf.ITDView refreshDown];
        [weakSelf.ITTopView.ITDriverBtn setTintColor:[UIColor blackColor]];
        [weakSelf.ITTopView.ITUserBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(DeviceWidth, 0);
        }];
    };
    [self.view addSubview:self.ITTopView];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 209 + topHeight, DeviceWidth, self.view.bounds.size.height - topHeight - Bottom_Height - 189)];
    self.scrollView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.scrollView.layer.cornerRadius = 6;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.ITUView = [[ITUserOrderViewController alloc] init];
    self.ITUView.view.frame = CGRectMake(0, 0, DeviceWidth, self.view.bounds.size.height - topHeight - 189);
    self.ITUView.userPushDetail = ^(NSString * _Nonnull order_id, BOOL isCanListen) {
        ITUserDetailViewController *vc = [[ITUserDetailViewController alloc] init];
        vc.state = @"independent";
        vc.order_id = order_id;
        vc.isCanListen = isCanListen;
        vc.getMainData = ^{
            [weakSelf refreshUp];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self addChildViewController:self.ITUView];
    [self.scrollView addSubview:self.ITUView.view];
    
    self.ITDView = [[ITDriverOrderViewController alloc] init];
    self.ITDView.pushCreationOrder = ^{
        SelectPathViewController *vc = [[SelectPathViewController alloc] init];
        vc.start_province = weakSelf.start_province;
        vc.start_city = weakSelf.start_city;
        vc.start_county = weakSelf.start_county;
        vc.getMainData = ^{
            [weakSelf refreshUp];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.ITDView.pushDetailVC = ^(NSString * _Nonnull travelID, NSString * _Nonnull date, NSString * _Nonnull time) {
        ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
        vc.state = @"driver";
        vc.isCanListen = weakSelf.ITDView.isCanListen;
        vc.getDateBlock = ^{
            [weakSelf refreshUp];
        };
        vc.travelID = travelID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.ITDView.refreshD = ^{
        [weakSelf refreshDown];
    };
    self.ITDView.refreshU = ^{
        [weakSelf refreshUp];
    };
    self.ITDView.view.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, self.view.bounds.size.height - topHeight - 189);
    [self addChildViewController:self.ITDView];
    [self.scrollView addSubview:self.ITDView.view];//把子控制器的 view 添加到父控制器的 view 上面
    self.scrollView.contentSize = CGSizeMake(DeviceWidth * 2, self.view.bounds.size.height - topHeight - Bottom_Height - 189);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
#pragma mark ---- 检查软件是否需要更新
-(void)checkForUpdate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [AFRequestManager postRequestWithUrl:DRIVER_VERSION_DRIVER_CLIENT_UPDATE_IOS params:@{@"version":[infoDictionary objectForKey:@"CFBundleShortVersionString"]} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"CFBundleShortVersionString%@",responseObject);
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
