//
//  AppointAirListViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2018/9/26.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "AppointAirListViewController.h"
#import "CYAddressView.h"
#import "CYAlertView.h"
#import "CYOrderView.h"
#import "CancelTripViewController.h"
#import "CYButtonView.h"
#import "DriveMapViewController.h"
#import "NotiMessageModel.h"
#import "ViewController.h"
#import "CYLableView.h"
#import "PriceDistanceModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "SpeechSynthesizer.h"
#import "JPUSHService.h"

#import "DCYMapView.h"
#import "ShouYeTableViewCell.h"
#import "BjAlertView.h"
#import "OrderDetailModel.h"
#import "YuYueAndAirPortView.h"

#import "AFNetworking.h"
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"

#import "FaceAlertView.h"
#import "AccountView.h"

#define myDotNumbers @"0123456789.\n"

#define myNumbers @"0123456789\n"

@interface AppointAirListViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate,AMapNaviDriveManagerDelegate,AMapNaviCompositeManagerDelegate,AMapNaviDriveDataRepresentable,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,YuYueAndAirPortViewDelegat,UIAlertViewDelegate>

{
    int buttonType;//状态类型 1：到达上车地点  2：开始计费 3：结束行程
    UIButton * bottomButton;//底部按钮
    CYAlertView * alertView;
    CYAlertView * singleAlertView;//单个按钮弹出视图
    CYAlertView * inputPursonAlertView;//去输入摇一摇目的地弹出视图
    CYOrderView * orderView;//抢单视图
    
    CYAddressView * addressView;//普通视图
    YuYueAndAirPortView *planeView;//预约、飞机试图
    
    UIView * priceView;//里程价格视图
    CYLableView * leftPriceView;
    CYLableView * middlePriceView;
    CYLableView * rightPriceView;
    CYButtonView * midleButtonView;//中间听单视图
    UIView * bgWhiteView;//白色背景视图
    UIView * orderBgView;//订单视图的背景视图
    
    //地图变量
    MAPointAnnotation *locationAnnotation;//定位的大头针
    MAPointAnnotation *endAnnotation;//终点的大头针
    //    MAAnimatedAnnotation *carAnnotation;//小车大头针
    
    int singleAlertType;//单个按钮提示视图类别
    
    UIButton * daoHangButton;
    UIButton *bjButton;//报警按钮
    
    //持续更新的司机的位置
    float driverLong;
    float driverLat;
    double driverTimeTap;//司机实时时间
    double driverCourse;//司机实时角度
    double carSpeed;//司机实时车速
    
    NSTimer * updatePriceTimer;//更新价格定时器
    
    NSTimer * upDateDriverLocationTimer;//小车动画定时更新位置定时器
    CLLocationCoordinate2D allowUpdateEndLocation;//持续更新位置时的结束位置的坐标
    CLLocationCoordinate2D allowUpdateStarLocation;//持续更新位置时的开始位置的坐标
    float allowUpdateRoadTime;//持续更新司机位置路线总时间
    
    BOOL isSeted;//是否已经配置好订单的状态
    BOOL isSetedOrder;//是否已经配置好了从订单列表进来的状态
    
    //测试点数组
    NSMutableArray * longArray;
    NSMutableArray * latArray;
    
    MAUserLocationRepresentation *representation;//用户位置
    MAPinAnnotationView * userLocationView;//用户位置视图
    
    //语音提示定时器
    //    NSTimer * alertTimer;//每隔一分钟提示一次
    //    BOOL isAginDrawLine;//是否是重新规划路线
    
    BOOL isCanListen;//是否可以抢单了
    BOOL isOverDrawTakeUserLine;//是否已经绘制了接乘客的路线
    
    NotiMessageModel * notiMessage;//推送信息
    
    NSTimer * checkTimer;//检查导航是否出问题了
    
    BOOL isNearBy;//是否快到目的地了
    MBProgressHUD * HUD;//刚进来的时候的加载框
    
    //摇一摇
    UIView *shakeButtonView;//摇一摇按钮视图
    UIView *topView;
    UITextField *searchFiled;
    UIView *blackView;
    UITableView *myTableView;
    UIButton *shakePursonButton;
    UIButton *shakeSureButton;
    NSMutableArray *searchResultArray;
    
    OrderDetailModel *orderDetail;
    
    UILabel * nameLable;//预约单的乘客姓名
    UILabel * describeLable;//预约单的乘客描述
    UIButton * userButton;//预约单的头像
    UIView * userView;
    UILabel *remarkLabel;//乘客备注
    UILabel *yuyueDateLabel;//预约时间
}

//@property (strong, nonatomic) MAMapView * mapView;//地图;
@property (strong, nonatomic) DCYMapView * mapView;//地图;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *lm;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;//当前定位经纬度
@property (nonatomic, assign) CLLocationCoordinate2D agoCurrentCoordinate;//当前定位经纬度之前的点
@property (nonatomic, strong) AMapSearchAPI *search;//搜索对象
@property (nonatomic,strong) MAPolyline * commonPolyline;//轨迹（折现）
@property (nonatomic,strong) AMapNaviDriveManager * driveManager;//轨迹管理(起点到终点)
@property (nonatomic,strong) MAPolyline * takeUserCommonPolyline;//去接乘客的轨迹（折现）
@property (nonatomic,strong) AMapNaviDriveManager * takeUserManager;//去接乘客的轨迹管理

//导航界面
@property (nonatomic,strong) DriveMapViewController * driveVC;//导航视图
@property (nonatomic,strong) DriveMapViewController * takeUserDriveVC;//导航视图
@property(nonatomic,strong)  BjAlertView *alert;
@property(nonatomic,strong)FaceAlertView *faceAlert;



//报警位置信息
@property(nonatomic,copy)NSString *bjPosition_lng;
@property(nonatomic,copy)NSString *bjPosition_lat;
@property(nonatomic,copy)NSString *bjAddress;
@property(nonatomic,copy)NSString *bjPosition_time;


@property(nonatomic,strong)AccountView *account;

//附加费
@property(nonatomic,copy)NSString *extra_charge;


@end

@implementation AppointAirListViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [updatePriceTimer invalidate];
    updatePriceTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newOrder" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([bottomButton.titleLabel.text isEqualToString:@"结束行程"]) {
        updatePriceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(savePointAndPlanDistance) userInfo:nil repeats:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrder:) name:@"newOrder" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"预约详情";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self creatHttp];
//    if (_orderState !=4) {//待付款
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
//    }
//    if (_orderState==1 || _orderState==0) {
//        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"orderState", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
//    }
    
    //接受透传消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTouChuan:) name:@"touchuan" object:nil];
    
    buttonType=0;//初始化状态类型
    singleAlertType=1;
    searchResultArray = [[NSMutableArray alloc]init];
    self.extra_charge = @"";
    [self setUpNav];//设置导航栏
    [self creatAlertView];//创建弹出视                                                                                                                                                                                                                                                                                                                                                                                            图
    [self creatWhiteBgView];//创建白色背景视图
    [self creatRobOrderView];//创建抢单视图 1：到达目的地 2：取消订单  3:输入支付金额
    
    [self creatMapView];//创建地图视图
    
    
    
    if (self.submit_class == 2)
    {
        [self creatShakeButtonView];//创建摇一摇底部按钮视图
        [self creatTopView];//创建摇一摇顶部搜索目的地视图
        [self creatReslutView];//创建摇一摇搜索结果视图
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.faceAlert];
}


//请求数据
-(void)creatHttp
{
    __weak typeof(self) weakSelf = self;
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEY_ORDER_DETAIL_INFO params:@{@"order_id":self.orderID,@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [OrderDetailModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"locus_point":@"DriverLocationModel"};
            
        }];
        
        orderDetail=[OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        weakSelf.order_class = orderDetail.order_class;
        weakSelf.submit_class = orderDetail.submit_class;
        weakSelf.userPhone = orderDetail.passenger_phone;
        [weakSelf creatMainView:orderDetail.appoint_type];
        planeView.orderModel = orderDetail;
        
        weakSelf.endCoordinate=CLLocationCoordinate2DMake(orderDetail.end_lat, orderDetail.end_lng);
        weakSelf.userStartCoordinate=CLLocationCoordinate2DMake(orderDetail.start_lat, orderDetail.start_lng);
    } failure:^(NSError *error) {
        
    }];
}

//默认操作订单状态
-(void)defaultGoOrder
{
    if (_orderState==1 || _orderState==0) {//1:待到达目的地 直接导航去接乘客
        
        [self.takeUserManager addDataRepresentative:self.takeUserDriveVC.driveView];
        [self.takeUserManager addDataRepresentative:self];
        [self drawRoadTakeUser];
        
    }
    if (_orderState==2) {//待上车
        bjButton.hidden = NO;
        if (self.submit_class == 2)//摇一摇叫车
        {
            inputPursonAlertView.titleStr=@"到达上车地点";
            inputPursonAlertView.alertStr=@"请等待乘客上车并向乘客询问目的地，在确认后输入到APP中~";
            inputPursonAlertView.cancleButtonStr=@"";
            inputPursonAlertView.sureButtonStr=@"去输入目的地";
            inputPursonAlertView.isCanHiden=YES;
            [inputPursonAlertView setSingleButton];
            [inputPursonAlertView setTextFiled:YES];
            [inputPursonAlertView showAlertView];
            
            __weak typeof(inputPursonAlertView) weakInputAlertView = inputPursonAlertView;
            inputPursonAlertView.phoneBlock = ^{
                [weakInputAlertView hideAlertView];
                [shakeButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                }];
            };
            
        } else//普通叫车
        {
            //到达上车地点
            self.title=@"等待乘客上车";
            [bottomButton setTitle:@"开始计费" forState:UIControlStateNormal];
            
            [self.driveManager addDataRepresentative:self.driveVC.driveView];
            [self.driveManager addDataRepresentative:self];
            
            [self startDrawLine];//开始划线
            buttonType=2;
        }
        
    }
    
    if (_orderState==3) {//待送达
        self.navigationItem.rightBarButtonItems = nil;
        if (self.order_class==1 || _order_class == 4 || _order_class == 5 || _order_class == 7) {
            
            priceView.frame=CGRectMake(0, 212, DeviceWidth, 70);
            
        }
        
        //保存最新点及距离
        double latitude;
        double longtitude;
        
        if (userLocationView==nil || userLocationView.annotation==nil) {
            
            latitude=self.currentCoordinate.latitude;
            longtitude=self.currentCoordinate.longitude;
            
        }else{
            
            latitude=userLocationView.annotation.coordinate.latitude;
            longtitude=userLocationView.annotation.coordinate.longitude;
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longtitude] forKey:@"new_longitude"];
        
        [self firstJoinUpdatePrice];//第一次进来距离时间价钱赋值
        
        //        }
        
        //开始计费
        self.title=@"去送乘客";
        [bottomButton setTitle:@"结束行程" forState:UIControlStateNormal];
        // [self startDrive];//开始导航
        [self.driveManager addDataRepresentative:self.driveVC.driveView];
        [self.driveManager addDataRepresentative:self];
        
        [self startDrawLine];//开始划线
        buttonType=3;
        
    }
    
    if (_orderState==4) {//待付款
        self.navigationItem.rightBarButtonItems = nil;
        //开始计费
        self.title=@"等待乘客付款";
        [bottomButton setTitle:@"等待乘客付款" forState:UIControlStateNormal];
        buttonType=3;
        bottomButton.backgroundColor=[CYTSI colorWithHexString:@"#666666"];
        bottomButton.enabled=NO;
        
    }
    
    _isOrderList=NO;
    
}
-(void)newOrder:(NSNotification *)noti{
    notiMessage=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];
    orderView.startStr=notiMessage.extras.start_address;
    orderView.endStr=notiMessage.extras.end_address;
    if (notiMessage.extras.submit_class == 2) {
        orderView.endStr = @"目的地待与乘客确认";
    }
    orderView.remark = notiMessage.extras.remark;
    //新订单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order"]) {
        [self takeOrder:noti];
        orderView.stateFlag = @"0";
        orderView.startDistanceLable.text=[NSString stringWithFormat:@"接驾%.2f公里",[notiMessage.extras.distance floatValue]];
        orderView.allDistanceLable.text=[NSString stringWithFormat:@"全程%.2f公里",[notiMessage.extras.journey_mile floatValue]];
        [CYTSI setStringWith:orderView.startDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.distance floatValue]] lable:orderView.startDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
        [CYTSI setStringWith:orderView.allDistanceLable.text someStr:[NSString stringWithFormat:@"%.2f",[notiMessage.extras.journey_mile floatValue]] lable:orderView.allDistanceLable theFont:[UIFont systemFontOfSize:18] theColor:[CYTSI colorWithHexString:@"#386ac6"]];
    }
    //预约单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order_appoint"]){//预约单
        [self takeOrder:noti];
        orderView.stateFlag = @"1";
        orderView.yuYueLable.text = notiMessage.extras.appoint_time;
        
    }
    //接机单
    if ([notiMessage.extras.operate_class isEqualToString:@"new_order_flight"]){//接机单
        [self takeOrder:noti];
        orderView.stateFlag = @"2";
        orderView.airPortLable.text = [NSString stringWithFormat:@"航班号：%@",notiMessage.extras.flight_number];
        orderView.airPortDateLable.text = [NSString stringWithFormat:@"%@到达",notiMessage.extras.appoint_time];
    }
}
-(void)takeOrder:(NSNotification *)noti{
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
    //        //弹出视图
    bgWhiteView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        orderBgView.frame=CGRectMake(20, (DeviceHeight-369)/2, DeviceWidth-40, 369);
        
    }];
    
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
#pragma mark ------- 接收到透传消息------
-(void)receiveTouChuan:(NSNotification *)noti
{
    notiMessage=[NotiMessageModel mj_objectWithKeyValues:noti.userInfo];

    //乘客已付款
    if ([notiMessage.extras.operate_class isEqualToString:@"passenger_payment"]) {
    
        
    }
    
    //乘客取消订单
    if ([notiMessage.extras.operate_class isEqualToString:@"passenger_cancel_order"]) {
        
        NSLog(@"AppointAirListViewController --------- passenger_cancel_order");
        
        [checkTimer invalidate];
        checkTimer=nil;
        
//        NSArray * vcArray=self.navigationController.viewControllers;
//        for (AppointAirListViewController * vc in vcArray) {
//            if ([vc isKindOfClass:[AppointAirListViewController class]]) {
//
//                [self.navigationController popToViewController:vc animated:YES];
//
//            }
//        }
//
//        singleAlertType=2;
//        singleAlertView.titleStr=@"乘客已取消订单";
//        singleAlertView.alertStr=[NSString stringWithFormat:@"很抱歉，乘客已取消订单。取消原因：%@。我们已开始继续为您派单，请稍等。",notiMessage.extras.cancel_reason];
//        singleAlertView.cancleButtonStr=@"";
//        singleAlertView.sureButtonStr=@"我知道了";
//        [singleAlertView setSingleButton];
//        [singleAlertView setTextFiled:YES];
//        [singleAlertView showAlertView];
//
//        singleAlertView.phoneBlock = ^{
//
//            if (singleAlertType==2) {
//
//                [singleAlertView hideAlertView];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
//
//                self.AlreadyListenBlock();
//
//                [self navBack];
//            }
//
//        };
        
    }
    
}



//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *  changeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame=CGRectMake(0, 0, 40, 20);
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeButton setTitle:@"取消" forState:UIControlStateNormal];
    changeButton.titleLabel.font=[UIFont systemFontOfSize:13];

    [changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:changeButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//返回按钮点击事件
-(void)navBackButtonClicked
{
    [checkTimer invalidate];
    checkTimer=nil;
    [updatePriceTimer invalidate];
    updatePriceTimer=nil;
    //移除地图数据
    [self clearMapView];
    
    NSArray * vcArray=self.navigationController.viewControllers;
    for (ViewController * vc in vcArray) {
        
        if ([vc isKindOfClass:[ViewController class]]) {
            
            vc.isNeedReload=YES;
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    }
}

//改派按钮点击事件
-(void)changeButtonClicked
{
    
    
    CancelTripViewController * vc=[[CancelTripViewController alloc]init];
    vc.orderID=_orderID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//创建弹出视图
-(void)creatAlertView
{
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
    
    singleAlertView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:singleAlertView];
    
    __weak typeof (singleAlertView) weakSingleAlertView = singleAlertView;
    singleAlertView.cancleBlock = ^{
        
        [weakSingleAlertView hideAlertView];
        
    };
    
    //去输入摇一摇目的地弹出视图
    inputPursonAlertView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    [window addSubview:inputPursonAlertView];
    
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
                if ([notiMessage.extras.appoint_type isEqualToString:@"0"]) {//及时单
                    [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":notiMessage.extras.order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:1 success:^(id responseObject) {
                        NSLog(@"responseObjectresponseObjectresponseObject%@",responseObject);
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
                        NSLog(@"responseObjectresponseObjectresponseObjectresponseObject%@",responseObject);
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
        __weak typeof(self) weakSelf = self;
        _faceAlert.scanFaceBlock = ^(NSDictionary *dataDic, NSString *str, NSString *orderID, NSInteger btnState) {
            [weakSelf scanFaceAction:str orderId:orderID];
        };
    }
    return _faceAlert;
}
//创建主要视图
-(void)creatMainView:(NSString *)type
{
    
    [planeView removeFromSuperview];
    [bottomButton removeFromSuperview];
    [daoHangButton removeFromSuperview];
    [bjButton removeFromSuperview];
    
    planeView = [YuYueAndAirPortView createView];
    planeView.frame = CGRectMake(0, 64, DeviceWidth, 226);
    planeView.delegate = self;
    [self.view addSubview:planeView];
    
    bottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame=CGRectMake(15, DeviceHeight-51, DeviceWidth-30, 44);
    [bottomButton setTitle:@"去接乘客" forState:UIControlStateNormal];
    bottomButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    bottomButton.titleLabel.font=[UIFont systemFontOfSize:16];
    bottomButton.layer.cornerRadius=3;
    bottomButton.layer.masksToBounds=YES;
    [bottomButton addTarget:self action:@selector(bottomButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomButton];
    daoHangButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [daoHangButton setTitle:@"导航" forState:UIControlStateNormal];
    daoHangButton.layer.cornerRadius=22;
    daoHangButton.layer.masksToBounds=YES;
    daoHangButton.hidden=YES;
    daoHangButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    daoHangButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [daoHangButton addTarget:self action:@selector(daoHangButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:daoHangButton];
    [daoHangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomButton.mas_top).with.offset(-10);
        make.height.and.width.equalTo(@44);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    bjButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [bjButton setTitle:@"报警" forState:UIControlStateNormal];
    bjButton.layer.cornerRadius=22;
    bjButton.layer.masksToBounds=YES;
    bjButton.hidden=YES;
    bjButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    bjButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [bjButton addTarget:self action:@selector(bjButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bjButton];
    [bjButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(daoHangButton.mas_top).with.offset(-10);
        make.height.and.width.equalTo(@44);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    [self creatPriceView];//创建价格和里程视图
}
#pragma mark --------   报警按钮点击事件
-(void)bjButtonClicked{
    self.lm.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.lm.locationTimeout =2;
    self.lm.reGeocodeTimeout = 2;
    
    __weak typeof(self) weakSelf = self;
    
    
    [self.lm requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSLog(@"self.locationManagerself.locationManager");
        if (error)
        {
            NSLog(@"errorerror%@",error);
            [CYTSI otherShowTostWithString:@"定位失败，请重试"];
            self.alert = [[BjAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth,DeviceHeight) addressString:@"当前位置不可用"];
            self.alert.bjActionBlock = ^{
                weakSelf.bjPosition_lat = @"";
                weakSelf.bjPosition_lng = @"";
                weakSelf.bjAddress = @"";
                weakSelf.bjPosition_time = @"";
                [weakSelf bjNetwork];
                NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"110"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            };
            self.alert.cancel = ^{
                [weakSelf.alert removeFromSuperview];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:self.alert];
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }else{
            self.alert = [[BjAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth,DeviceHeight) addressString:regeocode.formattedAddress];
            self.alert.bjActionBlock = ^{
                weakSelf.bjPosition_lat = [NSString stringWithFormat:@"%.14f",location.coordinate.latitude];
                weakSelf.bjPosition_lng = [NSString stringWithFormat:@"%.14f",location.coordinate.longitude];
                weakSelf.bjAddress = regeocode.formattedAddress;
                weakSelf.bjPosition_time = [NSString stringWithFormat:@"%.6f",[location.timestamp timeIntervalSince1970]];
                [weakSelf bjNetwork];
                NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"110"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            };
            self.alert.cancel = ^{
                [weakSelf.alert removeFromSuperview];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:self.alert];
        }
    }];
}
-(void)bjNetwork{
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_ALARM params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":self.orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"position_lng":self.bjPosition_lng,@"position_lat":self.bjPosition_lat,@"address":self.bjAddress,@"position_time":self.bjPosition_time,@"order_type":@"0"} tost:NO special:0 success:^(id responseObject) {
        NSLog(@"正在播出报警电话call is dialing ");
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatPriceView
{
    [priceView removeFromSuperview];
    priceView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 212, DeviceWidth, 70)];
    priceView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:priceView];
    
    middlePriceView=[[CYLableView alloc]init];
    middlePriceView.backgroundColor=[UIColor whiteColor];
    middlePriceView.topLable.text=@"已用时";
    middlePriceView.bottomLable.text=@"0分钟";
    [priceView addSubview:middlePriceView];
    [middlePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(priceView);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
    }];
    
    leftPriceView=[[CYLableView alloc]init];
    leftPriceView.backgroundColor=[UIColor whiteColor];
    leftPriceView.topLable.text=@"已行驶";
    leftPriceView.bottomLable.text=@"0公里";
    [priceView addSubview:leftPriceView];
    [leftPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(middlePriceView.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(@0);
        make.right.equalTo(middlePriceView.mas_left);
    }];
    
    rightPriceView=[[CYLableView alloc]init];
    rightPriceView.backgroundColor=[UIColor whiteColor];
    rightPriceView.topLable.text=@"当前费用";
    rightPriceView.bottomLable.text=@"0元";
    [priceView addSubview:rightPriceView];
    [rightPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(middlePriceView.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(middlePriceView.mas_right);
        make.right.equalTo(priceView.mas_right);
    }];
    
    [self setPriceViewText];
    
}

-(void)setPriceViewText
{
    [CYTSI setStringWith:leftPriceView.bottomLable.text someStr:@"公里" lable:leftPriceView.bottomLable theFont:[UIFont systemFontOfSize:11] theColor:[CYTSI colorWithHexString:@"#666666"]];
    [CYTSI setStringWith:middlePriceView.bottomLable.text someStr:@"分钟" lable:middlePriceView.bottomLable theFont:[UIFont systemFontOfSize:11] theColor:[CYTSI colorWithHexString:@"#666666"]];
    [CYTSI setStringWith:rightPriceView.bottomLable.text someStr:@"元" lable:rightPriceView.bottomLable theFont:[UIFont systemFontOfSize:11] theColor:[CYTSI colorWithHexString:@"#666666"]];
}

//导航按钮点击事件
-(void)daoHangButtonClicked
{
    if (self.currentCoordinate.latitude==0) {
        
        [self startLocation];//刚抢完单进来的时候定位失败时
        
        return;
    }
    
    if (_orderState==1 || _orderState==0) {
        [self.navigationController pushViewController:self.takeUserDriveVC animated:NO];
    } else {
        [self.navigationController pushViewController:self.driveVC animated:NO];
    }
}

//拨打电话按钮点击事件
-(void)phoneButtonClicked
{
    if ([_userPhone isEqualToString:@""]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单已超时，并关闭司乘直接通话，为您联系客服" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [CYTSI callPhoneStr:orderDetail.cust_phone withVC:self];
        }];
        
        [alertC addAction:alertA];
        [alertC addAction:alertB];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [CYTSI callPhoneStr:_userPhone withVC:self];
    }
    //    [self aginStartNavi];//重新规划路径
}

//底部按钮点击事件
-(void)bottomButtonClicked
{
    
//    NSLog(@"bottomButtonClicked== orderId ============%@",self.orderID);
    switch (buttonType) {
        case 0://去接乘客
        {
            __weak typeof(self) weakSelf = self;
            [AFRequestManager postRequestWithUrl:DRIVER_BASE_DATA params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":@"1"} tost:YES special:0 success:^(id responseObject) {
                
                
                ShouYeModel * shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
//                NSLog(@"responseObject    =========   %@",responseObject[@"data"]);
                //判断司机是否上班
                if (![shouYe.online_state isEqualToString:@"1"]) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为下班状态请返回首页，开始上班" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alert.delegate = weakSelf;
                    [alert show];
                }else{
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"] isEqualToString:@"1"]){
                        [self scanFaceAction:@"0" orderId:self.orderID];
                    }else{
                        __weak typeof(self) weakSelf = self;
                        [AFRequestManager postRequestWithUrl:DRIVER_PICK_UP_PASSENGER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":self.orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"join_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],@"join_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"]} tost:YES special:0 success:^(id responseObject) {
                            if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                                buttonType = 1;
                                [bottomButton setTitle:@"到达上车地点" forState:UIControlStateNormal];
                                planeView.cancelBtn.hidden = NO;
                                [weakSelf startDriveTakeUser];
                                _orderState=1;
                                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:self.orderID forKey:@"order_id"];
                            }else{
                                [CYTSI otherShowTostWithString:@"请重试"];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                }
            } failure:^(NSError *error) {
                
                
            }];
        }
            break;
        case 1://到达上车地点
        {
            
            [AFRequestManager postRequestWithUrl:DRIVER_ARRIVE_START_LOCATION params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
                _orderState=2;
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
                [self cancelGPSNavi];//结束导航
                //                [self endUpdateDriverLocationTimer];//先销毁
                bjButton.hidden = NO;
                if (self.submit_class == 2)//摇一摇叫车
                {
                    inputPursonAlertView.titleStr=@"到达上车地点";
                    inputPursonAlertView.alertStr=@"请等待乘客上车并向乘客询问目的地，在确认后输入到APP中~";
                    inputPursonAlertView.cancleButtonStr=@"";
                    inputPursonAlertView.sureButtonStr=@"去输入目的地";
                    inputPursonAlertView.isCanHiden=YES;
                    [inputPursonAlertView setSingleButton];
                    [inputPursonAlertView setTextFiled:YES];
                    [inputPursonAlertView showAlertView];
                    
                    __weak typeof(inputPursonAlertView) weakInputAlertView = inputPursonAlertView;
                    inputPursonAlertView.phoneBlock = ^{
                        [weakInputAlertView hideAlertView];
                        
                        [shakeButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(0);
                        }];
                    };
                    
                } else//普通叫车
                {
                    
                    self.title=@"等待乘客上车";
                     planeView.cancelBtn.hidden = YES;
                    [bottomButton setTitle:@"开始计费" forState:UIControlStateNormal];
                    buttonType=2;
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
            break;
        case 2://开始计费
        {
            NSString *userPhoneStr1 = [_userPhone substringWithRange:NSMakeRange(7,1)];//截取掉下标7之后的字符串
            NSString *userPhoneStr2 = [_userPhone substringWithRange:NSMakeRange(8,1)];
            NSString *userPhoneStr3 = [_userPhone substringWithRange:NSMakeRange(9,1)];
            NSString *userPhoneStr4 = [_userPhone substringFromIndex:10];
            [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:[NSString stringWithFormat:@"请确保尾号为%@-%@-%@-%@的乘客以上车",userPhoneStr1,userPhoneStr2,userPhoneStr3,userPhoneStr4]];
            [alertView showAlertView];
            
            __weak typeof (self) weakSelf = self;
            __weak typeof (bottomButton) weakBottomButton = bottomButton;
            __weak typeof (alertView) weakAlertView = alertView;
            
            alertView.phoneBlock = ^{
                
                NSDictionary *dic = [weakSelf driverLocation];
                NSDate *date = [NSDate date];
                NSInteger timeInter = [date timeIntervalSince1970];
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeInter];
                
                NSDictionary *requestDic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":weakSelf.orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"aboard_lng":dic[@"lng"],@"aboard_lat":dic[@"lat"],@"aboard_time":timeStr};
                if (self.submit_class ==2)
                {
                    requestDic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":weakSelf.orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"aboard_lng":dic[@"lng"],@"aboard_lat":dic[@"lat"],@"aboard_time":timeStr,@"end_address":self.endAddress,@"end_lng":[NSString stringWithFormat:@"%.14f",self.endCoordinate.longitude],@"end_lat":[NSString stringWithFormat:@"%.14f",self.endCoordinate.latitude]};
                }
                
                [AFRequestManager postRequestWithUrl:DRIVER_RECEIVE_PASSENGER params:requestDic tost:YES special:0 success:^(id responseObject) {
                    
                    if (weakSelf.order_class==1 || weakSelf.order_class==4 || weakSelf.order_class==5 || weakSelf.order_class == 7) {
                        
                        priceView.frame=CGRectMake(0, 212, DeviceWidth, 70);
                        
                    }
                  
                    updatePriceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(savePointAndPlanDistance) userInfo:nil repeats:YES];
                
                    
                    //保存最新点及距离
                    double latitude;
                    double longtitude;
                    
                    if (userLocationView==nil || userLocationView.annotation==nil) {
                        
                        latitude=weakSelf.currentCoordinate.latitude;
                        longtitude=weakSelf.currentCoordinate.longitude;
                        
                    }else{
                        
                        latitude=userLocationView.annotation.coordinate.latitude;
                        longtitude=userLocationView.annotation.coordinate.longitude;
                        
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longtitude] forKey:@"new_longitude"];
                    NSLog(@"==================================================");
                    [self firstJoinUpdatePrice];//第一次进来距离时间价钱赋值
                    
                    self.navigationItem.rightBarButtonItems = nil;
                    weakSelf.title=@"去送乘客";
                    [weakBottomButton setTitle:@"结束行程" forState:UIControlStateNormal];
                    buttonType=3;
                    _orderState=3;
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
                    
                    [weakAlertView hideAlertView];
                    
                    [weakSelf.driveManager addDataRepresentative:self.driveVC.driveView];
                    [weakSelf.driveManager addDataRepresentative:self];
                    [weakSelf clearAgoLine];//清除之前的轨迹
                    [weakSelf startDrawLine];//开始划线
                    planeView.cancelBtn.hidden = YES;
                    
                } failure:^(NSError *error) {
                    
                }];
                
            };
        }
            break;
        case 3://结束行程
        {
            [self cancelGPSNavi];//结束导航
            [checkTimer invalidate];
            checkTimer=nil;
            
            singleAlertType=1;
            singleAlertView.titleStr=@"到达目的地";
            singleAlertView.alertStr=@"请提示乘客先付款再下车，否则行程无法结束哦~";
            singleAlertView.cancleButtonStr=@"";
            singleAlertView.sureButtonStr=@"我知道了";
            singleAlertView.isCanHiden=NO;
            [singleAlertView setSingleButton];
            [singleAlertView setTextFiled:YES];
            [singleAlertView showAlertView];
            
            __weak typeof (self) weakSelf = self;
            __weak typeof (singleAlertView) weakAlertView = singleAlertView;
            singleAlertView.phoneBlock = ^{
                [weakAlertView hideAlertView];
                if (singleAlertType==1) {//到达目的地
                
                    
#pragma mark ---- 出租车费用结算
                    if (_order_class==2) {
                        singleAlertType=3;
                        weakAlertView.isCanHiden=YES;
                        [weakAlertView setDoubleButton];
                        weakAlertView.titleStr=@"订单结算";
                        weakAlertView.alertStr=@"请确认本次行程费用";
                        weakAlertView.cancleButtonStr=@"确认";
                        weakAlertView.cancleButton.backgroundColor=[UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0];
                        weakAlertView.sureButtonStr = @"返回";
                        weakAlertView.phoneButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0];
                        [weakAlertView setTextFiled:NO];
                        
                        if (_order_class==1 || _order_class == 4 || _order_class == 5 || _order_class == 7) {
                            weakAlertView.alertStr=@"请确认本次行程费用";
                            
                            if (weakSelf.journey_fee==nil || [weakSelf.journey_fee isKindOfClass:[NSNull class]]) {
                                
                                [CYTSI otherShowTostWithString:@"价格有误"];
                                return ;
                                
                            }
                            weakAlertView.moneyTextFiled.text=[NSString stringWithFormat:@"%.2f",[weakSelf.journey_fee floatValue]];
                            weakAlertView.moneyStr=[NSString stringWithFormat:@"%.2f",[weakSelf.journey_fee floatValue]];
                            weakAlertView.moneyTextFiled.enabled=NO;
                            [self setPriceEndOrder:weakAlertView];
                        }
                        
                        //现金支付
                        weakAlertView.cancleBlock  = ^{
                            if (singleAlertType==3) {//输入支付金额
                                
                                if ([weakAlertView.moneyStr floatValue]<=0.01 && _order_class==2) {
                                    
                                    [CYTSI otherShowTostWithString:@"请输入正确的金额"];
                                    return ;
                                    
                                }
                                
                                double latitude;
                                double longitude;
                                
                                if (userLocationView==nil || userLocationView.annotation==nil) {
                                    
                                    latitude=self.currentCoordinate.latitude;
                                    longitude=self.currentCoordinate.longitude;
                                    
                                }else{
                                    
                                    latitude=userLocationView.annotation.coordinate.latitude;
                                    longitude=userLocationView.annotation.coordinate.longitude;
                                    
                                }
                                
                                [updatePriceTimer invalidate];
                                updatePriceTimer=nil;
                                
                                [AFRequestManager postRequestWithUrl:DRIVER_ARRIVER_END_LOCATION params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":weakSelf.orderID,@"journey_fee":weakAlertView.moneyStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"journey_mile":[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"],@"debus_lng":[NSString stringWithFormat:@"%.14f",longitude],@"debus_lat":[NSString stringWithFormat:@"%.14f",latitude]} tost:YES special:0 success:^(id responseObject) {
                                    //                                priceView.frame=CGRectMake(DeviceWidth, 212, DeviceWidth, 70);1
                                    self.navigationItem.rightBarButtonItems = nil;
                                    [weakSelf removeNewPointAndDistance];//移除保存的数据
                                    
                                    [CYTSI otherShowTostWithString:@"已通知乘客付款"];
                                    [weakAlertView hideAlertView];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"order_id"];
                                    _orderState=0;
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
                                    [weakSelf clearMapView];
                                    
                                    weakSelf.AlreadyListenBlock();
                                    [weakSelf navBack];
                                    planeView.cancelBtn.hidden = YES;
                                } failure:^(NSError *error) {
                                    
                                }];
                                
                            }
                        };
                        
                        //确认金额
                        weakAlertView.phoneBlock = ^{
                            [weakAlertView hideAlertView];
                            daoHangButton.hidden=NO;
                            bjButton.hidden = NO;
                        };
                    }else{
#pragma mark ---- 快车费用结算
                        weakSelf.account = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) money:[NSString stringWithFormat:@"%.2f",[weakSelf.journey_fee floatValue]]];
                        weakSelf.account.moneyTF.delegate = self;
                        weakSelf.account.moneyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        [weakSelf.view addSubview:weakSelf.account];
                        [weakSelf.account.moneyTF addTarget:weakSelf action:@selector(accountTFChange:) forControlEvents:UIControlEventEditingChanged];
                        
                        if (_order_class==1 || _order_class == 4 || _order_class == 5 || _order_class == 7) {
                            
                            if (weakSelf.journey_fee==nil || [weakSelf.journey_fee isKindOfClass:[NSNull class]]) {
                                
                                [CYTSI otherShowTostWithString:@"价格有误"];
                                return ;
                                
                            }
                            [self setAccountPriceEndOrder:weakSelf.account];
                        }
                        
                        //现金支付
                        weakSelf.account.confirmBlock  = ^{
                            
                            double latitude;
                            double longitude;
                            
                            if (userLocationView==nil || userLocationView.annotation==nil) {
                                
                                latitude=self.currentCoordinate.latitude;
                                longitude=self.currentCoordinate.longitude;
                                
                            }else{
                                
                                latitude=userLocationView.annotation.coordinate.latitude;
                                longitude=userLocationView.annotation.coordinate.longitude;
                                
                            }
                            
                            [updatePriceTimer invalidate];
                            updatePriceTimer=nil;
                            
                            [AFRequestManager postRequestWithUrl:DRIVER_ARRIVER_END_LOCATION params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":weakSelf.orderID,@"journey_fee":[NSString stringWithFormat:@"%.2f",[weakSelf.journey_fee floatValue]],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"journey_mile":[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"],@"debus_lng":[NSString stringWithFormat:@"%.14f",longitude],@"debus_lat":[NSString stringWithFormat:@"%.14f",latitude],@"extra_charge":weakSelf.extra_charge} tost:YES special:0 success:^(id responseObject) {
                                self.navigationItem.rightBarButtonItems = nil;
                                [weakSelf removeNewPointAndDistance];//移除保存的数据
                                
                                [CYTSI otherShowTostWithString:@"已通知乘客付款"];
                                [weakSelf.account removeFromSuperview];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"order_id"];
                                _orderState=0;
                                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
                                [weakSelf clearMapView];
                                weakSelf.AlreadyListenBlock();
                                
                                [weakSelf navBack];
                                 planeView.cancelBtn.hidden = YES;
                            } failure:^(NSError *error) {
                                
                            }];
                        };
                        
                        //确认金额
                        weakSelf.account.cancelBlock  = ^{
                            [weakSelf.account removeFromSuperview];
                            daoHangButton.hidden=NO;
                            bjButton.hidden = NO;
                        };
                    }
                    
                }
            };
        }
            break;
        default:
            break;
    }
}
-(void)accountTFChange:(UITextField *)textField{
    if (textField.text != nil  && [CYTSI isNumber:textField.text]) {
        self.account.moneyLB.text = [NSString stringWithFormat:@"¥ %.2f",([self.journey_fee floatValue] + [textField.text floatValue])];
        self.extra_charge = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
    }else if ([textField.text isEqualToString:@""]){
        self.account.moneyLB.text = [NSString stringWithFormat:@"¥ %.2f",[self.journey_fee floatValue]];
        self.extra_charge = @"0";
    }
}
#pragma mark textFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        if ([textField isEqual:self.account.moneyTF]) {
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
                if (range.location >= 3) {
                    if ([string isEqualToString:@"."] && range.location == 3) {
                        return YES;
                    }
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            }
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                return NO;
            }
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                return NO;
            }
            if (textField.text.length > 5) {
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark -- 扫脸认证
-(void)scanFaceAction:(NSString *)state orderId:(NSString *)orderId{
    
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
            dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":orderId};
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
                

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
                if ([responseObject[@"flag"] isEqualToString:@"error"]) {
                    
                }
                [HUD removeFromSuperview];
                
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    [CYTSI otherShowTostWithString:responseObject[@"message"]];
                    if ([responseObject[@"message"] isEqualToString:@"认证成功"]){
                        if ([state isEqualToString:@"0"]) {
                    __weak typeof(self) weakSelf = self;
                    [AFRequestManager postRequestWithUrl:DRIVER_PICK_UP_PASSENGER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":self.orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"join_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],@"join_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"]} tost:YES special:0 success:^(id responseObject) {
                        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                            if (updatePriceTimer == nil) {
                                [weakSelf savePointAndPlanDistance];
                                updatePriceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(savePointAndPlanDistance) userInfo:nil repeats:YES];
                            }
                            buttonType = 1;
                            [bottomButton setTitle:@"到达上车地点" forState:UIControlStateNormal];
                            [weakSelf startDriveTakeUser];
                        }else{
                            [CYTSI otherShowTostWithString:@"请重试"];
                        }
                        
                    } failure:^(NSError *error) {

                    }];
                        }else{
                            [CYTSI otherShowTostWithString:@"抢单成功，可在首页列表查看"];
                        }
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


//清除之前的轨迹
-(void)clearAgoLine
{
    [self.mapView removeOverlay:self.takeUserCommonPolyline];
}


//结束导航
-(void)cancelGPSNavi
{
    daoHangButton.hidden=YES;
    bjButton.hidden = YES;
    //停止导航
    [self.driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

-(void)navBack
{
    [checkTimer invalidate];
    checkTimer=nil;
    
    [updatePriceTimer invalidate];
    updatePriceTimer=nil;
    //    [alertTimer invalidate];
    //    alertTimer=nil;
    
    //移除地图数据
    [self clearMapView];
    
    NSArray * vcArray=self.navigationController.viewControllers;
    for (ViewController * vc in vcArray) {
        
        if ([vc isKindOfClass:[ViewController class]]) {
            
            vc.isNeedReload=YES;
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    }
}

//移除地图数据
-(void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [checkTimer invalidate];
    checkTimer=nil;
    
    [updatePriceTimer invalidate];
    updatePriceTimer=nil;
    if (locationAnnotation != nil  && endAnnotation != nil) {
        [self.mapView removeAnnotations:@[locationAnnotation,endAnnotation]];
    }
    [self.mapView removeOverlay:self.takeUserCommonPolyline];
    [self.mapView removeOverlay:self.commonPolyline];
    
    
    [self.driveManager stopNavi];
    [self.takeUserManager stopNavi];
    
    [alertView removeFromSuperview];
    [singleAlertView removeFromSuperview];
    [orderView removeFromSuperview];
    
    self.locationManager.delegate=nil;
    self.driveManager.delegate=nil;
    self.takeUserManager.delegate=nil;
    self.mapView.delegate=nil;
    //    self.allowDriveManager=nil;
    
    [self.mapView removeFromSuperview];
    self.mapView=nil;
}

#pragma mark - 地图相关

//创建地图视图
-(void)creatMapView
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView = [DCYMapView shareMAMapView:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    self.mapView.mapType=MAMapTypeNavi;
    self.mapView.showsLabels=YES;
    self.mapView.showsBuildings=YES;
    self.mapView.delegate=self;
    self.mapView.rotateEnabled=NO;//此属性用于地图旋转手势的开启和关闭
    self.mapView.rotateCameraEnabled=NO;//此属性用于地图旋转旋转的开启和关闭
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    //定义用户小圆点
    [self changeUserLocationRepresentation];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.lm = [[AMapLocationManager alloc] init];
    self.lm.delegate = self;
    //
    if (self.submit_class == 2)
    {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    
    [self showLoading];
    [self startLocation];//开始定位
}

#pragma mark - 初始化地图代理等


-(AMapSearchAPI *)search
{
    if (!_search) {
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        
    }
    
    return _search;
}

-(AMapNaviDriveManager *)driveManager
{
    if (!_driveManager) {
        
        _driveManager = [AMapNaviDriveManager sharedInstance];
        //_driveManager = [AMapNaviDriveManager al]
        [_driveManager setDelegate:self];
        [_driveManager setPausesLocationUpdatesAutomatically:NO];
        [_driveManager setScreenAlwaysBright:YES];
        
    }
    
    return _driveManager;
}

-(AMapNaviDriveManager *)takeUserManager
{
    if (!_takeUserManager) {
        
        _takeUserManager = [AMapNaviDriveManager sharedInstance];
        [_takeUserManager setDelegate:self];
        [_takeUserManager setPausesLocationUpdatesAutomatically:NO];
        [_takeUserManager setScreenAlwaysBright:YES];
        
    }
    
    return _takeUserManager;
}

-(DriveMapViewController *)driveVC
{
    if (!_driveVC) {
        
        _driveVC=[[DriveMapViewController alloc]init];
        
    }
    
    return _driveVC;
}

-(DriveMapViewController *)takeUserDriveVC
{
    if (!_takeUserDriveVC) {
        
        _takeUserDriveVC=[[DriveMapViewController alloc]init];
        
    }
    
    return _takeUserDriveVC;
}

//定义用户小圆点
-(void)changeUserLocationRepresentation
{
    representation = [[MAUserLocationRepresentation alloc] init];
    
    representation.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    
    representation.showsHeadingIndicator = YES;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    
    representation.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
    
    //    representation.image = [UIImage imageNamed:@"arrow"]; ///定位图标, 与蓝色原点互斥
    
    [self.mapView updateUserLocationRepresentation:representation];
}

//用户位置更新的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //    double a=userLocation.coordinate.latitude;
    //    NSLog(@"用户位置更新：%.100f,%.100f",a,userLocation.coordinate.longitude);
    [self performSelector:@selector(setAgoCurrentLocation:) withObject:userLocation afterDelay:3];
    
    // 将设备的方向角度换算成弧度
    CGFloat headings = M_PI * userLocation.heading.magneticHeading / 180.0f;
    // 创建不断改变CALayer的transform属性的属性动画
    CABasicAnimation* anim = [CABasicAnimation
                              animationWithKeyPath:@"transform"];
    CATransform3D fromValue = userLocationView.layer.transform;
    // 设置动画开始的属性值
    anim.fromValue = [NSValue valueWithCATransform3D: fromValue];
    // 绕Z轴旋转heading弧度的变换矩阵
    CATransform3D toValue = CATransform3DMakeRotation(headings , 0 , 0 , 1);
    // 设置动画结束的属性
    anim.toValue = [NSValue valueWithCATransform3D: toValue];
    anim.duration = 0.35;
    anim.removedOnCompletion = YES;
    // 设置动画结束后znzLayer的变换矩阵
    userLocationView.layer.transform = toValue;
    // 为znzLayer添加动画
    [userLocationView.layer addAnimation:anim forKey:nil];
}

//设置上一秒的
-(void)setAgoCurrentLocation:(MAUserLocation *)userLocation
{
    //    NSLog(@"****8用户位置更新：%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.latitude);
    self.agoCurrentCoordinate=userLocation.coordinate;
}

//开始定位
-(void)startLocation
{
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout =2;
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            if (_orderState==0) {//刚抢完单进来定位失败时
                
                daoHangButton.hidden=NO;
                bjButton.hidden = NO;
                [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"定位失败"];
                
            }
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [self hidenLoading];
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
        
        self.currentCoordinate = location.coordinate;
        
        //添加司机大头针
        //添加结束位置大头针
        //        carAnnotation = [[MAAnimatedAnnotation alloc] init];
        //        carAnnotation.coordinate = location.coordinate;
        //        carAnnotation.title=@"我的位置";
        //        [self.mapView addAnnotation:carAnnotation];
        
        //添加订单起点的大头针
        locationAnnotation = [[MAPointAnnotation alloc] init];
        locationAnnotation.coordinate = self.userStartCoordinate;
        [self.mapView addAnnotation:locationAnnotation];
        locationAnnotation.lockedToScreen = NO;
        locationAnnotation.title=@"起点";
        //        locationAnnotation.lockedScreenPoint = CGPointMake(weakSelf.mapView.bounds.size.width / 2, weakSelf.mapView.bounds.size.height / 2) ;
        
        //添加结束位置大头针
        endAnnotation = [[MAPointAnnotation alloc] init];
        endAnnotation.coordinate = self.endCoordinate;
        endAnnotation.title=@"终点";
        [self.mapView addAnnotation:endAnnotation];
        
        NSLog(@"司机位置：%.14f,%.14f",location.coordinate.latitude,location.coordinate.longitude);
        NSLog(@"开始位置：%.14f,%.14f",self.userStartCoordinate.latitude,self.userStartCoordinate.longitude);
        NSLog(@"结束位置：%.14f,%.14f",self.endCoordinate.latitude,self.endCoordinate.longitude);
        
        //设置地图
        //        [weakSelf.mapView setZoomLevel:13 animated:YES];
        //        [weakSelf.mapView selectAnnotation:locationAnnotation animated:YES];
        //        [weakSelf.mapView setCenterCoordinate:self.userStartCoordinate animated:NO];
        
        [self hidenLoading];
        NSLog(@"_orderState_orderState_orderState_orderState_orderState%ld",_orderState);
        if (_orderState==0 || _orderState==1) {
            
            isOverDrawTakeUserLine=YES;
            [self.takeUserManager addDataRepresentative:self.takeUserDriveVC.driveView];
            [self.takeUserManager addDataRepresentative:self];
            //            [self creatAlertTimer];//创建导航提示定时器
            [self drawRoadTakeUser];//绘制接乘客的单子
        }
        
        /**********///进来的时候设置状态
        if (isSeted == NO && _isOrderList && isOverDrawTakeUserLine == NO) {
            
            //如果是从进行中的订单进来的（默认走到订单状态那一步）
            //            [self creatAlertTimer];//创建导航提示定时器
            
            [self defaultGoOrder];
            
            isSeted = YES;
            
        }
        
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        userLocationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"userview"];
        if (userLocationView == nil)
        {
            userLocationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userview"];
        }
        
        userLocationView.image = [UIImage imageNamed:@"move_car"];
        return userLocationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;//是否有下落动画
        annotationView.enabled = NO;
        
        //起点，终点的图标标注
        if (annotation == locationAnnotation) {
            annotationView.image = [UIImage imageNamed:@"map_start"];  //起点
            annotationView.centerOffset=CGPointMake(0, -22);
        }else if(annotation == endAnnotation) {
            annotationView.image = [UIImage imageNamed:@"map_end"];  //终点
            annotationView.centerOffset = CGPointMake(0, -22);
        }
        
        [self.locationManager startUpdatingLocation];
        
        return annotationView;
    }
    return nil;
}

//绘制去接乘客的路线
-(void)drawRoadTakeUser
{
    [self.takeUserManager stopNavi];
    
    double latitude;
    double longtitude;
    
    if (userLocationView==nil || userLocationView.annotation==nil) {
        
        latitude=self.currentCoordinate.latitude;
        longtitude=self.currentCoordinate.longitude;
        
    }else{
        
        latitude=userLocationView.annotation.coordinate.latitude;
        longtitude=userLocationView.annotation.coordinate.longitude;
        
    }
    
    //司机到乘客的位置
    AMapNaviPoint * startPoint =[AMapNaviPoint locationWithLatitude:latitude longitude:longtitude];
    AMapNaviPoint * endPoint   = [AMapNaviPoint locationWithLatitude:self.userStartCoordinate.latitude longitude:self.userStartCoordinate.longitude];
    
    if (self.agoCurrentCoordinate.latitude==0) {
        
        [self.takeUserManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                       endPoints:@[endPoint]
                                                       wayPoints:nil
                                                 drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
        
    } else {
        
        AMapNaviPoint * startOnePoint =[AMapNaviPoint locationWithLatitude:self.agoCurrentCoordinate.latitude longitude:self.agoCurrentCoordinate.longitude];
        
        [self.takeUserManager calculateDriveRouteWithStartPoints:@[startOnePoint,startPoint]
                                                       endPoints:@[endPoint]
                                                       wayPoints:nil
                                                 drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
        
    }
    
}

//刚进来直接导航去接乘客
-(void)startDriveTakeUser
{
    //开始导航去接乘客
    [self.takeUserManager stopNavi];
    [self.takeUserManager startGPSNavi];//开始导航
    //    [self.takeUserManager startEmulatorNavi];//开始模拟导航
    
    if (![self.navigationController.topViewController isKindOfClass:[DriveMapViewController class]]) {
        
        
        self.takeUserDriveVC.orderID = _orderID;
        self.takeUserDriveVC.orderState = _orderState;
        [self.navigationController pushViewController:self.takeUserDriveVC animated:NO];
        
        
    }
    
    __weak typeof (self) weakSelf = self;
    
    self.takeUserDriveVC.closeDrive = ^{
        
        daoHangButton.hidden=NO;
        bjButton.hidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
        
    };
    
    self.takeUserDriveVC.moreClicked = ^{
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已为您切换路线"];
        
        [weakSelf aginStartNavi];//重新导航
        
    };
    
    self.takeUserDriveVC.pauseClicked = ^{
        
        if (_orderState==0 || _orderState==1) {
            
            [weakSelf.takeUserManager pauseNavi];
            
        } else {
            
            [weakSelf.driveManager pauseNavi];
            
        }
        
    };
    
    self.takeUserDriveVC.resumeClicked = ^{
        
        if (_orderState==0 || _orderState==1) {
            
            [weakSelf.takeUserManager resumeNavi];
            
        } else {
            
            [weakSelf.driveManager resumeNavi];
            
        }
        
    };
}


//开始绘制轨迹
-(void)startDrawLine
{
    [self.takeUserManager stopNavi];
    [self.driveManager stopNavi];
    
    double latitude;
    double longtitude;
    
    if (userLocationView==nil || userLocationView.annotation==nil) {
        
        latitude=self.currentCoordinate.latitude;
        longtitude=self.currentCoordinate.longitude;
        
    }else{
        
        latitude=userLocationView.annotation.coordinate.latitude;
        longtitude=userLocationView.annotation.coordinate.longitude;
        
    }
    
    //订单的起点到终点
    AMapNaviPoint * startPoint = [AMapNaviPoint locationWithLatitude:latitude longitude:longtitude];//订单的起点
    AMapNaviPoint * endPoint   = [AMapNaviPoint locationWithLatitude:self.endCoordinate.latitude longitude:self.endCoordinate.longitude];
    
    if (self.agoCurrentCoordinate.latitude==0) {
        
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
        
    } else {
        
        AMapNaviPoint * startOnePoint = [AMapNaviPoint locationWithLatitude:self.agoCurrentCoordinate.latitude longitude:self.agoCurrentCoordinate.longitude];
        
        [self.driveManager calculateDriveRouteWithStartPoints:@[startOnePoint,startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
        
    }
    
}

//开始导航
-(void)startDrive
{
    [self.takeUserManager stopNavi];
    [self.driveManager stopNavi];
    [self.driveManager startGPSNavi];//开始导航
    //    [self.driveManager startEmulatorNavi];//开始模拟导航
    
    if (![self.navigationController.topViewController isKindOfClass:[DriveMapViewController class]]) {
        
        self.driveVC.orderID = _orderID;
        self.driveVC.orderState = _orderState;
        [self.navigationController pushViewController:self.driveVC animated:NO];
        
    }
    
    __weak typeof (self) weakSelf = self;
    
    self.driveVC.closeDrive = ^{
        
        daoHangButton.hidden = NO;
        bjButton.hidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
        
    };
    
    self.driveVC.moreClicked = ^{
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已为您切换路线"];
        [weakSelf aginStartNavi];//重新导航
        
    };
    
    self.driveVC.pauseClicked = ^{
        
        if (_orderState == 0 || _orderState == 1) {
            
            [weakSelf.takeUserManager pauseNavi];
            
        } else {
            
            [weakSelf.driveManager pauseNavi];
            
        }
        
    };
    
    self.driveVC.resumeClicked = ^{
        
        if (_orderState == 0 || _orderState == 1) {
            
            [weakSelf.takeUserManager resumeNavi];
            
        } else {
            
            [weakSelf.driveManager resumeNavi];
            
        }
        
    };
}


- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    
    //起点到终点
    //    if (driveManager == self.driveManager) {
    if (buttonType == 3) {
        //构造折线对象
        NSArray * array=driveManager.naviRoute.routeCoordinates;
        CLLocationCoordinate2D commonPolylineCoords[array.count];
        for (int i=0; i<array.count; i++) {
            
            AMapNaviPoint * navipoint=array[i];
            commonPolylineCoords[i].latitude=navipoint.latitude;
            commonPolylineCoords[i].longitude=navipoint.longitude;
            
        }
        
        self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
        //在地图上添加折线对象
        [_mapView addOverlay: self.commonPolyline];
        
        if (userLocationView.annotation==nil) {
            
            [self.mapView showAnnotations:@[locationAnnotation,endAnnotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        } else {
            
            [self.mapView showAnnotations:@[locationAnnotation,endAnnotation,userLocationView.annotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        }
        
        [self startDrive];//开始导航
        
    }
    
    //去接乘客的起点和终点
    if (buttonType == 1 || buttonType == 2) {
        
        //构造折线对象
        NSArray * array=driveManager.naviRoute.routeCoordinates;
        CLLocationCoordinate2D commonPolylineCoords[array.count];
        for (int i=0; i<array.count; i++) {
            
            AMapNaviPoint * navipoint=array[i];
            commonPolylineCoords[i].latitude=navipoint.latitude;
            commonPolylineCoords[i].longitude=navipoint.longitude;
            
        }
        
        self.takeUserCommonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
        //在地图上添加折线对象
        [_mapView addOverlay: self.takeUserCommonPolyline];
        
        if (userLocationView.annotation==nil) {
            
            [self.mapView setZoomLevel:15];
            [self.mapView showAnnotations:@[locationAnnotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        } else {
            
            [self.mapView showAnnotations:@[locationAnnotation,userLocationView.annotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        }
        
        if (_orderState != 2) {
            [self startDriveTakeUser];
        }
    }
}


//重新导航
-(void)aginStartNavi
{
    NSLog(@"订单状态：%ld",(long)_orderState);
    
    if (_orderState==1 || _orderState==0) {
        if (self.takeUserCommonPolyline) {
            
            [self.mapView removeOverlay:self.takeUserCommonPolyline];
        }
        
        [self.takeUserManager stopNavi];
        
    } else {
        
        [self.mapView removeOverlay:self.commonPolyline];
        [self.driveManager stopNavi];
        
        
        //构造折线对象
        NSArray * array=_driveManager.naviRoute.routeCoordinates;
        CLLocationCoordinate2D commonPolylineCoords[array.count];
        for (int i=0; i<array.count; i++) {
            
            AMapNaviPoint * navipoint=array[i];
            commonPolylineCoords[i].latitude=navipoint.latitude;
            commonPolylineCoords[i].longitude=navipoint.longitude;
            
        }
        
        self.takeUserCommonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
        //在地图上添加折线对象
        [_mapView addOverlay: self.takeUserCommonPolyline];
        
        if (userLocationView.annotation==nil) {
            
            [self.mapView setZoomLevel:15];
            [self.mapView showAnnotations:@[locationAnnotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        } else {
            
            [self.mapView showAnnotations:@[locationAnnotation,userLocationView.annotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
            
        }
        
    }
}

#pragma mark - 导航代理方法
/**
 * @brief 发生错误时,会调用代理的此方法
 * @param driveManager 驾车导航管理类
 * @param error 错误信息
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    
}

/**
 * @brief 驾车路径规划失败后的回调函数
 * @param error 错误信息,error.code参照 AMapNaviCalcRouteState .
 * @param driveManager 驾车导航管理类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    //    isAginDrawLine=NO;
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"驾车路径规划失败，重新规划"];
    [self aginStartNavi];
}

/**
 * @brief 启动导航后回调函数
 * @param naviMode 导航类型，参考 AMapNaviMode .
 * @param driveManager 驾车导航管理类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    //    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"启动导航"];
}

/**
 * @brief 出现偏航需要重新计算路径时的回调函数.偏航后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理.
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已为您切换路线"];
    
    [self aginStartNavi];//重新导航
    
}

/**
 * @brief 前方遇到拥堵需要重新计算路径时的回调函数.拥堵后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理.
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    [self aginStartNavi];//重新导航
}

/**
 * @brief 导航到达某个途经点的回调函数
 * @param driveManager 驾车导航管理类
 * @param wayPointIndex 到达途径点的编号，标号从1开始
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    
}

/**
 * @brief SDK需要实时的获取是否正在进行导航信息播报，以便SDK内部控制 "导航播报信息回调函数" 的触发时机，避免出现下一句话打断前一句话的情况
 * @param driveManager 驾车导航管理类
 * @return 返回当前是否正在进行导航信息播报,如一直返回YES，"导航播报信息回调函数"就一直不会触发，如一直返回NO，就会出现语句打断情况，所以请根据实际情况返回。
 */
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

/**
 * @brief 导航播报信息回调函数,此回调函数需要和driveManagerIsNaviSoundPlaying:配合使用
 * @param driveManager 驾车导航管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考 AMapNaviSoundType .
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"导航播报：%@",soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

/**
 * @brief 模拟导航到达目的地停止导航后的回调函数
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    
}

/**
 * @brief 导航到达目的地后的回调函数
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    [checkTimer invalidate];
    checkTimer=nil;
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已到达目的地附近，本次导航结束"];
    if (_orderState==1 || _orderState==0) {
        
        [self.takeUserManager stopNavi];
        
    } else {
        
        [self.driveManager stopNavi];
        
    }
    //    [self removeAlertTimer];
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

#pragma mark - MAMapViewDelegate

//地图上覆盖物的渲染，可以设置路径线路的宽度，颜色等
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    
    //    if (upDateDriverLocationTimer!=nil) {
    //
    //        return nil;
    //    }
    
    [self clearAgoLine];
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        
        return polylineRenderer;
    }
    
    return nil;
}

/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"AppointAirListViewController --连续更新车速%f",location.speed);
    //    carAnnotation.coordinate=location.coordinate;
    carSpeed=location.speed;
    
    driverTimeTap=[location.timestamp timeIntervalSince1970];
    //   NSLog(@"======================%f",driverTimeTap);
    driverCourse=location.course;
    
    //更新司机当前位置
    self.currentCoordinate = location.coordinate;
    driverLong=location.coordinate.longitude;
    driverLat=location.coordinate.latitude;
    
}

//持续更新司机位置的定时器
-(void)updateDriverLocation
{
    
//    double   latitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] doubleValue];
//    double  longtitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] doubleValue];
//    NSLog(@"DRIVER_UPDATE_VEHICLE_LOCATION%f------%f",latitude,longtitude);
//    NSString *urlStr;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
//        urlStr = DRIVER_INTERCITY_UPDATE_VEHICLE_LOCATION;
//    }else {//其他司机
//        urlStr = DRIVER_UPDATE_VEHICLE_LOCATION;
//    }
//    //上传服务器司机的位置
//    [AFRequestManager postRequestWithUrl:urlStr params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],@"driver_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"],@"speed":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationSpeed"],@"angle":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationCourse"],@"stime":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationStime"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {
//    } failure:^(NSError *error) {
//        NSLog(@"DRIVER_UPDATE_VEHICLE_LOCATION%f------%f",latitude,longtitude);
//    }];
//    
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
//
//        return;
//
//    }
//
//    //计算两点间的距离
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"]==nil) {
//
//        return;
//    }
//
//    //车速为0的时候不计算距离
//    if (carSpeed<=0) {
//
//        return;
//    }
//
//    //根据订单状态判断是否需要开始计费
//    if (_orderState==3) {
//        double newLatitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"] doubleValue];
//        double newLongitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_longitude"] doubleValue];
//
//        //计算两点间的直线距离
//        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(newLatitude,newLongitude));
//        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longtitude));
//        //2.计算距离
//        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2)/1000+[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"] doubleValue];
//        NSString * distanceStr=[NSString stringWithFormat:@"%f",distance];
//
//        CYLog(@"计算的距离：%@",distanceStr);
//
//        //保存最新点及距离
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longtitude] forKey:@"new_longitude"];
//        [[NSUserDefaults standardUserDefaults] setObject:distanceStr forKey:@"new_distance"];
//    }
//
}

#pragma mark - 司机实时更新位置操作

//创建开始更新定时器
-(void)creatUpdateDriverLocationTimer
{
    
}


//检查导航是否出问题了
-(void)checkNaviIsError
{
    
    [self aginStartNavi];//重新导航
}

#pragma mark - 导航返回数据
/**
 * @brief 路径信息更新回调
 * @param driveManager 驾车导航管理类
 * @param naviRoute 路径信息,参考 AMapNaviRoute 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviRoute:(nullable AMapNaviRoute *)naviRoute
{
    //    NSLog(@"所有形状点：%@",naviRoute.routeCoordinates);
}

/**
 * @brief 导航信息更新回调
 * @param driveManager 驾车导航管理类
 * @param naviInfo 导航信息,参考 AMapNaviInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo
{
    
    if (isNearBy==NO && naviInfo.routeRemainDistance<100 && naviInfo.routeRemainDistance>10) {
        
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已到达目的地附近"];
        isNearBy=YES;
        
    }
    
    [checkTimer invalidate];
    checkTimer=nil;
    checkTimer=[NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(checkNaviIsError) userInfo:nil repeats:YES];
    
}
/**
 * @brief 自车位置更新回调 (since 5.0.0，模拟导航和GPS导航的自车位置更新都会走此回调)
 * @param driveManager 驾车导航管理类
 * @param naviLocation 自车位置信息,参考 AMapNaviLocation 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation
{
    
}
/**
 * @brief 需要显示车道信息时的回调.可通过 UIImage *CreateLaneInfoImageWithLaneInfo(NSString *laneBackInfo, NSString *laneSelectInfo); 方法创建车道信息图片
 * 0-直行; 1-左转; 2-直行和左转; 3-右转;
 * 4-直行和右转; 5-左转掉头; 6-左转和右转; 7-直行和左转和右转;
 * 8-右转掉头; 9-直行和左转掉头; a-直行和右转掉头; b-左转和左转掉头;
 * c-右转和右转掉头; d-左侧变宽直行; e-左侧变宽左转和左转掉头; f-保留;
 *
 * @param driveManager 驾车导航管理类
 * @param laneBackInfo 车道背景信息，例如：@"1|0|0|0|3|f|f|f"，表示当前道路有5个车道，分别为"左转-直行-直行-直行-右转"
 * @param laneSelectInfo 车道前景信息，例如：@"f|0|0|0|f|f|f|f"，表示选择当前道路的2、3、4三个直行车道
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager showLaneBackInfo:(NSString *)laneBackInfo laneSelectInfo:(NSString *)laneSelectInfo
{
    
}

/**
 * @brief 路况光柱信息更新回调
 * @param driveManager 驾车导航管理类
 * @param trafficStatus 路况光柱信息数组,参考 AMapNaviTrafficStatus 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTrafficStatus:(nullable NSArray<AMapNaviTrafficStatus *> *)trafficStatus
{
    
}

#pragma mark - 保存最新路径点及计算行驶距离
//刚进来时请求最新的距离时间和价钱
-(void)firstJoinUpdatePrice
{
    //根据距离请求服务器价格
    NSLog(@"driver_id=%@&order_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],_orderID);
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_OBTAIN_JOURNEY_ORDER_MILE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {
        
        PriceDistanceModel * priceModel = [PriceDistanceModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:priceModel.real_journey_mile forKey:@"new_distance"];
        
        [updatePriceTimer fire];
        
    } failure:^(NSError *error) {
        
    }];
}

//保存最新路径点及计算行驶距离
-(void)savePointAndPlanDistance
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"]==nil) {
        
        return;
    }
    
    NSString * distanceStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"]];
    NSLog(@" 根据距离请求服务器价格  ============= _orderID = %@",_orderID);
    //根据距离请求服务器价格
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_CALC_JOURNEY_FEE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"journey_mile":distanceStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {
        
        PriceDistanceModel * priceModel = [PriceDistanceModel mj_objectWithKeyValues:responseObject[@"data"]];
        leftPriceView.bottomLable.text=[NSString stringWithFormat:@"%.2f公里",[priceModel.real_journey_mile floatValue]];
        middlePriceView.bottomLable.text=[NSString stringWithFormat:@"%d分钟",[priceModel.real_journey_time intValue]];
        rightPriceView.bottomLable.text=[NSString stringWithFormat:@"%.2f元",[priceModel.real_journey_fee floatValue]];
        
        self.journey_fee=[NSString stringWithFormat:@"%.2f",[priceModel.journey_fee floatValue]];//网约车费用
        
        [self setPriceViewText];
        
    } failure:^(NSError *error) {
        
    }];
    
}

//结束订单的时候计算最终距离及订单金额
-(void)setPriceEndOrder:(CYAlertView *)theAlertView
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"]==nil) {
        
        return;
    }

    double latitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] doubleValue];
    double longitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] doubleValue];
    
    
    double newLatitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"] doubleValue];
    double newLongitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_longitude"] doubleValue];
    
    //计算两点间的直线距离
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(newLatitude,newLongitude));
    //    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2)/1000+[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"] doubleValue];
    NSString * distanceStr=[NSString stringWithFormat:@"%f",distance];
    
    CYLog(@"计算的距离：%@",distanceStr);
    
    
    //根据距离请求服务器价格
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_CALC_JOURNEY_FEE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"journey_mile":distanceStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {
        
        PriceDistanceModel * priceModel = [PriceDistanceModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //网约车费用
        theAlertView.moneyTextFiled.text=[NSString stringWithFormat:@"%.2f",[priceModel.journey_fee floatValue]];
        theAlertView.moneyStr=[NSString stringWithFormat:@"%.2f",[priceModel.journey_fee floatValue]];
        
    } failure:^(NSError *error) {
        
    }];
    
    //保存最新点及距离
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longitude] forKey:@"new_longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:distanceStr forKey:@"new_distance"];
}
//结束订单的时候计算最终距离及订单金额
-(void)setAccountPriceEndOrder:(AccountView *)theAlertView
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"]==nil) {
        
        return;
    }
    
    
    double latitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"] doubleValue];
    double longitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"] doubleValue];
    
    
    double newLatitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_latitude"] doubleValue];
    double newLongitude=[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_longitude"] doubleValue];
    
    //计算两点间的直线距离
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(newLatitude,newLongitude));
    //    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2)/1000+[[[NSUserDefaults standardUserDefaults] objectForKey:@"new_distance"] doubleValue];
    NSString * distanceStr=[NSString stringWithFormat:@"%f",distance];
    
    CYLog(@"计算的距离：%@",distanceStr);
    
    
    //根据距离请求服务器价格
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_CALC_JOURNEY_FEE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"journey_mile":distanceStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {
        
        PriceDistanceModel * priceModel = [PriceDistanceModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //网约车费用
        theAlertView.moneyLB.text=[NSString stringWithFormat:@"¥ %.2f",[priceModel.journey_fee floatValue]];
        
    } failure:^(NSError *error) {
        
    }];
    
    //保存最新点及距离
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",latitude] forKey:@"new_latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.14f",longitude] forKey:@"new_longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:distanceStr forKey:@"new_distance"];
}
//移除保存数据
-(void)removeNewPointAndDistance
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_latitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_longitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_distance"];
}

#pragma mark - 加载框的出现和消失

//显示加载框
-(void)showLoading
{
    //初始化进度框，置于当前的View当中
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    HUD = [[MBProgressHUD alloc] initWithView:window];
    
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
}

//隐藏加载框
-(void)hidenLoading
{
    [HUD removeFromSuperview];
}

#pragma mark - 摇一摇相关操作
//创建摇一摇按钮视图
- (void)creatShakeButtonView
{
    shakeButtonView = [[UIView alloc]init];
    shakeButtonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shakeButtonView];
    [shakeButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.mas_equalTo(DeviceWidth);
        make.right.equalTo(self.view);
        make.height.equalTo(@104);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [shakeButtonView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.height.equalTo(@44);
        make.right.equalTo(shakeButtonView.mas_right).with.offset(-15);
    }];
    
    UIView *circleView = [[UIView alloc]init];
    circleView.backgroundColor = [CYTSI colorWithHexString:@"#e82a2a"];
    circleView.layer.cornerRadius = 5;
    circleView.layer.masksToBounds = YES;
    [bgView addSubview:circleView];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.centerY.equalTo(bgView);
        make.width.and.height.equalTo(@10);
    }];
    
    shakePursonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shakePursonButton setTitle:@"请输入目的地" forState:UIControlStateNormal];
    [shakePursonButton setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    shakePursonButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [shakePursonButton addTarget:self action:@selector(shakePursonButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:shakePursonButton];
    [shakePursonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(5);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.right.equalTo(bgView.mas_right).with.offset(-30);
    }];
    
    shakeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shakeSureButton setTitle:@"确认" forState:UIControlStateNormal];
    shakeSureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    shakeSureButton.layer.cornerRadius = 3;
    shakeSureButton.layer.masksToBounds = YES;
    shakeSureButton.enabled = NO;
    shakeSureButton.backgroundColor = [CYTSI colorWithHexString:@"#929292"];
    [shakeSureButton addTarget:self action:@selector(shakeSureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [shakeButtonView addSubview:shakeSureButton];
    [shakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(shakeButtonView.mas_right).with.offset(-15);
        make.height.equalTo(@44);
        make.top.equalTo(bgView.mas_bottom).with.offset(8);
    }];
}

//输入摇一摇目的地按钮点击事件
- (void)shakePursonButtonClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        topView.frame=CGRectMake(0, 0, DeviceWidth, 64);
    }];
    if (![shakePursonButton.titleLabel.text isEqualToString:@"请输入目的地"]) {
        searchFiled.text=shakePursonButton.titleLabel.text;
        //根据关键字搜索
        [self searchWithKeyWords:searchFiled.text];
    }else{
        searchFiled.text=@"";
    }
    [searchFiled becomeFirstResponder];
}

//确定摇一摇目的地按钮点击事件
- (void)shakeSureButtonClicked
{
    addressView.endStr = self.endAddress;
    endAnnotation.coordinate = self.endCoordinate;
    
    
    [shakeButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DeviceWidth);
    }];
    _orderState=2;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)_orderState],@"orderState", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
    self.title=@"等待乘客上车";
    [bottomButton setTitle:@"开始计费" forState:UIControlStateNormal];
    buttonType=2;
}

#pragma mark - SearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //        NSLog(@"根据关键字查询的地点：%@",response.pois[0].name);
    [searchResultArray removeAllObjects];
    [searchResultArray addObjectsFromArray:response.pois];
    
    if (searchResultArray.count==0) {
        myTableView.hidden=YES;
    } else {
        myTableView.hidden=NO;
    }
    
    [myTableView reloadData];
    
}

//创建顶部视图
-(void)creatTopView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    topView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, 64)];
    topView.backgroundColor=[UIColor blackColor];
    [window addSubview:topView];
    
    UIButton * cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).with.offset(-12);
        make.bottom.equalTo(topView.mas_bottom).with.offset(-11);
        make.height.equalTo(@22);
        make.width.equalTo(@40);
    }];
    
    searchFiled=[[UITextField alloc]init];
    searchFiled.text=@"";
    searchFiled.placeholder=@"你要去哪儿";
    searchFiled.font=[UIFont systemFontOfSize:14];
    searchFiled.returnKeyType=UIReturnKeySearch;
    searchFiled.backgroundColor=[CYTSI colorWithHexString:@"#f1f1f1"];
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    leftView.backgroundColor=[CYTSI colorWithHexString:@"#f1f1f1"];
    searchFiled.leftView=leftView;
    searchFiled.leftViewMode=UITextFieldViewModeAlways;
    
    searchFiled.layer.cornerRadius=15;
    searchFiled.layer.masksToBounds=YES;
    searchFiled.delegate=self;
    
    [searchFiled addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    [topView addSubview:searchFiled];
    [searchFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(cancleButton.mas_centerY);
        make.height.equalTo(@30);
        make.right.equalTo(cancleButton.mas_left).with.offset(-18);
    }];
    
}

//创建搜索结果视图
-(void)creatReslutView
{
    blackView=[[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight)];
    blackView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:blackView];
    
    UIView * resultView=[[UIView alloc]initWithFrame:CGRectMake(12, 8, DeviceWidth-24, DeviceHeight-16-64)];
    resultView.backgroundColor=[UIColor whiteColor];
    resultView.layer.cornerRadius=3;
    resultView.layer.masksToBounds=YES;
    [blackView addSubview:resultView];
    
    UIImageView * noImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shouye_no"]];
    [resultView addSubview:noImageView];
    [noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(resultView.mas_centerX);
        make.top.equalTo(@100);
        make.height.and.width.equalTo(@90);
    }];
    
    UILabel * noLable=[[UILabel alloc]init];
    noLable.text=@"暂无结果，换个词试试吧~";
    noLable.textColor=[CYTSI colorWithHexString:@"#767676"];
    noLable.textAlignment=NSTextAlignmentCenter;
    noLable.font=[UIFont systemFontOfSize:12];
    [resultView addSubview:noLable];
    [noLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resultView.mas_left);
        make.right.equalTo(resultView.mas_right);
        make.height.equalTo(@17);
        make.top.equalTo(noImageView.mas_bottom).with.offset(14);
    }];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth-24, DeviceHeight-16-64) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [resultView addSubview:myTableView];
    
    //    //设置下拉刷新和上拉加载
    //    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    //    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
}
#pragma mark - UITextFiled 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchFiled resignFirstResponder];
    
    return YES;
}

-(void)textFieldChangeText:(UITextField *)textField
{
    if (textField.text!=nil && ![textField.text isEqualToString:@""]) {
        
        [self searchWithKeyWords:textField.text];
        
    }
}

//根据关键字搜索
-(void)searchWithKeyWords:(NSString *)keywords
{
    NSString *currentCity = @"天津市";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"current_city"] != nil)
    {
        currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_city"];
    }
    [_search cancelAllRequests];
    AMapPOIKeywordsSearchRequest * request=[[AMapPOIKeywordsSearchRequest alloc]init];
    request.city=currentCity;
    request.keywords=keywords;
    request.cityLimit = YES;
    [_search AMapPOIKeywordsSearch:request];
    
    [UIView animateWithDuration:0.3 animations:^{
        blackView.frame=CGRectMake(0, 64, DeviceWidth, DeviceHeight);
    }];
}

//顶部输入框取消按钮点击事件
-(void)cancleButtonClicked
{
    [searchFiled resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        topView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, 64);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        blackView.frame=CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight);
    }];
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouYeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"shouyecell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ShouYeTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    AMapPOI * poi=searchResultArray[indexPath.row];
    cell.nameLable.text=poi.name;
    cell.detailNameLable.text=poi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancleButtonClicked];
    
    AMapPOI * poi=searchResultArray[indexPath.row];
    
    [shakePursonButton setTitle:poi.name forState:UIControlStateNormal];
    [shakePursonButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    shakeSureButton.backgroundColor = [CYTSI colorWithHexString:@"#386ac6"];
    shakeSureButton.enabled = YES;
    
    self.endCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);//更新终点经纬度
    self.endAddress = poi.name;
    addressView.endStr = self.endAddress;
}

//返回司机经纬度
- (NSDictionary *)driverLocation
{
    double latitude;
    double longtitude;
    
    if (userLocationView==nil || userLocationView.annotation==nil) {
        
        latitude=self.currentCoordinate.latitude;
        longtitude=self.currentCoordinate.longitude;
        
    }else{
        
        latitude=userLocationView.annotation.coordinate.latitude;
        longtitude=userLocationView.annotation.coordinate.longitude;
        
    }
    
    NSString *latStr = [NSString stringWithFormat:@"%.14f",latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%.14f",longtitude];
    
    return @{@"lat":latStr,@"lng":lngStr};
}
#pragma mark - YuYueAndAirPortViewDelegat

-(void)didClickCanCelbtn:(NSString *)order_id{
    
    CancelTripViewController * vc=[[CancelTripViewController alloc]init];
    vc.orderID = order_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//请求司机信息
-(void)creatdriverOnline
{
   
}
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
   if ([btnTitle isEqualToString:@"确定"]) {
       [self.navigationController popViewControllerAnimated:YES];
   }
}

@end


