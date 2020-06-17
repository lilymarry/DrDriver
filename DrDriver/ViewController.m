//
//  ViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CYStarView.h"
#import "CYLableView.h"
#import "TripTableViewCell.h"
#import "TripDetailViewController.h"
#import "TripOneTableViewCell.h"
#import "CYButtonView.h"
#import "CYOrderView.h"
#import "RobSuccessViewController.h"
//#import "LoginViewController.h"
#import "QuickLoginViewController.h"
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
#import "AppointAirListViewController.h"
#import "FaceAlertView.h"

#import "AFNetworking.h"
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "FaceViewController.h"

#import "PeakAndTodayHoursViewController.h"//高峰在线、今日在线
#import "ScanQRcodeViewController.h"//扫码车
#import "ITShouYeTableViewCell.h"
#import "ITAddTravelTableViewCell.h"
#import "ITTripDetailViewController.h"
#import "SelectPathViewController.h"
#import "TuiSongListViewController.h"
//static SystemSoundID push = 0;
#import "NewTripViewController.h"
#import "FaceViewController.h"
//校园拼相关
#import "SchoolViewCell.h"
#import "SLTripList.h"
#import "SLTripDetialViewController.h"
#import "AfterSchoolTripDetialViewController.h"
#import "SLTripListViewController.h"

#import "PbulishLineView.h"
#import "CustomizeViewController.h"

#import "GotoWorkViewController.h"
#import "AfterWorkViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate>
{
    UITableView *myTableView;

    UIView *bgWhiteView; //白色背景视图
    NSString *currentPage; //当前分页数

    UIImageView *headImageView;
    UILabel *nickNameLable;
    CYStarView *starView;
    CYLableView *midelView;
    CYLableView *leftView;
    CYLableView *rightView;

    NSArray *nowOrderArray; //进行中的订单
    NSMutableArray *completeOrderArray; //已完成的订单

    BOOL isFirstJoin;//是否是第一次进程序

    CYAlertView *singleAlertView; //单个按钮弹出视图
    UIWindow *window;
}
@property (nonatomic, copy) NSString *driver_face_state;//是否已经认证,1已认证，0未认证
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSString *startAddress; //开始位置
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CYAlertView *unEndOrderView;//有未完成订单弹出视图
@property (nonatomic, strong) CYButtonView *midleButtonView;//中间听单视图
@property (nonatomic, strong) CYOrderView *orderView;//地址视图
@property (nonatomic, strong) NotiMessageModel *notiMessage;//透传接收的新订单推送消息
@property (nonatomic, strong) UIButton *stopButton;//停止听单按钮
@property (strong, nonatomic) UIButton *tuisongBtn;//推送记录按钮

@property (nonatomic, assign) NSInteger driver_class;//司机类型 1：快车司机 2：出租车司机
@property (nonatomic, strong) shouYeHeaderView *headerView;
@property (nonatomic, strong) CYAlertView *successAppointView;//抢单成功弹出视图

//@property(nonatomic,assign)BOOL  isChange;//是否改变订单弹窗位置
//@property (nonatomic, copy) NSString *listen_face_state;//听单是否需要扫脸,1开启，0关闭
//@property (nonatomic, copy) NSString *receipt_face_state;//接单是否需要扫脸,1开启，0关闭

@property (nonatomic, copy) NSString *face_number;//活体检测需要的检测数量
@property (nonatomic, strong) FaceAlertView *alert;

@property (nonatomic, copy) NSString *start_province;
@property (nonatomic, copy) NSString *start_city;
@property (nonatomic, copy) NSString *start_county;

@property (nonatomic, strong, readwrite) NSArray<SLTripList *> *schoolArray;
@property (nonatomic, strong, readwrite) NSArray<SLTripList *> *workArray;
@property (nonatomic, copy) NSString *whichType;
@end

@implementation ViewController

//监控网络状态00000000000000
- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            NSLog(@"网络连接正常");
            [[NSUserDefaults standardUserDefaults] setValue:@"y" forKey:@"network"];

            if (self.midleButtonView.buttonState == ROB_ORDER) {//抢单中
                return;
            }
            //            [self refreshDown];//请求司机信息
        } else {
            [[NSUserDefaults standardUserDefaults] setValue:@"n" forKey:@"network"];
//            NSLog(@"网络连接错误");
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    } else if (buttonIndex == 1) {
        NSURL *url = [NSURL  URLWithString:UIApplicationOpenSettingsURLString];

        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self setUpNav];//设置导航栏
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        //位置服务是在设置中禁用
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

    AppDelegate *mainAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider setPanEnabled:YES];

    //    [self stopButtonClicked];

    if (self.midleButtonView.buttonState == ALREADY_LISTEN) {
        _stopButton.hidden = NO;
        [self.midleButtonView circlAnimation];//听单动画
    } else {
        _stopButton.hidden = YES;
    }

    [self refreshDown];//刷新数据
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //关闭视图
    bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
    [UIView animateWithDuration:0.3 animations:^{
        _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
    }];

    AppDelegate *mainAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider setPanEnabled:NO];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    //    StatusBarHeight

    self.title = @"网路叫车";
    isFirstJoin = YES;
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    completeOrderArray = [[NSMutableArray alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"loginfailed" object:nil];//登录过期

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFront) name:@"change_front" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopListen) name:@"stop_listen" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginListen) name:@"beginListen" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiangqing) name:@"VC_xiangqing" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overTime) name:@"overTime" object:nil];

    [self creatMainView];//创建主要视图
    [self creatWhiteBgView];//创建白色背景视图
    [self creatBottomView];//创建底部视图
    [self creatAlertView];//创建弹出视图
    [self setUpMap];//设置地图
    //    [self refreshDown];//请求司机信息

    [self reachability];//监控网络状态
    [self startLocation];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"jpushMessage"] isEqualToString:@"xiangqing"]) {
        [self xiangqing];
    }
    //检查软件是否需要更新
    [self checkForUpdate];

    [[UIApplication sharedApplication].keyWindow addSubview:self.alert];


    self.schoolArray = [NSArray array];
    self.workArray = [NSArray array];
}

#pragma mark ----- overTime
- (void)overTime {
    [self playVideo:@"您已连续驾车超过4小时，为了您和乘客的安全，请停车下线休息20分钟。"];
    [self stop:@"overtime"];
}

#pragma mark ---- 检查未完成的推送信息
- (void)checkUnfinishNewOrder {
//    [AFRequestManager postRequestWithUrl:UNFINISH_NEW_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"CFBundleShortVersionString213123123123%@  %@",responseObject,responseObject[@"message"]);
//        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
//            [self unfinishNewOrder:responseObject[@"data"]];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"CFBundleShortVersionString213123123123%@",error);
//    }];
}

- (void)unfinishNewOrder:(NSDictionary *)orderDic {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"1"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"2"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"4"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"7"]  || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"5"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
        NotiModel *theNotiMessageModel = [NotiModel mj_objectWithKeyValues:orderDic];
        //预约单
        if (theNotiMessageModel.submit_class == 1 && [theNotiMessageModel.appoint_type isEqualToString:@"1"]) {
            if ([self backViewController]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
                    [self setmidleBtn];
                    [self unfinish:orderDic];
                    _orderView.stateFlag = @"1";
                    _orderView.startStr = theNotiMessageModel.start_address;
                    _orderView.endStr = theNotiMessageModel.end_address;
                    _orderView.yuYueLable.text = theNotiMessageModel.appoint_time;
                    _orderView.remark = theNotiMessageModel.remark;
                }
                return;
            }
        }
        //接机单
        if (theNotiMessageModel.submit_class == 1 && [theNotiMessageModel.appoint_type isEqualToString:@"2"]) {
            if ([self backViewController]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
                    [self setmidleBtn];
                    [self unfinish:orderDic];
                    _orderView.stateFlag = @"2";
                    _orderView.startStr = theNotiMessageModel.start_address;
                    _orderView.endStr = theNotiMessageModel.end_address;
                    _orderView.airPortLable.text = [NSString stringWithFormat:@"航班号：%@", theNotiMessageModel.flight_number];
                    _orderView.airPortDateLable.text = [NSString stringWithFormat:@"%@到达", theNotiMessageModel.appoint_time];
                    _orderView.remark = theNotiMessageModel.remark;
                }
                return;
            }
        }
        //新订单
//        NSLog(@"++++++++++++++++");
        if (theNotiMessageModel.submit_class == 1 || theNotiMessageModel.submit_class == 2) {
//            NSLog(@"new_order");
            if ([self backViewController]) {
//                NSLog(@"backViewControllerbackViewController");
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
                    //                    NSLog(@"receive_notireceive_notireceive_notireceive_noti");
                    [self setmidleBtn];
                    [self unfinish:orderDic];
                    _orderView.stateFlag = @"0";
                    _orderView.startStr = theNotiMessageModel.start_address;
                    _orderView.endStr = theNotiMessageModel.end_address;

                    _orderView.startDistanceLable.text = [NSString stringWithFormat:@"接驾%.2f公里", [theNotiMessageModel.distance floatValue]];
                    _orderView.allDistanceLable.text = [NSString stringWithFormat:@"全程%.2f公里", [theNotiMessageModel.journey_mile floatValue]];
                    _orderView.remark = theNotiMessageModel.remark;
                    [CYTSI setStringWith:_orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.distance floatValue]] lable:_orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    [CYTSI setStringWith:_orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.journey_mile floatValue]] lable:_orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    if (theNotiMessageModel.submit_class == 2) {
                        _orderView.endStr = @"目的地待与乘客确认";
                        _orderView.allDistanceLable.text = @"";
                    }
                }
                return;
            }
        }
    }
}

- (void)setmidleBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
    self.midleButtonView.buttonState = ALREADY_LISTEN;
    [self.midleButtonView circlAnimation];
    self.stopButton.hidden = NO;
    [self setNotification];
    [self.alert hidenFaceAlertView];
}

- (void)unfinish:(NSDictionary *)noti {
    [self.successAppointView hideAlertView];
    //有新订单的时候
    _notiMessage = [NotiMessageModel mj_objectWithKeyValues:@{ @"extras": noti }];

    [self closeRobOrderView];

    //关闭视图
    bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
    _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
#pragma mark -- 判断左侧栏是否弹出
    AppDelegate *mainAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (mainAppDelegate.leftSlider.mainVC.view.center.x > 50) {
        [mainAppDelegate.leftSlider closeLeftView];
    }
    [UIView animateWithDuration:1 animations:^{
        bgWhiteView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 102 - Bottom_Height);
        [UIView animateWithDuration:0.3 animations:^{
            _orderView.frame = CGRectMake(20, DeviceHeight - 105 - 297 - Bottom_Height, DeviceWidth - 40, 297);
        }];
    }];
    if ([_notiMessage.extras.remark isEqualToString:@""] || _notiMessage.extras.remark == nil) {
        _orderView.bottomLb.text = @"";
    } else {
        _orderView.bottomLb.text = [NSString stringWithFormat:@"备注：%@", _notiMessage.extras.remark];
    }
    //弹出视图
    if (_notiMessage.extras.submit_class == 2) {
        _orderView.isShake = YES;
        _orderView.endStr = @"目的地待与乘客确认";
    }
    //设置抢单中的时间
    self.midleButtonView.secondeLable.text = [NSString stringWithFormat:@"%@秒", noti[@"remain_time"]];
    [self.midleButtonView stropCirclAnimation];
    [self.midleButtonView robOrderAnimation];
    //收到订单推送的回执
    [self orderPushReceipt:_notiMessage.extras.order_id];
}

#pragma mark ---- 检查软件是否需要更新
- (void)checkForUpdate {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [AFRequestManager postRequestWithUrl:DRIVER_VERSION_DRIVER_CLIENT_UPDATE_IOS params:@{ @"version": [infoDictionary objectForKey:@"CFBundleShortVersionString"] } tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"CFBundleShortVersionString%@", responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            if ([responseObject[@"data"][@"is_force"] isEqualToString:@"1"]) {
                if (![responseObject[@"data"][@"version"] isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]) {
                    //关闭广告弹窗
#pragma mark ------ 创建更新alertView
                    UpdateAlertView * updateAlertView = [[UpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
                    updateAlertView.descriptionLabel.text = responseObject[@"data"][@"description"];
                    updateAlertView.versionNumberLabel.text = [NSString stringWithFormat:@"V %@", responseObject[@"data"][@"version"]];
                    [[UIApplication sharedApplication].keyWindow addSubview:updateAlertView];
                }
            }
        }
    } failure:^(NSError *error) {
    }];
}

//接受开始听单消息
- (void)beginListen {
    self.midleButtonView.buttonState = ALREADY_LISTEN;
}

- (void)xiangqing {
    MessageViewController *min = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:min animated:YES];
}

- (void)newOrder:(NSDictionary *)noti {
    [self.successAppointView hideAlertView];
    //有新订单的时候
    _notiMessage = [NotiMessageModel mj_objectWithKeyValues:noti];

    [self closeRobOrderView];

    [self playVideo:[_notiMessage.content uppercaseString]];//播放推送标题

    //关闭视图
    bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
    _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
#pragma mark -- 判断左侧栏是否弹出
    AppDelegate *mainAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

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
        self.orderView.addressView.startImageView.frame = CGRectMake(16, 52, 25, 25);
        self.orderView.addressView.endImageView.image = [UIImage imageNamed:@"坐标-终点q"];
        [self.orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.top.equalTo(self.orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            bgWhiteView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 102 - Bottom_Height);
            [UIView animateWithDuration:0.3 animations:^{
                _orderView.frame = CGRectMake(20, DeviceHeight - 105 - 337 - Bottom_Height, DeviceWidth - 40, 337);
                self.orderView.bgImageView.frame = CGRectMake(0, 0, DeviceWidth - 40, 337);
            }];
        }];
    } else {
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
        self.orderView.addressView.startImageView.frame = CGRectMake(16, 52, 11, 11);
        self.orderView.addressView.endImageView.image = [UIImage imageNamed:@"end_adreess"];
        [self.orderView.addressView.endImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.orderView.addressView.startImageView.mas_centerX);
            make.width.equalTo(@11);
            make.height.equalTo(@11);
            make.top.equalTo(self.orderView.addressView.startAddressLB.mas_bottom).with.offset(10);
        }];
        [UIView animateWithDuration:1 animations:^{
            bgWhiteView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 102 - Bottom_Height);
            [UIView animateWithDuration:0.3 animations:^{
                _orderView.frame = CGRectMake(20, DeviceHeight - 105 - 297 - Bottom_Height, DeviceWidth - 40, 297);
                self.orderView.bgImageView.frame = CGRectMake(0, 0, DeviceWidth - 40, 297);
            }];
        }];
    }
    if ([_notiMessage.extras.remark isEqualToString:@""] || _notiMessage.extras.remark == nil) {
        _orderView.bottomLb.text = @"";
    } else {
        _orderView.bottomLb.text = [NSString stringWithFormat:@"备注：%@", _notiMessage.extras.remark];
    }
    //弹出视图
    if (_notiMessage.extras.submit_class == 2) {
        _orderView.isShake = YES;
        _orderView.endStr = @"目的地待与乘客确认";
    }
    //设置抢单中的时间
    self.midleButtonView.secondeLable.text = @"60秒";
    [self.midleButtonView stropCirclAnimation];
    [self.midleButtonView robOrderAnimation];
    //收到订单推送的回执
    [self orderPushReceipt:_notiMessage.extras.order_id];
}

//接收到透传消息
- (void)TouChuan:(NSNotification *)noti
{
//    NSLog(@"ViewControllerNoti.userInfo%@", noti.userInfo);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"1"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"2"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"4"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"5"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"7"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
        NotiMessageModel *theNotiMessageModel = [NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
        //新订单
        NSLog(@"++++++++++++++++");
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"new_order"]) {
//            NSLog(@"new_order");
            if ([self backViewController]) {
//                NSLog(@"backViewControllerbackViewController");
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
        //                    NSLog(@"receive_notireceive_notireceive_notireceive_noti");
                    _orderView.stateFlag = @"0";
                    [self newOrder:noti.userInfo];
                    _orderView.startStr = _notiMessage.extras.start_name;
                    _orderView.endStr = _notiMessage.extras.end_name;
                    _orderView.addressView.startAddressLB.text = _notiMessage.extras.start_address;
                    _orderView.addressView.endAddressLB.text = _notiMessage.extras.end_address;
                    _orderView.titleLable.text = _notiMessage.extras.order_name;

                    _orderView.startDistanceLable.text = [NSString stringWithFormat:@"接驾%.2f公里", [_notiMessage.extras.distance floatValue]];
                    _orderView.allDistanceLable.text = [NSString stringWithFormat:@"全程%.2f公里", [_notiMessage.extras.journey_mile floatValue]];
                    _orderView.remark = _notiMessage.extras.remark;
                    [CYTSI setStringWith:_orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.distance floatValue]] lable:_orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    [CYTSI setStringWith:_orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.journey_mile floatValue]] lable:_orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    if (_notiMessage.extras.submit_class == 2) {
                        _orderView.endStr = @"目的地待与乘客确认";
                        _orderView.allDistanceLable.text = @"";
                    }
                }
                return;
            }
        }
        //一口价新订单
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"new_user_order"]) {
//            NSLog(@"new_user_order");
            if ([self backViewController]) {
//                NSLog(@"backViewControllerbackViewController");
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
        //                    NSLog(@"receive_notireceive_notireceive_notireceive_noti");

                    _orderView.stateFlag = @"3";
                    [self newOrder:noti.userInfo];
                    _orderView.titleLable.text = _notiMessage.extras.order_name;
                    _orderView.startStr = _notiMessage.extras.start_name;
                    _orderView.endStr = _notiMessage.extras.end_name;
                    _orderView.addressView.startAddressLB.text = _notiMessage.extras.start_address;
                    _orderView.addressView.endAddressLB.text = _notiMessage.extras.end_address;
                    _orderView.addressView.startCityLB.text = _notiMessage.extras.start_city;
                    _orderView.addressView.endCityLB.text = _notiMessage.extras.end_city;
                    _orderView.addressView.personLB.text = [NSString stringWithFormat:@"共%@人", _notiMessage.extras.passenger_num];
                    _orderView.addressView.luggageLB.text = [NSString stringWithFormat:@"共%@件", _notiMessage.extras.luggage_num];
                    _orderView.addressView.priceLB.text = [NSString stringWithFormat:@"%@元", _notiMessage.extras.journey_fee];

                    _orderView.startDistanceLable.text = [NSString stringWithFormat:@"接驾%.2f公里", [_notiMessage.extras.distance floatValue]];
                    _orderView.allDistanceLable.text = [NSString stringWithFormat:@"全程%.2f公里", [_notiMessage.extras.journey_mile floatValue]];
                    _orderView.remark = _notiMessage.extras.remark;
                    [CYTSI setStringWith:_orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.distance floatValue]] lable:_orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    [CYTSI setStringWith:_orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f", [_notiMessage.extras.journey_mile floatValue]] lable:_orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
                    if (_notiMessage.extras.submit_class == 2) {
                        _orderView.endStr = @"目的地待与乘客确认";
                        _orderView.allDistanceLable.text = @"";
                    }
                }
                return;
            }
        }
        //预约单
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"new_order_appoint"]) {
            if ([self backViewController]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
                    _orderView.stateFlag = @"1";
                    [self newOrder:noti.userInfo];
                    _orderView.startStr = _notiMessage.extras.start_name;
                    _orderView.endStr = _notiMessage.extras.end_name;
                    _orderView.addressView.startAddressLB.text = _notiMessage.extras.start_address;
                    _orderView.addressView.endAddressLB.text = _notiMessage.extras.end_address;
                    _orderView.titleLable.text = _notiMessage.extras.order_name;
                    _orderView.yuYueLable.text = _notiMessage.extras.appoint_time;
                    _orderView.remark = _notiMessage.extras.remark;
                }
                return;
            }
        }
        //接机单
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"new_order_flight"]) {
            if ([self backViewController]) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {//(排除正在抢单的)
                    _orderView.stateFlag = @"2";
                    [self newOrder:noti.userInfo];
                    _orderView.startStr = _notiMessage.extras.start_name;
                    _orderView.endStr = _notiMessage.extras.end_name;
                    _orderView.addressView.startAddressLB.text = _notiMessage.extras.start_address;
                    _orderView.addressView.endAddressLB.text = _notiMessage.extras.end_address;
                    _orderView.titleLable.text = _notiMessage.extras.order_name;
                    _orderView.airPortLable.text = [NSString stringWithFormat:@"航班号：%@", _notiMessage.extras.flight_number];
                    _orderView.airPortDateLable.text = [NSString stringWithFormat:@"%@到达", _notiMessage.extras.appoint_time];
                    _orderView.remark = _notiMessage.extras.remark;
                }
                return;
            }
        }
        //乘客已付款
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"passenger_payment"]) {
        //[self playVideo:theNotiMessageModel.content];//播放推送标题
            [self refreshDown];//更新订单状态
        //        _isChange = NO;

        //在听单的时候就不跳转页面了
            if (self.midleButtonView.buttonState == ROB_ORDER) {
                [CYTSI otherShowTostWithString:@"乘客已付款"];
                return;
            }
            [self playVideo:@"收到乘客付款"];
        }

        //乘客取消订单
        if ([theNotiMessageModel.extras.operate_class isEqualToString:@"passenger_cancel_order"]) {
            //                NSLog(@"ViewController ---------passenger_cancel_order");
            if ([self.navigationController.topViewController isKindOfClass:[ViewController class]]) {
            } else {
                NSArray *vcArray = self.navigationController.viewControllers;
                for (ViewController *vc in vcArray) {
                    if ([vc isKindOfClass:[ViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }

            [self addCancelView:theNotiMessageModel];

            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"order_id"];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"orderState", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];

            [self playVideo:theNotiMessageModel.content];//播放推送标题
            [CYTSI otherShowTostWithString:@"乘客取消订单"];
            [self refreshDown];//更新订单状态
        }
    }
}

- (void)addCancelView:(NotiMessageModel *)theNotiMessageModel {
    [singleAlertView removeFromSuperview];
    [window removeFromSuperview];
    window = [UIApplication sharedApplication].delegate.window;
    singleAlertView = [[CYAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:singleAlertView];

    __weak typeof (singleAlertView) weakSingleAlertView = singleAlertView;
    singleAlertView.cancleBlock = ^{
        [weakSingleAlertView hideAlertView];
    };
    //                singleAlertType=2;
    singleAlertView.titleStr = @"乘客已取消订单";
    singleAlertView.alertStr = [NSString stringWithFormat:@"很抱歉，乘客已取消订单。取消原因：%@。我们已开始继续为您派单，请稍等。", theNotiMessageModel.extras.cancel_reason];
    singleAlertView.cancleButtonStr = @"";
    singleAlertView.sureButtonStr = @"我知道了";
    [singleAlertView setSingleButton];
    [singleAlertView setTextFiled:YES];
    [singleAlertView showAlertView];

    singleAlertView.phoneBlock = ^{
        [weakSingleAlertView hideAlertView];
    };
}

#pragma mark  ------   收到订单推送的回执
- (void)orderPushReceipt:(NSString *)order_id {
    NSString *app_state = @"1";
    if ([CYTSI runningInBackground]) {
        app_state = @"2";
    } else {
        app_state = @"1";
    }
    if (order_id  != nil) {
        [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_ORDER_PUSH_RECEIPT params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"order_id": order_id, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"app_state": app_state } tost:YES special:0 success:^(id responseObject) {
        } failure:^(NSError *error) {
        }];
    }
}

//从后台变为前台的时候判断是否在听单
- (void)changeFront
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receive_noti"] intValue] == 1) {
        if (self.midleButtonView.buttonState == ALREADY_LISTEN) {
            [self.midleButtonView circlAnimation];//听单动画
        }
    }
}

//下拉刷新
- (void)refreshDown
{
    currentPage = @"1";
    [self creatHttp];
}

//上拉加载
- (void)refreshUp
{
    currentPage = [NSString stringWithFormat:@"%d", [currentPage intValue] + 1];
    [self creatHttp];
}

//请求司机信息
- (void)creatHttp
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [AFRequestManager postRequestWithUrl:DRIVER_BASE_DATA params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"p": currentPage } tost:YES special:0 success:^(id responseObject) {
        [ShouYeModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"unfinished_order": @"OrdeModel",
                      @"school_order":@"SLTripList",
                      @"work_order":@"SLTripList"
                      
            };
        }];

        [CompleteOrderModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"list": @"OrdeModel" };
        }];
       
        ShouYeModel *shouYe = [ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        NSLog(@"responseObject DRIVER_BASE_DATA   =========   %@", responseObject[@"data"]);

        if ([shouYe.driver_face_state isEqualToString:@"0"]) {
            [weakSelf.alert showFaceAlertView:@{} state:@"face" orderid:@"" btnSate:ROB_ORDER];
        }
        weakSelf.schoolArray = shouYe.school_order;
        weakSelf.workArray = shouYe.work_order;
        CGFloat topHeight = [CYTSI planRectHeight:responseObject[@"data"][@"notice"] font:15 theWidth:DeviceWidth - 30];
        weakSelf.headerView.frame = CGRectMake(0, 0, DeviceWidth, topHeight + 113);
        weakSelf.headerView.noticeLB.text = responseObject[@"data"][@"notice"];

        if (shouYe.audit_state == 2) {//可以听单
            weakSelf.midleButtonView.isCanListen = YES;
           
        } else {
            weakSelf.midleButtonView.isCanListen = NO;
        }

        if (shouYe.unfinished_order.count <= 0 && [currentPage isEqualToString:@"1"]) {
            weakSelf.midleButtonView.isHaveUnEndOrder = NO;
        } else {
            if (shouYe.unfinished_order.count > 0) {
                
                OrdeModel *theOrder = shouYe.unfinished_order[0];
                if (theOrder.journey_state == 4 || theOrder.journey_state == 0) {
                    weakSelf.midleButtonView.isHaveUnEndOrder = NO;
                } else {
                    weakSelf.midleButtonView.isHaveUnEndOrder = YES;

                    if (isFirstJoin) {
                        weakSelf.unEndOrderView.titleStr = @"温馨提示";
                        weakSelf.unEndOrderView.cancleButtonStr = @"忽略";
                        weakSelf.unEndOrderView.sureButtonStr = @"马上查看";
                        weakSelf.unEndOrderView.alertStr = @"您还有未完成的订单，是否立即查看?";
                        [weakSelf.unEndOrderView showAlertView];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:weakSelf userInfo:nil];
                        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)theOrder.journey_state], @"orderState", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:weakSelf userInfo:dict];

                        weakSelf.unEndOrderView.cancleBlock = ^{
                            [weakSelf.unEndOrderView hideAlertView];
                        };

                        weakSelf.unEndOrderView.phoneBlock = ^{
                            [weakSelf.unEndOrderView hideAlertView];
//                            NSLog(@"theOrder.driver_face_statetheOrder.driver_face_state%@", theOrder.driver_face_state);
                            if ([theOrder.driver_face_state isEqualToString:@"1"]) {
                                [weakSelf scanFaceAction:UNFINISHORDER responseObject:@{ @"model": theOrder } state:@"order"];
                            } else {
                                [weakSelf unfinishOrder:@{ @"model": theOrder }];
                            }
                        };
                    }
                }
            }
        }

        [[NSUserDefaults standardUserDefaults] setObject:shouYe.invite_code forKey:@"invite_code"];

        _driver_class = shouYe.driver_class;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:shouYe.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
        nickNameLable.text = shouYe.driver_name;
        int height = [CYTSI planRectWidth:nickNameLable.text font:14];
        [nickNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(height);
        }];
        weakSelf.driver_face_state = shouYe.driver_face_state;
        [starView setViewWithNumber:shouYe.appraise_stars width:14 space:2 enable:NO];
        midelView.bottomLable.text = shouYe.today_count;
        leftView.bottomLable.text = [NSString stringWithFormat:@"%ld", (long)shouYe.cumulate_count];
        rightView.bottomLable.text = shouYe.today_complete_rate;
        [[NSUserDefaults standardUserDefaults] setObject:shouYe.listen_face_state forKey:@"listen_face_state"];
        [[NSUserDefaults standardUserDefaults] setObject:shouYe.receipt_face_state forKey:@"receipt_face_state"];
        weakSelf.face_number = shouYe.face_number;
//        NSLog(@"shouYe.face_numbershouYe.face_number%@", shouYe.face_number);
        [[NSUserDefaults standardUserDefaults] setObject:self.face_number forKey:@"face_number"];
        if ([currentPage intValue] == 1) {
            [completeOrderArray removeAllObjects];
            nowOrderArray = shouYe.journey_order;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_message" object:weakSelf userInfo:@{ @"message": shouYe }];
        }
        if ([shouYe.online_state isEqualToString:@"1"]) {//1上班 0未上班
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
            weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
            [weakSelf.midleButtonView circlAnimation];
            weakSelf.stopButton.hidden = NO;
            [weakSelf setNotification];
            [weakSelf.alert hidenFaceAlertView];
        }else{
            if (weakSelf.stopButton.hidden == NO) {
                [weakSelf stopButtonClicked];
                [[NSUserDefaults standardUserDefaults] setObject:@"n" forKey:@"isWork"];
            };
            
        }
        if (isFirstJoin) {
            isFirstJoin = NO;
            //检查未完成的推送信息
            [weakSelf checkUnfinishNewOrder];
        }

        [completeOrderArray removeAllObjects];

        [completeOrderArray addObjectsFromArray:shouYe.travel_list];
        weakSelf.headerView.shouye = shouYe;
        [myTableView reloadData];

        [myTableView.mj_header endRefreshing];
        if ([currentPage intValue] > [shouYe.complete_order.total_page intValue]) {
            [myTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [myTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
    }];
}

- (FaceAlertView *)alert {
    if (!_alert) {
        _alert = [[FaceAlertView alloc] initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight)];
        __weak typeof(self) weakSelf = self;
        _alert.scanFaceBlock = ^(NSDictionary *dataDic, NSString *str, NSString *orderID, NSInteger btnState) {
            [weakSelf scanFaceAction:btnState responseObject:dataDic state:str];
        };
    }
    return _alert;
}

//登录过期的通知
- (void)loginFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    QuickLoginViewController *vc = [[QuickLoginViewController alloc]init];
    vc.isMainJump = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//先判断是否是在本界面，不在的话先返回本界面
- (BOOL)backViewController
{
    if ([self.navigationController.topViewController isKindOfClass:[ViewController class]]) {
        return YES;
    } else {
        //        NSArray *vcArray = self.navigationController.viewControllers;
        //        NSLog(@"self.navigationController.viewControllers%@",self.navigationController.viewControllers);
        //        for (ViewController *vc in vcArray) {
        //            if ([vc isKindOfClass:[ViewController class]]) {
        //                NSLog(@"vc%@",vc);
        //                [self.navigationController popToViewController:vc animated:YES];
        //
        //            }
        //        }
        return NO;
    }
}

//播放推送标题
- (void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}

//设置导航栏
- (void)setUpNav
{
    UIButton *navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame = CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"shouye_top_left"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0, 20, 20);
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    messageButton.layer.masksToBounds = YES;
    [messageButton setTitle:@"" forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [messageButton setImage:[UIImage imageNamed:@"shouye_top_right"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:messageButton];

    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    itemSpace.width = 15;

    UIButton *shouye_nav_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shouye_nav_rightButton.frame =  CGRectMake(0, 0, 20, 20);
    [shouye_nav_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shouye_nav_rightButton setImage:[UIImage imageNamed:@"二维码"] forState:(UIControlStateNormal)];
    [shouye_nav_rightButton addTarget:self action:@selector(shouye_nav_rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:shouye_nav_rightButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:BtnItem, itemSpace, rightItem, nil]];
}

- (void)shouye_nav_rightButtonClicked {
    ScanQRcodeViewController *sqVC = [[ScanQRcodeViewController alloc] init];
    [self.navigationController pushViewController:sqVC animated:YES];
}

//导航栏右侧按钮点击事件
- (void)messageButtonClicked
{
    MessageViewController *vc = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//个人中心按钮点击事件
- (void)navBackButtonClicked
{
    AppDelegate *mainAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mainAppDelegate.leftSlider openLeftView];
}

//创建白色背景视图
- (void)creatWhiteBgView
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102)];
    bgWhiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [window addSubview:bgWhiteView];
}

//创建弹出视图
- (void)creatAlertView
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    _orderView = [[CYOrderView alloc] initWithFrame:CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297)];
    [window addSubview:_orderView];
    _orderView.startStr = @"奉化道/大沽南路（路口）晶采大厦";
    _orderView.endStr = @"南开区盈江里路与华宁道交口西侧63中学旁盈江西里小区";
    [CYTSI setStringWith:_orderView.startDistanceLable.text someStr:@"2.3" lable:_orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    [CYTSI setStringWith:_orderView.allDistanceLable.text someStr:@"7.8" lable:_orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    __weak typeof (self) weakSelf = self;
    //关闭抢单弹窗
    _orderView.closeView = ^{
        [weakSelf closeRobOrderView];
    };

    //提示有未完成订单弹窗
    _unEndOrderView = [[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
    _unEndOrderView.isCanHiden = NO;
    [_unEndOrderView setTextFiled:YES];
    [window addSubview:_unEndOrderView];
}

//设置接收推送消息
- (void)setReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        return;
    }
    NSString *driverLocationLo = @"0";
    NSString *driverLocationLa = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
        driverLocationLo = @"0";
        driverLocationLa = @"0";
    } else {
        driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
        driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
    }

    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_DRIVER_ONLINE_STATE params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"state": @"start", @"driver_lng": driverLocationLo, @"driver_lat": driverLocationLa } tost:NO special:1 success:^(id responseObject) {
//        NSLog(@"DRIVER_-------------_ONLINE_STATE%@", responseObject);

        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            self.midleButtonView.buttonState = ALREADY_LISTEN;
            [self.midleButtonView circlAnimation];
            [self setNotification];
            self.stopButton.hidden = NO;
            [self updateDriver];
        } else {
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
    }];
}

//设置不接收推送消息
- (void)setNotReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"receive_noti"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        return;
    }
    NSString *driverLocationLo = @"0";
    NSString *driverLocationLa = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
        driverLocationLo = @"0";
        driverLocationLa = @"0";
    } else {
        driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
        driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
    }

    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_DRIVER_ONLINE_STATE params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"state": @"stop", @"driver_lng": driverLocationLo, @"driver_lat": driverLocationLa } tost:NO special:1 success:^(id responseObject) {
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            if ([self.timer isValid]) {
                [self.timer invalidate];
                _timer = nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark ------ 开始上传司机位置
- (void)updateDriver {
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
//        NSLog(@"推送关闭 8.0");
        UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [myAlertView show];

        [self stopButtonClicked];
        return;
    }
    if ((UIUserNotificationTypeSound & setting.types) == 0) {
        UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请打开：设置→通知→网路出行司机端→允许通知声音开启，否则您将无法听单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [myAlertView show];

        [self stopButtonClicked];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
}

//更新司机首页信息
- (void)updateDriverLocation
{
    NSDictionary *dic1 = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] };
    [AFRequestManager postRequestWithUrl:DRIVER_ONLINE_TIME params:dic1 tost:NO special:1 success:^(id responseObject) {
        [self.headerView.peakHoursBtn setTitle:responseObject[@"data"][@"peak_time"] forState:UIControlStateNormal];
        [self.headerView.todayHoursBtn setTitle:responseObject[@"data"][@"online_time"] forState:UIControlStateNormal];
        [self.headerView.todayMoneyBtn setTitle:responseObject[@"data"][@"driver_fee"] forState:(UIControlStateNormal)];//今日金额
    } failure:^(NSError *error) {
        
    }];
}

- (void)setNotification {
    //接受透传消息的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
    NSDictionary *warningToneDic = @{ @"state": @"yes" };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"warningTone" object:self userInfo:warningToneDic];
}

//创建底部视图
- (void)creatBottomView
{
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.layer.borderWidth = 1;
    bgButton.layer.borderColor = TABLEVIEW_BACKCOLOR.CGColor;
    bgButton.layer.cornerRadius = 51;
    bgButton.layer.masksToBounds = YES;
    [self.view addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@102);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 92 - Bottom_Height, DeviceWidth, 92 + Bottom_Height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 0.8;
    bottomView.layer.borderColor = TABLEVIEW_BACKCOLOR.CGColor;
    [self.view addSubview:bottomView];

    UIButton *frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    frontButton.backgroundColor = [UIColor whiteColor];
    frontButton.layer.cornerRadius = 50.5;
    frontButton.layer.masksToBounds = YES;
    [self.view addSubview:frontButton];
    [frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@101);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    self.midleButtonView = [[CYButtonView alloc]initWithFrame:CGRectMake((DeviceWidth - 92) / 2, DeviceHeight - 103 - Bottom_Height, 92, 92) title:@"开始上班"];
    self.midleButtonView.layer.cornerRadius = 46;
    self.midleButtonView.layer.masksToBounds = YES;
    self.midleButtonView.buttonState = START_LISTEN;
    self.midleButtonView.layer.shadowColor = [UIColor colorWithRed:110 / 255.0 green:109 / 255.0 blue:124 / 255.0 alpha:1].CGColor;//阴影颜色
    self.midleButtonView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
    self.midleButtonView.layer.shadowOpacity = 0.8;//不透明度
    self.midleButtonView.layer.shadowRadius = 5;//半径
    [self.view addSubview:self.midleButtonView];

    __weak typeof (bgWhiteView) weakBgWhiteView = bgWhiteView;
    __weak typeof (self) weakSelf = self;

#pragma mark ---------------按钮点击事件-----------
    self.midleButtonView.buttonBlock = ^(NSInteger state) {
        
        if (state == ROB_ORDER) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"network"] isEqualToString:@"n"]) {
                [CYTSI otherShowTostWithString:@"网络不稳定，请检查网络"];
                return;
            }
            //关闭视图
            weakBgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
            } completion:^(BOOL finished) {
                if (![weakSelf.notiMessage.extras.operate_class isEqualToString:@"new_user_order"]) {
                    if ([weakSelf.notiMessage.extras.appoint_type isEqualToString:@"0"]) {//及时单
                        [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"order_id": weakSelf.notiMessage.extras.order_id, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] } tost:YES special:1 success:^(id responseObject) {
//                            NSLog(@"responseObjectresponseObje123123123%@", responseObject);
                            //抢单成功
                            if ([responseObject[@"flag"] isEqualToString:@"success"]) {
//                                NSLog(@"weakSelf.receipt_face_stateweakSelf.receipt_face_state%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"]);
                                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"] isEqualToString:@"1"]) {
                                    [weakSelf.alert showFaceAlertView:responseObject state:@"order" orderid:@"" btnSate:ROB_ORDER];
                                } else {
                                    [weakSelf robOrderAction:responseObject];
                                }
                                [weakSelf creatHttp];
                                weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
                                [weakSelf.midleButtonView circlAnimation];
                                weakSelf.stopButton.hidden = NO;
                            } else {
                                //抢单失败
                                [weakSelf closeRobOrderView];
                            }
                        } failure:^(NSError *error) {
                        }];
                    } else {//预约单或者接机单
                        [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"order_id": weakSelf.notiMessage.extras.order_id, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] } tost:YES special:1 success:^(id responseObject) {
//                            NSLog(@"responseObjectresponseObject78678678ject%@", responseObject);
                            //抢单成功
                            if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                                weakSelf.successAppointView = [[CYAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
                                weakSelf.successAppointView.titleStr = @"抢单成功";
                                weakSelf.successAppointView.alertStr = @"您已经抢单成功，可到首页订单列表查看";
                                weakSelf.successAppointView.cancleButtonStr = @"";
                                weakSelf.successAppointView.sureButtonStr = @"我知道了";
                                [weakSelf.successAppointView setSingleButton];
                                [weakSelf.successAppointView setTextFiled:YES];
                                [window addSubview:weakSelf.successAppointView];

                                weakSelf.successAppointView.phoneBlock = ^{
                                    //重新加载数据
                                    [weakSelf.successAppointView hideAlertView];
                                    [weakSelf creatHttp];
                                    weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
                                    [weakSelf.midleButtonView circlAnimation];
                                    weakSelf.stopButton.hidden = NO;
                                };
                            } else {
                                //抢单失败
                                [weakSelf closeRobOrderView];
                            }
                        } failure:^(NSError *error) {
                        }];
                    }
                } else {
                    //一口价订单抢单
//                    NSLog(@"一口价订单抢单");
                    NSDictionary *dic = [NSDictionary dictionary];
                    dic = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": weakSelf.notiMessage.extras.order_id };
                    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_GRAB_ORDER params:dic tost:YES special:1 success:^(id responseObject) {
                        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                            ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
                            vc.state = @"driver";
                            vc.isCanListen = YES;
                            vc.getDateBlock = ^{
                                [weakSelf refreshUp];
                            };
                            vc.travelID = responseObject[@"data"][@"travel_id"];
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                            [weakSelf creatHttp];
                            weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
                            [weakSelf.midleButtonView circlAnimation];
                            weakSelf.stopButton.hidden = NO;
//                            NSLog(@"closeRobOrderView123123123");
                        } else {
//                            NSLog(@"closeRobOrderView");
                            [weakSelf closeRobOrderView];
                        }
                    } failure:^(NSError *error) {
//                        NSLog(@"closeRobOrderView1231223");
                    }];
                }
            }];
        }
        if (state == ALREADY_LISTEN) {//开始订单按钮点击后接受推送
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"listen_face_state"] isEqualToString:@"1"]) {//已认证页面，扫脸开始工作
                if ([weakSelf.driver_face_state isEqualToString:@"1"]) {
                    
                    weakSelf.midleButtonView.buttonState = START_LISTEN;
                    [weakSelf.alert showFaceAlertView:@{} state:@"order" orderid:@"" btnSate:START_LISTEN];
                } else {//去认证页面
                    weakSelf.midleButtonView.buttonState = START_LISTEN;
                    FaceViewController *vc = [[FaceViewController alloc] init];
                    vc.face_number = [weakSelf.face_number integerValue];
                    vc.driver_face_state = weakSelf.driver_face_state;
                    vc.reloadDataBlock = ^{
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            } else {
//                NSLog(@"开始听单计时");

                [weakSelf setReceiveNoti];
            }
        }
    };

    //抢单倒计时结束后的操作
    self.midleButtonView.overTime = ^{
        [weakSelf closeRobOrderView];
    };

    _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stopButton setImage:[UIImage imageNamed:@"stop_order_button"] forState:UIControlStateNormal];
    [_stopButton setTitle:@"收车下班" forState:UIControlStateNormal];
    [_stopButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _stopButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _stopButton.hidden = YES;
    [self setButtonSpace:_stopButton buttonTitle:@"收车下班"];
    [_stopButton addTarget:self action:@selector(stopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopButton];
    [_stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DeviceHeight - 88 - Bottom_Height);
        make.left.equalTo(self.view.mas_centerX).offset(76);
        make.width.and.height.equalTo(@60);
    }];

    self.tuisongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tuisongBtn setImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.tuisongBtn setTitle:@"推送记录" forState:UIControlStateNormal];
    [self.tuisongBtn setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.tuisongBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self setButtonSpace:self.tuisongBtn buttonTitle:@"推送记录"];
    [self.tuisongBtn addTarget:self action:@selector(tuisongBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tuisongBtn];
    [self.tuisongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DeviceHeight - 88 - Bottom_Height);
        make.right.equalTo(self.view.mas_centerX).offset(-76);
        make.width.and.height.equalTo(@60);
    }];
}

- (void)tuisongBtnClicked {
    if (self.midleButtonView.buttonState == ALREADY_LISTEN  ||  self.midleButtonView.buttonState == ROB_ORDER   || self.midleButtonView.buttonState == UNFINISHORDER) {
        [self closeRobOrderView];
    }
    TuiSongListViewController *vc = [[TuiSongListViewController alloc] init];
    vc.face_number = self.face_number;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 扫脸认证
- (void)scanFaceAction:(NSInteger)state responseObject:(NSDictionary *)dic state:(NSString *)stateStr {
    if ([[FaceSDKManager sharedInstance] canWork]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络并重启APP" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
//            NSLog(@"点击取消");
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//            NSLog(@"点击确认");
            exit(1);
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        LivenessViewController *lvc = [[LivenessViewController alloc] init];
        lvc.isFount = YES;
        lvc.liveBlock = ^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //初始化进度框，置于当前的View当中
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];

                [window addSubview:HUD];

                HUD.bezelView.backgroundColor = [UIColor blackColor];
                HUD.bezelView.alpha = 1;
                HUD.label.textColor = [UIColor whiteColor];
                HUD.activityIndicatorColor = [UIColor whiteColor];
                //如果设置此属性则当前的view置于后台
                HUD.dimBackground = YES;
                //设置对话框文字
                HUD.labelText = @"请稍等";
                [HUD showAnimated:YES];
                NSString *urlString;
                if ([stateStr isEqualToString:@"order"]) {
                    urlString = [NSString stringWithFormat:@"%@%@", HTTP_URL, DRIVER_FACE_MATCH];
                } else {
                    urlString = [NSString stringWithFormat:@"%@%@", HTTP_URL, DRIVER_BAIDUAIP_DRIVER_FACE_AUTH];
                }

                //1.创建管理者对象
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *dict;
                if ([stateStr isEqualToString:@"order"]) {
                    if (state == START_LISTEN) {
                        dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] };
                    } else if (state == ROB_ORDER) {
                        dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": self.notiMessage.extras.order_id };
                    } else if (state == UNFINISHORDER) {
                        OrdeModel *theOrder = dic[@"model"];
                        dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"order_id": theOrder.order_id };
                    }
                } else {
                    dict = @{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] };
                }
                // NSLog(@"=======%@",dict);
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];

                [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSString *dateString = [CYTSI getDateStr];
                    NSString *dateStr = [NSString stringWithFormat:@"%@face_img.png", dateString];
//                    NSLog(@"dateStr%@", dateStr);
                    [CYTSI saveImage:[UIImage fixOrientation:[CYTSI compressImageQuality:image toByte:1024 * 1024] ] withName:dateStr];

                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"face_img" fileName:dateStr mimeType:@"image/png" error:nil];
                } progress:^(NSProgress *_Nonnull uploadProgress) {
                    //打印下上传进度
                    CYLog(@"上传进度=========%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                    //请求成功
                    CYLog(@"请求成功：%@", responseObject);
                    CYLog(@"提示信息：%@", [responseObject objectForKey:@"message"]);
                    CYLog(@"请求地址:%@", urlString);
                    CYLog(@"请求参数:%@", dict);
                    if ([responseObject[@"flag"] isEqualToString:@"error"]) {
                    }
                    [HUD removeFromSuperview];
                    if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                        if ([responseObject[@"message"] isEqualToString:@"认证成功"]) {
                            if ([stateStr isEqualToString:@"order"]) {
                                if (state == START_LISTEN) {
                                    //开始听单动画
                                    [self alreadyListenAction];
                                } else if (state == ROB_ORDER) {
                                    [self robOrderAction:dic];
                                } else if (state == UNFINISHORDER) {
                                    [self unfinishOrder:dic];
                                }
                            } else {
                            }
                            [self.alert cancelAction];
                            [CYTSI otherShowTostWithString:responseObject[@"message"]];
                        } else {
                            [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                        }
                    } else {
//                        NSLog(@"self.alertself.alertself.alert%@", self.alert);
                        [HUD removeFromSuperview];
                        [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    }
                } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                    //请求失败
                    [HUD removeFromSuperview];
                    CYLog(@"请求失败：%@", error);
                    CYLog(@"请求地址:%@", urlString);
                    CYLog(@"请求参数:%@", dict);
                }];
            });
        };
        

        [lvc livenesswithList:@[] order:0  numberOfLiveness:[self.face_number integerValue]];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
        navi.navigationBarHidden = true;
        [self presentViewController:navi animated:YES completion:nil];
    }
}

//开始听单
- (void)alreadyListenAction {
//    self.midleButtonView.buttonState=ALREADY_LISTEN;
//    [self.midleButtonView circlAnimation];

    [self setReceiveNoti];
//    self.stopButton.hidden=NO;
//    [self setNotification];
    [self.alert hidenFaceAlertView];
}

//抢单成功
- (void)robOrderAction:(NSDictionary *)dic {
    OrdeModel *qiangOrder = [OrdeModel mj_objectWithKeyValues:dic[@"data"]];
    [CYTSI otherShowTostWithString:@"抢单成功，快去接驾吧~"];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    self.stopButton.hidden = YES;

    RobSuccessViewController *vc = [[RobSuccessViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.AlreadyListenBlock = ^{
        weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"orderState"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
    };
    vc.orderID = weakSelf.notiMessage.extras.order_id;
    vc.endCoordinate = CLLocationCoordinate2DMake(qiangOrder.end_lat, qiangOrder.end_lng);
    vc.endAddress = qiangOrder.end_address;
    vc.endName = qiangOrder.end_name;
    vc.userStartCoordinate = CLLocationCoordinate2DMake(qiangOrder.start_lat, qiangOrder.start_lng);
    vc.userStartAddress = qiangOrder.start_address;
    vc.userStartname = qiangOrder.start_name;
    vc.m_card_number = qiangOrder.m_card_number;
    vc.userName = qiangOrder.passenger_name;
    vc.userPhone = qiangOrder.passenger_phone;
    vc.flight_date = qiangOrder.appoint_time;
    vc.m_header = qiangOrder.m_head;
    vc.appoint_time = qiangOrder.appoint_time;
    vc.remarkStr = qiangOrder.remark;
    vc.journey_fee = weakSelf.notiMessage.extras.journey_fee;
    vc.submit_class = qiangOrder.submit_class;
    vc.order_class = weakSelf.driver_class;

    [[NSUserDefaults standardUserDefaults] setObject:self.notiMessage.extras.order_id forKey:@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
    [self.alert hidenFaceAlertView];
}

//行程中的订单扫脸
- (void)unfinishOrder:(NSDictionary *)dic {
    OrdeModel *theOrder = dic[@"model"];
    RobSuccessViewController *vc = [[RobSuccessViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.AlreadyListenBlock = ^{
        weakSelf.midleButtonView.buttonState = ALREADY_LISTEN;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"orderState"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouChuan:) name:@"touchuan" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
    };
    [[NSUserDefaults standardUserDefaults] setObject:theOrder.order_id forKey:@"order_id"];
    vc.orderID = theOrder.order_id;
    vc.endCoordinate = CLLocationCoordinate2DMake(theOrder.end_lat, theOrder.end_lng);
    vc.endAddress = theOrder.end_address;
    vc.endName = theOrder.end_name;
    vc.userStartCoordinate = CLLocationCoordinate2DMake(theOrder.start_lat, theOrder.start_lng);
    vc.userStartAddress = theOrder.start_address;
    vc.userStartname = theOrder.start_name;
    vc.userName = theOrder.passenger_name;
    vc.userPhone = theOrder.passenger_phone;
    vc.flight_date = theOrder.appoint_time;
    vc.m_card_number = theOrder.m_card_number;
    vc.m_header = theOrder.m_head;
    vc.appoint_time = theOrder.appoint_time;
    vc.remarkStr = theOrder.remark;
    vc.journey_fee = theOrder.journey_fee;
    vc.order_class = theOrder.order_class;
    vc.submit_class = theOrder.submit_class;

    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)theOrder.journey_state], @"orderState", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];

    vc.appoint_type = theOrder.appoint_type;
    vc.flight_number = theOrder.flight_number;
    vc.orderState = theOrder.journey_state;
    vc.isOrderList = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//关闭抢单弹窗
- (void)closeRobOrderView
{
    //关闭视图
    bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
    [UIView animateWithDuration:0.3 animations:^{
        _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
    }];
    [self.midleButtonView failedAfter];//继续听单
    _stopButton.hidden = NO;
}

//停止接单按钮点击事件
- (void)stopButtonClicked
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;

    [AFRequestManager postRequestWithUrl:DRIVER_BASE_DATA params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"p": @"1" } tost:YES special:0 success:^(id responseObject) {
        [ShouYeModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"unfinished_order": @"OrdeModel" };
        }];
        ShouYeModel *shouYe = [ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];

        if (shouYe.unfinished_order.count <= 0 && [currentPage isEqualToString:@"1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认收车下班" message:@"收车下班后将不会收到新的订单并不计数在线时长" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [weakSelf stop:@"q"];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            OrdeModel *theOrder = shouYe.unfinished_order[0];
            if (theOrder.journey_state == 4 || theOrder.journey_state == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认收车下班" message:@"收车下班后将不会收到新的订单并不计数在线时长" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [weakSelf stop:@"q"];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [CYTSI otherShowTostWithString:@"您有未完成的订单，暂时不能下班"];
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)stopListen
{
    [self stop:@"q"];
    //下班状态
 
    if ([self.timer isValid]) {
        [self.timer invalidate];
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
}

- (void)stop:(NSString *)state {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        _stopButton.hidden = YES;
        if (![state isEqualToString:@"overtime"]) {
        //停止语音
            [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
        }

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
        [self.midleButtonView stropCirclAnimation];
        //关闭视图
        bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
        [UIView animateWithDuration:0.3 animations:^{
            _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
        }];
        return;
    }
    NSString *driverLocationLo = @"0";
    NSString *driverLocationLa = @"0";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
        driverLocationLo = @"0";
        driverLocationLa = @"0";
    } else {
        driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
        driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
    }
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_DRIVER_ONLINE_STATE params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"state": @"stop", @"driver_lng": driverLocationLo, @"driver_lat": driverLocationLa } tost:YES special:1 success:^(id responseObject) {
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            
           
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"receive_noti"];
            _stopButton.hidden = YES;
            if (![state isEqualToString:@"overtime"]) {
            //停止语音
                [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
            }
            //            [self setNotReceiveNoti];//不接收推送
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"touchuan" object:nil];
            [self.midleButtonView stropCirclAnimation];
            //关闭视图
            bgWhiteView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 102);
            [UIView animateWithDuration:0.3 animations:^{
                _orderView.frame = CGRectMake(20, DeviceHeight, DeviceWidth - 40, 297);
            }];
            if ([self.timer isValid]) {
                [self.timer invalidate];
                _timer = nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
        } else if ([responseObject[@"message"] isEqualToString:@"您还有订单未完成"]) {
            [CYTSI otherShowTostWithString:@"您有未完成的订单，暂时不能下班"];
        }
    } failure:^(NSError *error) {
    }];
}

//创建主要视图
- (void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 92 - Bottom_Height) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[ITShouYeTableViewCell class] forCellReuseIdentifier:@"ITShouYeTableViewCell"];
    [myTableView registerClass:[ITAddTravelTableViewCell class] forCellReuseIdentifier:@"ITAddTravelTableViewCell"];

    //添加下拉刷新及上拉加载
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    myTableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 34 : 0;  
    myTableView.tableHeaderView = self.headerView;
}

#pragma mark - 表的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {//普通订单
        return nowOrderArray.count;
    } else if (section == 1) {//一口价订单
        return completeOrderArray.count + 1;
    }else if (section == 2) {//校园拼订单
        return self.schoolArray.count;
    }else{//通行勤订单
        return self.workArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    } else if (section == 1) {
        if (completeOrderArray.count == 0) {//没有数据
            return 100;
        } else {
            return 50;
        }
    } else if (section == 2){
        if (self.schoolArray.count == 0) {//没有数据
            return 100;
        } else {
            return 50;
        }
    }else{
        if (self.workArray.count == 0) {//没有数据
            return 100;
        } else {
            return 50;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (nowOrderArray.count ==  0) {
            return 80;
        } else {
            return 10;
        }
    } else if (section == 1) {
        return 10;
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    } else if (indexPath.section == 1) {
        if (completeOrderArray.count == 0 || indexPath.row == completeOrderArray.count) {
            return 90;
        } else {
            return 225;
        }
    } else if (indexPath.section == 2){
        if (self.schoolArray.count == 0) {
            return 90;
        } else {
            return 100;
        }
    }else{
       if (self.schoolArray.count == 0) {
            return 90;
        } else {
            return 100;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   //背景的View
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    //更多的bTN
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(DeviceWidth - 62, 8, 50, 24);
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    btn.layer.cornerRadius = 12;
    btn.layer.shadowColor = [UIColor colorWithRed:110 / 255.0 green:109 / 255.0 blue:124 / 255.0 alpha:1].CGColor;//阴影颜色
    btn.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
    btn.layer.shadowOpacity = 0.4;//不透明度
    btn.layer.shadowRadius = 2;//半径
    [btn setTitle:@"更多" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:btn];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 120, 20)];
    label.textColor = [CYTSI colorWithHexString:@"#2488ef"];
    label.font = [UIFont systemFontOfSize:15];
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, DeviceWidth, 1)];
    smallView.backgroundColor = TABLEVIEW_BACKCOLOR;

    //设置显示的内容
    UILabel *noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, DeviceWidth, 35)];
    noDatalabel.textColor = [UIColor lightGrayColor];
    noDatalabel.textAlignment = NSTextAlignmentCenter;
    noDatalabel.font = [UIFont systemFontOfSize:15];
    noDatalabel.text = @"暂无订单";

    if (section == 0) {
        label.text = @"普通订单";
        [btn addTarget:self action:@selector(putongAction) forControlEvents:(UIControlEventTouchUpInside)];
    } else if (section == 1) {
        label.text = @"一口价订单";
        [btn addTarget:self action:@selector(yikojiaAction) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:noDatalabel];
        [bgView addSubview:smallView];
        if (completeOrderArray.count == 0) {//没有数据的时候显示
            noDatalabel.hidden = NO;
            smallView.hidden = NO;
        } else {//有数据的时候不显示
            noDatalabel.hidden = YES;
            smallView.hidden = YES;
        }
    } else if (section == 2){
        label.text = @"校园拼订单";
        self.whichType = @"0";
        [btn addTarget:self action:@selector(schoolAction) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:noDatalabel];
        [bgView addSubview:smallView];
        if (self.schoolArray.count == 0) {       //没有数据的时候显示
            noDatalabel.hidden = NO;

        } else {     //有数据的时候不显示
            noDatalabel.hidden = YES;
           
        }
    }else{
       label.text = @"通勤行订单";
        self.whichType = @"1";
        [btn addTarget:self action:@selector(schoolAction) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:noDatalabel];
        [bgView addSubview:smallView];
        if (self.workArray.count == 0) {       //没有数据的时候显示
            noDatalabel.hidden = NO;

        } else {     //有数据的时候不显示
            noDatalabel.hidden = YES;
           
        }
    }
    [bgView addSubview:label];

    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    //设置背景View
    bgView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //设置横线view
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, DeviceWidth, 70)];
    smallView.backgroundColor = [UIColor whiteColor];
    //设置显示的内容
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, DeviceWidth, 35)];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"暂无订单";
    //暂无数据的添加
    if (section == 0) {
        [bgView addSubview:smallView];
        [smallView addSubview:label];
        if (nowOrderArray.count ==  0) {
            label.hidden = NO;
            smallView.hidden = NO;
        } else {
            label.hidden = YES;
            smallView.hidden = YES;
        }
    }
    return bgView;
}

- (void)putongAction {
    NewTripViewController *vc = [[NewTripViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)yikojiaAction {
    NewTripViewController *vc = [[NewTripViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)schoolAction {
    SLTripListViewController *vc = [[SLTripListViewController alloc] init];
    vc.whichType = self.whichType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && nowOrderArray.count != 0) {
        TripOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"triponecell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TripOneTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        OrdeModel *order = [OrdeModel mj_objectWithKeyValues:nowOrderArray[indexPath.row]];
        cell.startLable.text = order.start_address;
        if ([order.end_address isEqualToString:@""]) {
            cell.endLable.text = @"目的地待与乘客确认";
        } else {
            cell.endLable.text = order.end_address;
        }

        cell.stateLB.text = order.state_name;
        cell.timeLb.text = order.ctime;
        cell.typeLB.text = order.order_type;

        return cell;
    } else if (indexPath.section == 1) {
        if (completeOrderArray.count == 0 || indexPath.row == completeOrderArray.count) {
            ITAddTravelTableViewCell *ITShouYecell = [myTableView dequeueReusableCellWithIdentifier:@"ITAddTravelTableViewCell" forIndexPath:indexPath];
            [ITShouYecell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return ITShouYecell;
        } else {
            ITShouYeTableViewCell *ITShouYecell = [myTableView dequeueReusableCellWithIdentifier:@"ITShouYeTableViewCell" forIndexPath:indexPath];
            [ITShouYecell setSelectionStyle:UITableViewCellSelectionStyleNone];
            ITShouYecell.state = completeOrderArray[indexPath.row][@"state"];
            [ITShouYecell setDataDic:completeOrderArray[indexPath.row]];
            return ITShouYecell;
        }
    } else if (indexPath.section == 2){
        SchoolViewCell *schoolCell = [tableView dequeueReusableCellWithIdentifier:@"SchoolViewCell"];
        if (!schoolCell) {
            schoolCell = [[SchoolViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SchoolViewCell"];
        }
        [schoolCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        schoolCell.tripList = self.schoolArray[indexPath.row];
        return schoolCell;
    }else{
        SchoolViewCell *schoolCell = [tableView dequeueReusableCellWithIdentifier:@"SchoolViewCell"];
        if (!schoolCell) {
            schoolCell = [[SchoolViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SchoolViewCell"];
        }
        [schoolCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        schoolCell.tripList = self.workArray[indexPath.row];
        return schoolCell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && nowOrderArray.count != 0) {
        OrdeModel *order = [OrdeModel mj_objectWithKeyValues:nowOrderArray[indexPath.row]];
        if ([order.appoint_type isEqualToString:@"0"]) {
            [self unfinishOrder:@{ @"model": order }];
        } else {
            AppointAirListViewController *vc = [[AppointAirListViewController alloc]init];
            vc.AlreadyListenBlock = ^{
            };
            vc.orderID = order.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (completeOrderArray.count == 0 || indexPath.row == completeOrderArray.count) {
            if (self.midleButtonView.isCanListen == NO) {
                [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能听单"];
                return;
            }
            PbulishLineView *publishView = [[PbulishLineView alloc] initWithFrame:self.view.bounds];
            [publishView showView];
            
            __weak typeof(self) weakSelf = self;
            publishView.lineOneBlock = ^{
               
                SelectPathViewController *vc = [[SelectPathViewController alloc] init];
                vc.start_province = weakSelf.start_province;
                vc.start_city = weakSelf.start_city;
                vc.start_county = weakSelf.start_county;
                vc.getMainData = ^{
                    [weakSelf refreshUp];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            publishView.lineTwoBlick = ^{
                CustomizeViewController *vc = [[CustomizeViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
        } else {
            [self pushITTripDetailVC:completeOrderArray[indexPath.row][@"travel_id"] date:completeOrderArray[indexPath.row][@"travel_date"] time:completeOrderArray[indexPath.row][@"travel_time"]];
        }
    } else if(indexPath.section == 2){//校园拼
       
        SLTripList *detial = self.schoolArray[indexPath.row];
         if ([detial.travel_type isEqualToString:@"0"]) {//上学
             SLTripDetialViewController *detialVC = [[SLTripDetialViewController alloc] init];
                detialVC.route_id = self.schoolArray[indexPath.row].route_id;
                [self.navigationController pushViewController:detialVC animated:YES];
         }else{//下学
             AfterSchoolTripDetialViewController *detialVC = [[AfterSchoolTripDetialViewController alloc] init];
                detialVC.route_id = self.schoolArray[indexPath.row].route_id;
                [self.navigationController pushViewController:detialVC animated:YES];
         }
        
    }else if(indexPath.section == 3){//通勤行
       
        SLTripList *detial = self.workArray[indexPath.row];
         if ([detial.travel_type isEqualToString:@"0"]) {//上班
             GotoWorkViewController *detialVC = [[GotoWorkViewController alloc] init];
                detialVC.route_id = self.workArray[indexPath.row].route_id;
                [self.navigationController pushViewController:detialVC animated:YES];
         }else{//下班
             AfterWorkViewController *detialVC = [[AfterWorkViewController alloc] init];
                detialVC.route_id = self.workArray[indexPath.row].route_id;
                [self.navigationController pushViewController:detialVC animated:YES];
         }
        
    }
}

- (void)pushITTripDetailVC:(NSString *)travelID date:(NSString *)date time:(NSString *)time {
    __weak typeof(self) weakSelf = self;
    ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
    vc.state = @"driver";
    vc.isCanListen = self.midleButtonView.isCanListen;
    vc.getDateBlock = ^{
        [weakSelf refreshUp];
    };
    vc.travelID = travelID;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置button的文字图片间距
- (void)setButtonSpace:(UIButton *)button buttonTitle:(NSString *)title
{
    CGFloat buttonWidth = 60;//按钮的宽度
    CGFloat textWidth = [CYTSI planRectWidth:title font:11];//按钮上的文字宽度
    CGFloat imageTopGap = 1;//图片距上部距离
    CGFloat textTopGap = 5;//文字距离图片的距离

    //CGFloat buttonImageWidth=button.imageView.frame.size.width;
    //if (buttonImageWidth>50) {
    CGFloat buttonImageWidth = buttonImageWidth = 55;
    //}

    [button setTitleEdgeInsets:UIEdgeInsetsMake((buttonImageWidth + imageTopGap) + textTopGap, (buttonWidth - textWidth) / 2 - buttonImageWidth, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageTopGap, (buttonWidth - buttonImageWidth) / 2, 0, 0)];

    //[button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0 )];
}

#pragma mark - 地图相关
//设置地图
- (void)setUpMap
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
}

//开始定位
- (void)startLocation
{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
        //  NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);

            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        //  NSLog(@"location:%@-----%f", location,[location.timestamp timeIntervalSince1970]);
        // NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]);
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);

            self.startAddress = regeocode.formattedAddress;
            if (regeocode.city  == nil) {
                self.start_province = @"天津市";
                self.start_city = @"天津市";
                self.start_county = @"不限";
            } else {
                self.start_province = regeocode.province;
                self.start_city = regeocode.city;
                self.start_county = @"不限";
                [[NSUserDefaults standardUserDefaults] setObject:regeocode.city forKey:@"current_city"];
            }
        }
    }];
}

- (shouYeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [shouYeHeaderView createView];
        __weak typeof(self) weakSelf = self;
        _headerView.peakHoursBlock = ^(NSString *state) {
            PeakAndTodayHoursViewController *vc = [[PeakAndTodayHoursViewController alloc] init];
            vc.state = state;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _headerView.todayHoursBlock = ^(NSString *state) {
            PeakAndTodayHoursViewController *vc = [[PeakAndTodayHoursViewController alloc] init];
            vc.state = state;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }

    return _headerView;
}

@end
