//
//  ViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ScanCarViewController.h"
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
#import "AFNetworking.h"

#import <AudioToolbox/AudioToolbox.h>//调用系统提示音头文件
#import <sys/utsname.h>
#import "ScanTripDetailViewController.h"
#import "ScanCarModel.h"

#import "SpeechSynthesizer.h"
#import "UpdateAlertView.h"

static SystemSoundID push = 0;
#import "ScanTripTableViewCell.h"
#import "ScanQRcodeViewController.h"
@interface ScanCarViewController () <UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>

{
    UITableView * myTableView;
    UIButton * stopButton;//停止听单按钮
    CYButtonView * midleButtonView;//中间听单视图
    UIView * bgWhiteView;//白色背景视图
    NSString * currentPage;//当前分页数
    
    UIImageView * headImageView;
    UILabel * nickNameLable;
    CYStarView * starView;
    CYLableView * midelView;
    CYLableView * leftView;
    CYLableView * rightView;

    
    NSMutableArray * nowOrderArray;//进行中的订单

    NotiMessageModel * notiMessage;//透传接收的新订单推送消息
    BOOL isFirstJoin;//是否是第一次进程序
    
//    NSInteger driver_class;//司机类型 1：快车司机 2：出租车司机
}

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSString * startAddress;//开始位置
@property (nonatomic ,strong) NSTimer * timer;
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单
//@property(nonatomic,assign)BOOL  isChange;//是否改变订单弹窗位置

@end

@implementation ScanCarViewController

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
    
    if (midleButtonView.buttonState==ALREADY_LISTEN) {
        
        stopButton.hidden=NO;
        [midleButtonView circlAnimation];//听单动画
        [self setReceiveNoti];
        
    }else{
        
        stopButton.hidden=YES;
        [self setNotReceiveNoti];
    }
    
    if (_isNeedReload) {
        [self refreshDown];//刷新数据
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate * mainAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
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
     nowOrderArray = [NSMutableArray array];
    self.title=@"网路出行";
    isFirstJoin=YES;
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"loginfailed" object:nil];//登录过期
    
    //接受透传消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTouChuan:) name:@"touchuan" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiangqing) name:@"SCANVC_xiangqing" object:nil];


    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self creatWhiteBgView];//创建白色背景视图
    [self creatBottomView];//创建底部视图
  
    [self setUpMap];//设置地图
//    [self refreshDown];//请求司机信息
    [self setNotReceiveNoti];//刚进来设置默认不接单
    
    [self reachability];//监控网络状态
    [self startLocation];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"jpushMessage"] isEqualToString:@"xiangqing"]) {
        [self xiangqing];
    }
    
    //检查软件是否需要更新
    [self checkForUpdate];
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
-(void)xiangqing{
    MessageViewController *min = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:min animated:YES];
}


//接收到透传消息
-(void)receiveTouChuan:(NSNotification *)noti
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"3"]) {
    NotiMessageModel * theNotiMessageModel=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
//    NSLog(@"oooooooooooooooooooooooooooooooooooooooooooooooooooooooooo%@",noti.userInfo);
    //乘客已付款
    if ([theNotiMessageModel.extras.operate_class isEqualToString:@"passenger_payment"]) {
        
        //[self playVideo:theNotiMessageModel.content];//播放推送标题
        [self refreshDown];//更新订单状态
//        NSLog(@"网路出行收款%@元",theNotiMessageModel.extras.journey_fee);
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"3"]) {//扫码车进入
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:[NSString stringWithFormat:@"网路出行收款%@元",theNotiMessageModel.extras.journey_fee]];
//        }else{
//        AddBankCardSuccessViewController * vc=[[AddBankCardSuccessViewController alloc]init];
//        vc.isOrder=YES;
//        vc.payMoney=theNotiMessageModel.extras.journey_fee;
//        vc.orderId=theNotiMessageModel.extras.order_id;
//        [self.navigationController pushViewController:vc animated:YES];
//
    }
    }

}



//更新司机位置
-(void)updateDriverLocation
{
    [self startLocation];//开始定位
}

//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [nowOrderArray removeAllObjects];
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
//    NSLog(@"driver_id == %@ token = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
    [AFRequestManager postRequestWithUrl:DRIVER_QRCODE_DRIVER_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage} tost:YES special:0 success:^(id responseObject) {

//            NSLog(@"responseObject ---------------%@",responseObject);
//            [ShouYeModel mj_setupObjectClassInArray:^NSDictionary *{
//
//                return @{@"unfinished_order":@"OrdeModel"};
//
//            }];
//
//            [CompleteOrderModel mj_setupObjectClassInArray:^NSDictionary *{
//
//                return @{@"list":@"OrdeModel"};
//
//            }];
        
            ShouYeModel * shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        
 
        [nowOrderArray addObjectsFromArray:shouYe.journey_list];
        if (shouYe.audit_state==2) {//可以听单
            self.isCanListen=YES;
        } else {
            self.isCanListen=NO;
        }
        shouYe.driver_class = 3;
//            NSLog(@"nowOrderArray%@",nowOrderArray);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_message" object:self userInfo:@{@"message":shouYe}];
            isFirstJoin=NO;
            [[NSUserDefaults standardUserDefaults] setObject:shouYe.invite_code forKey:@"invite_code"];
        
            [headImageView sd_setImageWithURL:[NSURL URLWithString:shouYe.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
            nickNameLable.text=shouYe.driver_name;
            int height=[CYTSI planRectWidth:nickNameLable.text font:14];
            [nickNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(height);
            }];
            [starView setViewWithNumber:shouYe.appraise_stars width:14 space:2 enable:NO];
            midelView.bottomLable.text=shouYe.today_count;
           leftView.bottomLable.text= [NSString stringWithFormat:@"%ld",(long)shouYe.cumulate_count];
           rightView.bottomLable.text= shouYe.today_fee;
            [myTableView reloadData];
            [myTableView.mj_header endRefreshing];
            if ([currentPage intValue]>[shouYe.total_page intValue]) {
                [myTableView .mj_footer endRefreshingWithNoMoreData];
            }else{
                [myTableView.mj_footer endRefreshing];
            }
        [myTableView reloadData];
        
    } failure:^(NSError *error) {
//        NSLog(@"error ============ %@",error);
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
    }];
}

//登录过期的通知
-(void)loginFailed
{
    QuickLoginViewController * vc=[[QuickLoginViewController alloc]init];
    vc.isMainJump=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//先判断是否是在本界面，不在的话先返回本界面
- (void)backViewController
{
    if ([self.navigationController.topViewController isKindOfClass:[ScanCarViewController class]]) {
        
        
    }else{
        
        NSArray *vcArray = self.navigationController.viewControllers;
        for (ScanCarViewController *vc in vcArray) {
            
            if ([vc isKindOfClass:[ScanCarViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
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
    self.navigationItem.rightBarButtonItem=rightItem;
    
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


//设置接收推送消息
-(void)setReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"receive_noti"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    
//    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_DRIVER_ONLINE_STATE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"state":@"start"} tost:NO special:1 success:^(id responseObject) {
//
        if ([self.timer isValid]) {
            [self.timer invalidate];
            _timer = nil;
        }
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        
        
//    } failure:^(NSError *error) {
//
//    }];
}

//设置不接收推送消息
-(void)setNotReceiveNoti
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"receive_noti"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    
//    [AFRequestManager postRequestWithUrl:DRIVER_DRIVER_DRIVER_ONLINE_STATE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"state":@"stop"} tost:NO special:1 success:^(id responseObject) {
//
//        if ([self.timer isValid]) {
//            [self.timer invalidate];
//            _timer = nil;
//        }
//        //        self.timer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
//        //        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//        //
//
//    } failure:^(NSError *error) {
//
//    }];
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
    
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-92, DeviceWidth, 92)];
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
    
    CALayer * layer=[[CALayer alloc]init];
    layer.frame=CGRectMake((DeviceWidth-93)/2, DeviceHeight-103, 93, 93);
    layer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    layer.cornerRadius=46.5;
    layer.masksToBounds=YES;
    [self.view.layer addSublayer:layer];
    
    
    midleButtonView=[[CYButtonView alloc]initWithFrame:CGRectMake((DeviceWidth-92)/2, DeviceHeight-103, 92, 92) title:@"收款码"];
    midleButtonView.layer.cornerRadius=46;
    midleButtonView.layer.masksToBounds=YES;
    midleButtonView.buttonState=SCAN_CLIKCK;
    [self.view addSubview:midleButtonView];
    
    
    __weak typeof (bgWhiteView) weakBgWhiteView = bgWhiteView;
    __weak typeof (self) weakSelf = self;
    
    //按钮点击事件
    midleButtonView.buttonBlock = ^(NSInteger state) {
        if (weakSelf.isCanListen) {
            switch (state) {
                case 5:
                {
                    ScanQRcodeViewController *sqVC = [[ScanQRcodeViewController alloc] init];
                    [weakSelf.navigationController pushViewController:sqVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能收款"];
            return;
        } 
    };
    
   
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
    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 224)];
    headerView.backgroundColor=[UIColor whiteColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake((DeviceWidth-81)/2, 25, 81, 81);
    layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    layer.shadowOpacity=0.3;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.cornerRadius=40.5;
    [headerView.layer addSublayer:layer];
    
    
    headImageView=[[UIImageView alloc]init];
    headImageView.layer.cornerRadius=41;
    headImageView.layer.masksToBounds=YES;
//    headImageView.layer.borderColor=[UIColor whiteColor].CGColor;
//    headImageView.layer.borderWidth=5;
    [headerView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.and.height.equalTo(@82);
        make.top.equalTo(@25);
    }];
    // 833275f659a7b3f0c7e5d3ab356ca93e
    
    nickNameLable=[[UILabel alloc]init];
    nickNameLable.text=@"";
    nickNameLable.textColor=[CYTSI colorWithHexString:@"#666666"];
    nickNameLable.font=[UIFont systemFontOfSize:14];
    nickNameLable.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:nickNameLable];
    [nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        make.top.equalTo(headImageView.mas_bottom).with.offset(11);
    }];
    
    UIView * leftLineView=[[UIView alloc]init];
    leftLineView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNameLable.mas_centerY);
        make.height.equalTo(@0.5);
        make.width.equalTo(@62);
        make.right.equalTo(nickNameLable.mas_left).with.offset(-3);
    }];
    
    UIView * rightLineView=[[UIView alloc]init];
    rightLineView.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nickNameLable.mas_centerY);
        make.height.equalTo(@0.5);
        make.width.equalTo(@62);
        make.left.equalTo(nickNameLable.mas_right).with.offset(3);
    }];
    
    starView=[[CYStarView alloc]init];
    [starView setViewWithNumber:0 width:14 space:2 enable:NO];
    [headerView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.equalTo(@14);
        make.width.equalTo(@78);
        make.top.equalTo(nickNameLable.mas_bottom).with.offset(5);
    }];
    
    midelView=[[CYLableView alloc]init];
    midelView.backgroundColor=[UIColor whiteColor];
    midelView.topLable.text=@"今日订单数";
    midelView.bottomLable.text=@"...";
    [headerView addSubview:midelView];
    [midelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
        make.top.equalTo(starView.mas_bottom).with.offset(8);
    }];
    
    leftView=[[CYLableView alloc]init];
    leftView.backgroundColor=[UIColor whiteColor];
    leftView.topLable.text=@"总订单数";
    leftView.bottomLable.text=@"...";
    [headerView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midelView.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(@0);
        make.right.equalTo(midelView.mas_left);
    }];
    
    rightView=[[CYLableView alloc]init];
    rightView.backgroundColor=[UIColor whiteColor];
    rightView.topLable.text=@"今日收入";
    rightView.bottomLable.text=@"...";
    [headerView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midelView.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(midelView.mas_right);
        make.right.equalTo(headerView.mas_right);
    }];
    
    [myTableView setTableHeaderView:headerView];
    
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
    label.textColor=[CYTSI colorWithHexString:@"#333333"];
    label.font=[UIFont systemFontOfSize:14];

    label.text=@"今日订单";
    [smallView addSubview:label];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49.5, DeviceWidth, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [bgView addSubview:lineView];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0 && nowOrderArray.count!=0) {
        return 93;
//    } else {
//        return 73;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ScanTripTableViewCell *cell = [[ScanTripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.scanCar = nowOrderArray[indexPath.row];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScanCarModel *scanModel = nowOrderArray[indexPath.row];
    ScanTripDetailViewController *vc = [[ScanTripDetailViewController alloc] init];
    vc.order_id = scanModel.order_id;
    [self.navigationController pushViewController:vc animated:YES];
    
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
        NSString *driverLocationLo = @"0";
        NSString *driverLocationLa = @"0";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] == nil) {
            driverLocationLo = @"0";
            driverLocationLa = @"0";
        }else{
            driverLocationLo = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"];
            driverLocationLa = [[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"];
        }
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]!=nil) {
//            NSDictionary * dic =@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_lng":driverLocationLo,@"driver_lat":driverLocationLa,@"speed":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationSpeed"],@"angle":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationCourse"],@"stime":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationStime"],@"state":@"0",@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
//            // NSLog(@"%@",dic);
//            [AFRequestManager postRequestWithUrl:DRIVER_UPDATE_VEHICLE_LOCATION params:dic tost:NO special:1 success:^(id responseObject) {
//
//
//            } failure:^(NSError *error) {
//                //   NSLog(@"%@",error);
//            }];
//
//        }
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
