//
//  TripDetailViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "TripDetailViewController.h"
#import "OrderDetailModel.h"
#import "DriverLocationModel.h"
#import "ViewController.h"
#import "CharteredViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "DCYMapView.h"
#import "ExpenseDetailViewController.h"
#import "CancelTripViewController.h"
#import "YuYueAndAirPortView.h"

#import "CharteredViewController.h"


@interface TripDetailViewController () <MAMapViewDelegate,
AMapNaviDriveManagerDelegate,UITextViewDelegate,YuYueAndAirPortViewDelegat>

{
    UIView * blackView;//评价背景黑视图
    UIView * pingJiaView;//评价视图
    UIButton * pingButton;//评价按钮
    NSString * pingStar;//评价星级
    
    //弹出的评价视图
    UIImageView * pingHeadImageView;
    UILabel * pingDriverLable;
    UILabel * pingCompanyLable;
    UITextView * myTextView;//评价输入框
    UILabel * placeHolderLable;
    
    OrderDetailModel * orderDetail;
    
    MAPointAnnotation *locationAnnotation;//起点的大头针
    MAPointAnnotation *endAnnotation;//终点的大头针
    
    NSMutableArray *thePointArray;
}

@property (strong, nonatomic) DCYMapView * mapView;//地图;
//@property (strong, nonatomic) MAMapView * mapView;//地图;
@property (nonatomic,strong) MAPolyline * commonPolyline;//轨迹（折现）
@property (nonatomic,weak) AMapNaviDriveManager * driveManager;//轨迹管理
@property (nonatomic,strong) YuYueAndAirPortView * yuyueAndAirView;//预约和接机View


@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;//箭头
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//费用明细
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;//竖线

@property (strong, nonatomic) IBOutlet UILabel *priceLable;//钱

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLineCons;

@end

@implementation TripDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"行程详情";
    
    thePointArray = [[NSMutableArray alloc]init];
    
    //适配x
    if (DeviceHeight>737) {
        self.topLine.constant = 64+24;
    }
    
    [self setUpNav];//设置导航栏
    
    [self creatMainView];//创建主要视图
    [self creatPingJiaView];//创建评价视图
    
    self.bottomBgView.layer.cornerRadius=3;
    self.bottomBgView.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius=30;
    self.headImageView.layer.masksToBounds=YES;
    self.phoneButton.layer.cornerRadius=3;
    self.phoneButton.layer.masksToBounds=YES;
    
    self.pingJiaButton.hidden=YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车
        self.moneyLabel.hidden = YES;
        self.lineLabel.hidden = YES;
        self.arrowImage.hidden = YES;
        self.priceLineCons.constant = 70;
    }else{//非包车
        self.moneyLabel.hidden = NO;
        self.lineLabel.hidden = NO;
        self.arrowImage.hidden = NO;
        self.priceLineCons.constant = 10;
    }
    [self setUpMapView];//设置显示地图
    [self creatHttp];//请求数据
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
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    if (_isSuccess) {//成功
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车
            NSArray *vcArray = self.navigationController.viewControllers;
            for (CharteredViewController *vc in vcArray) {
                
                if ([vc isKindOfClass:[CharteredViewController class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{//非包车
            NSArray *vcArray = self.navigationController.viewControllers;
            for (ViewController *vc in vcArray) {
                
                if ([vc isKindOfClass:[ViewController class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    } else {//不成功
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//请求数据
-(void)creatHttp
{
    NSString *urlStr;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
        urlStr = DRIVER_INTERCITY_JOURNEY_ORDER_DETAIL;
    }else {//其他司机
        urlStr = DRIVER_JOURNEY_ORDER_DETAIL_INFO;
    }
    __weak typeof(self) weakSelf = self;
    [AFRequestManager postRequestWithUrl:urlStr params:@{@"order_id":_orderID,@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [OrderDetailModel mj_setupObjectClassInArray:^NSDictionary *{
            
            return @{@"locus_point":@"DriverLocationModel"};
            
        }];
        
        orderDetail=[OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        self.title=orderDetail.state_name;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]){//包车
            _startLable.text=[NSString stringWithFormat:@"%@:%@",orderDetail.start_city_name,orderDetail.start_site_name];
            _endLable.text=[NSString stringWithFormat:@"%@:%@",orderDetail.end_city_name,orderDetail.end_site_name];
        }else{//非包车
            _startLable.text=orderDetail.start_address;
            _endLable.text=orderDetail.end_address;
        }
        if (orderDetail.journey_state == 11) {
            weakSelf.yuyueAndAirView.orderModel = orderDetail;
            weakSelf.phoneButton.hidden = YES;
            weakSelf.bottomBgView.hidden = YES;
        }else{//其他状态
         if (orderDetail.driver_appraise==1) {
             _pingJiaLable.text=@"已评价";
             _pingJiaButton.hidden=YES;
             [_starView setViewWithNumber:orderDetail.driver_star width:14 space:2 enable:NO];
         } else {
             _pingJiaLable.text=@"未评价";
             _pingJiaButton.hidden=NO;
             if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车
               
                 if (orderDetail.journey_state!=3) {//3为结束行程
                     _pingJiaButton.hidden=YES;
                 }
             }else{//非包车
                 
                 if (orderDetail.journey_state!=5) {//3为结束行程
                     _pingJiaButton.hidden=YES;
                 }
             }
            
         }
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",orderDetail.m_head]] placeholderImage:[UIImage imageNamed:@"default_header"]];
            self.idCardLB.text = [NSString stringWithFormat:@"身份证号:%@",orderDetail.m_card_number];
//            NSLog(@"orderDetail.m_head ========= %@",orderDetail.m_head);
         _driverNumberLable.text=orderDetail.passenger_name;
        
         if ([orderDetail.remark isEqualToString:@""] || orderDetail.remark == nil) {
             _remarkLB.text = @"备注：";
         }else{
             _remarkLB.text = [NSString stringWithFormat:@"备注：%@",orderDetail.remark];
         }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车
                _priceLable.text=[NSString stringWithFormat:@"¥%@",orderDetail.driver_price];
            }else{//非包车
                _priceLable.text=[NSString stringWithFormat:@"¥%@",orderDetail.journey_fee];
         
            }
         
         //弹出的评价视图
         [pingHeadImageView sd_setImageWithURL:[NSURL URLWithString:orderDetail.m_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
         pingDriverLable.text=[NSString stringWithFormat:@"%@",orderDetail.passenger_name];
         
     }
       
        [self addAnnation];//添加开始结束位置大头针
        
    } failure:^(NSError *error) {
        
    }];
}

//创建主要视图
-(void)creatMainView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailAction)];
    [self.selectView addGestureRecognizer:tap];
}
//费用明细点击事件
-(void)detailAction{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {
        return;
    }
    ExpenseDetailViewController *edVC = [[ExpenseDetailViewController alloc] init];
    edVC.order_id = self.orderID;
    [self.navigationController pushViewController:edVC animated:YES];
}
//创建评价视图
-(void)creatPingJiaView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    blackView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    blackView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    
    UIButton * hidenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    hidenButton.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [hidenButton addTarget:self action:@selector(hidenButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:hidenButton];
    
    pingJiaView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132)];
    pingJiaView.backgroundColor=[UIColor whiteColor];
    pingJiaView.layer.cornerRadius=5;
    [window addSubview:pingJiaView];
    
    pingHeadImageView=[[UIImageView alloc]init];
    pingHeadImageView.layer.cornerRadius=33;
    pingHeadImageView.layer.masksToBounds=YES;
//    pingHeadImageView.backgroundColor=[UIColor orangeColor];
    [pingJiaView addSubview:pingHeadImageView];
    [pingHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-25);
        make.centerX.equalTo(pingJiaView.mas_centerX);
        make.width.and.height.equalTo(@66);
    }];
    
    pingDriverLable=[[UILabel alloc]init];
    pingDriverLable.text=@"吴师傅·津E28992";
    pingDriverLable.font=[UIFont systemFontOfSize:14];
    pingDriverLable.textAlignment=NSTextAlignmentCenter;
    [pingJiaView addSubview:pingDriverLable];
    [pingDriverLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pingJiaView.mas_centerX);
        make.top.equalTo(pingHeadImageView.mas_bottom).with.offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    pingCompanyLable=[[UILabel alloc]init];
    pingCompanyLable.text=@"天津XXX出租车有限公司";
    pingCompanyLable.hidden=YES;
    pingCompanyLable.font=[UIFont systemFontOfSize:11];
    pingCompanyLable.textColor=[CYTSI colorWithHexString:@"#999999"];
    pingCompanyLable.textAlignment=NSTextAlignmentCenter;
    [pingJiaView addSubview:pingCompanyLable];
    [pingCompanyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pingJiaView.mas_centerX);
        make.top.equalTo(pingDriverLable.mas_bottom).with.offset(2);
        make.width.equalTo(@200);
        make.height.equalTo(@16);
    }];
    
    CYStarView * pingStarView=[[CYStarView alloc]init];
    [pingStarView setViewWithNumber:0 width:38 space:7 enable:YES];
    [pingJiaView addSubview:pingStarView];
    [pingStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pingCompanyLable.mas_bottom).with.offset(24);
        make.width.equalTo(@218);
        make.height.equalTo(@38);
        make.centerX.equalTo(pingJiaView.mas_centerX);
    }];
    
    //星星按钮点击了
    pingStarView.starButtonClicked = ^(NSInteger index) {
        
        pingButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
        pingButton.enabled=YES;
        CYLog(@"第%ld个星星点击了",(long)index);
        pingStar=[NSString stringWithFormat:@"%ld",(long)index];
        
    };
    
    pingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pingButton setTitle:@"发表评价" forState:UIControlStateNormal];
    pingButton.backgroundColor=[CYTSI colorWithHexString:@"#a5a5a5"];
    pingButton.enabled=NO;
    pingButton.layer.cornerRadius=5;
    pingButton.layer.masksToBounds=YES;
    pingButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [pingButton addTarget:self action:@selector(pingJiaButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [pingJiaView addSubview:pingButton];
    [pingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.height.equalTo(@44);
        make.right.equalTo(pingJiaView.mas_right).with.offset(-24);
        make.bottom.equalTo(pingJiaView.mas_bottom).with.offset(-10);
    }];
    
    myTextView=[[UITextView alloc]init];
    myTextView.delegate=self;
    myTextView.layer.cornerRadius=3;
    myTextView.layer.masksToBounds=YES;
    myTextView.backgroundColor=[CYTSI colorWithHexString:@"#eeeeee"];
    [pingJiaView addSubview:myTextView];
    [myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pingButton.mas_top).with.offset(-14);
        make.left.equalTo(@16);
        make.right.equalTo(pingJiaView.mas_right).with.offset(-16);
        make.height.equalTo(@132);
    }];
    
    placeHolderLable=[[UILabel alloc]init];
    placeHolderLable.textColor=[CYTSI colorWithHexString:@"#999999"];
    placeHolderLable.font=[UIFont systemFontOfSize:12];
    placeHolderLable.text=@"请输入...";
    [pingJiaView addSubview:placeHolderLable];
    [placeHolderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@23);
        make.top.equalTo(myTextView.mas_top).with.offset(7);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==myTextView) {
        if ([myTextView.text length] == 0) {
            [placeHolderLable setHidden:NO];
        }else{
            [placeHolderLable setHidden:YES];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    if (textView.text.length>=200 && ![text isEqualToString:@""]) {
        
        [CYTSI otherShowTostWithString:@"最多输入200字"];
        return NO;
    }
    
    return YES;
}

//联系用户按钮点击事件
- (IBAction)phoneButtonClicked:(id)sender
{
    if ([orderDetail.passenger_phone isEqualToString:@""]) {
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
        [CYTSI callPhoneStr:orderDetail.passenger_phone withVC:self];
    }
}

//评价按钮点击事件
-(void)pingJiaButtonClicked
{
    
    NSString *urlStr;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
        urlStr = DRIVER_INTERCITY_DRIVER_APPRAISE;
    }else {//其他司机
        urlStr = DRIVER_JOURNEYORDER_DRIVER_APPRAISE;
    }
    [AFRequestManager postRequestWithUrl:urlStr params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_star":pingStar,@"driver_reason":myTextView.text,@"order_id":orderDetail.order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        //隐藏评价视图
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        blackView.frame=CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height);
        pingJiaView.frame=CGRectMake(DeviceWidth, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132);
        
        NSArray *vcArray = self.navigationController.viewControllers;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
            for (CharteredViewController *vc in vcArray)
            {
                if ([vc isKindOfClass:[CharteredViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }else {//其他司机
            for (ViewController *vc in vcArray)
            {
                if ([vc isKindOfClass:[ViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
       
        
    } failure:^(NSError *error) {
        
    }];
}

//隐藏评价视图
-(void)hidenButtonClicked
{
    //隐藏评价视图
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    blackView.frame=CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height);
    pingJiaView.frame=CGRectMake(DeviceWidth, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132);
}

- (IBAction)pingJiaButtonClicked:(UIButton *)sender
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    blackView.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        
        pingJiaView.frame=CGRectMake(15, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132);
        
    }];
}

#pragma mark - 地图操作

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (locationAnnotation == nil || endAnnotation == nil) {
        
    }else{
        [self.mapView removeAnnotations:@[locationAnnotation,endAnnotation]];
        [self.mapView removeOverlay:self.commonPolyline];
    }
    //移除大头针和折线
    
    self.mapView.delegate=nil;
    self.driveManager.delegate=nil;
    
    [self.mapView removeFromSuperview];
    self.mapView=nil;
    
//    [self.mapView removeAnnotations:thePointArray];
}

//设置显示地图
-(void)setUpMapView
{
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView = [DCYMapView shareMAMapView:self.view.bounds];
//    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    [self.view sendSubviewToBack:self.mapView];
    
    self.mapView.mapType=MAMapTypeNavi;
//    self.mapView.mapType=MAMapTypeStandard;
    self.mapView.showsLabels=YES;
    self.mapView.showsBuildings=YES;
    self.mapView.delegate=self;
    self.mapView.rotateEnabled=NO;//此属性用于地图旋转手势的开启和关闭
    self.mapView.rotateCameraEnabled=NO;//此属性用于地图旋转旋转的开启和关闭
    //绘制折线
    self.driveManager = [AMapNaviDriveManager sharedInstance];
    [self.driveManager setDelegate:self];
}

//添加开始结束位置的大头针
-(void)addAnnation
{
    //初始化大头针
    locationAnnotation = [[MAPointAnnotation alloc] init];
    locationAnnotation.coordinate = CLLocationCoordinate2DMake(orderDetail.start_lat, orderDetail.start_lng);
    locationAnnotation.title=@"起点";
    [self.mapView addAnnotation:locationAnnotation];
    
    //设置地图
    [self.mapView setZoomLevel:15 animated:YES];
    [self.mapView selectAnnotation:locationAnnotation animated:YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(orderDetail.start_lat, orderDetail.start_lng) animated:NO];
    
    //添加结束位置大头针
    endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.coordinate = CLLocationCoordinate2DMake(orderDetail.end_lat, orderDetail.end_lng);
    endAnnotation.title=@"终点";
    [self.mapView addAnnotation:endAnnotation];
    
//    [self startDrawLine:locationAnnotation end:endAnnotation];
    
    [self drawTrueRoad];//测试绘制真实路径
    
//    [self showDriveLocation];//显示轨迹点
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.enabled=NO;
        
//        if (annotation==endAnnotation) {
//            annotationView.pinColor=MAPinAnnotationColorRed;
//        }
//        if (annotation==locationAnnotation) {
//            annotationView.pinColor=MAPinAnnotationColorGreen;
//        }
        
        //起点，终点的图标标注
        if ([[annotation title] isEqualToString:@"起点"]) {
            annotationView.image = [UIImage imageNamed:@"map_start"];  //起点
            annotationView.centerOffset=CGPointMake(0, -22);
        }else if([[annotation title] isEqualToString:@"终点"]){
            annotationView.image = [UIImage imageNamed:@"map_end"];  //终点
            annotationView.centerOffset=CGPointMake(0, -22);
        }
        
//        if (annotation!=locationAnnotation && annotation!=endAnnotation) {
//            annotationView.image = [UIImage imageNamed:@"car"];
//        }
        
        return annotationView;
    }
    return nil;
}

////开始绘制轨迹
//-(void)startDrawLine:(MAPointAnnotation *)startAnn end:(MAPointAnnotation *)endAnn
//{
//    AMapNaviPoint * startPoint = [AMapNaviPoint locationWithLatitude:startAnn.coordinate.latitude longitude:startAnn.coordinate.longitude];
//    AMapNaviPoint * endPoint   = [AMapNaviPoint locationWithLatitude:endAnn.coordinate.latitude longitude:endAnn.coordinate.longitude];
//    
//    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
//                                                endPoints:@[endPoint]
//                                                wayPoints:nil
//                                          drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
//}
//
//- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
//{
//    NSLog(@"onCalculateRouteSuccess");
//    //构造折线对象
//    NSArray * array=driveManager.naviRoute.routeCoordinates;
//    CLLocationCoordinate2D commonPolylineCoords[array.count];
//    for (int i=0; i<array.count; i++) {
//        
//        AMapNaviPoint * navipoint=array[i];
//        commonPolylineCoords[i].latitude=navipoint.latitude;
//        commonPolylineCoords[i].longitude=navipoint.longitude;
//        
//    }
//    
//    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
//    //在地图上添加折线对象
//    [_mapView addOverlay: self.commonPolyline];
//}

//地图上覆盖物的渲染，可以设置路径线路的宽度，颜色等
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        
        [self.mapView showAnnotations:@[locationAnnotation,endAnnotation] edgePadding:UIEdgeInsetsMake(90, 50, 210, 50) animated:YES];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - 测试绘制真实路径

-(void)drawTrueRoad
{
//    NSMutableArray * pointArray = [[NSMutableArray alloc]init];
//    for (int i=0; i<orderDetail.locus_point.count; i++) {
//
//        DriverLocationModel * theModel=orderDetail.locus_point[i];
//
//        MATraceLocation * taceLoc = [[MATraceLocation alloc]init];
//        taceLoc.loc = CLLocationCoordinate2DMake(theModel.driver_lat, theModel.driver_lng);
//        taceLoc.angle = theModel.angle;
//        taceLoc.speed = theModel.speed;
//        taceLoc.time = theModel.stime;
//        [pointArray addObject:taceLoc];
//
//        NSLog(@"****角度速度时间：%f，%f，%f",theModel.angle,theModel.speed,theModel.stime);
//
//        if (i==orderDetail.locus_point.count-1) {
//
//            MATraceManager *manager = [MATraceManager sharedInstance];
//
//            NSLog(@"一共%lu个待纠偏的点",(unsigned long)pointArray.count);
//
//            [manager queryProcessedTraceWith:pointArray type:-1 processingCallback:^(int index, NSArray<MATracePoint *> *points) {
//
//                NSLog(@"NO***共有%lu个点",(unsigned long)points.count);
//
//            } finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
//
//                NSLog(@"距离是：%f",distance);
//                //构造折线数据对象
//                CLLocationCoordinate2D commonPolylineCoords[points.count];
//                NSLog(@"*****共有%lu个点",(unsigned long)points.count);
//
//                for (int i=0; i<points.count; i++) {
//
//                    int index = i;
//                    MATracePoint * model=points[index];
//                    commonPolylineCoords[i].latitude = model.latitude;
//                    commonPolylineCoords[i].longitude = model.longitude;
//
//                }
//
//                //构造折线对象
//                self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:points.count];
//
//                //在地图上添加折线对象
//                [self.mapView addOverlay: self.commonPolyline];
//
//            } failedCallback:^(int errorCode, NSString *errorDesc) {
//
//                NSLog(@"失败了");
//
//            }];
//
//        }
//
//    }
    
    
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[orderDetail.locus_point.count];
//    NSLog(@"*****共有%d个点",orderDetail.locus_point.count);
    
//    int count = orderDetail.locus_point.count/5;
    
    for (int i=0; i<orderDetail.locus_point.count; i++) {
        
//        float floatCount = count * 1.00;
        
//        int index = (int)orderDetail.locus_point.count*(i/floatCount);
        NSLog(@"*****第%d个点",index);
        
        DriverLocationModel * model=orderDetail.locus_point[i];
        NSLog(@"经纬度：%f,%f",model.driver_lat,model.driver_lng);
        commonPolylineCoords[i].latitude = model.driver_lat;
        commonPolylineCoords[i].longitude = model.driver_lng;
        
    }
    
    //构造折线对象
    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:orderDetail.locus_point.count];
    
    //在地图上添加折线对象
    [self.mapView addOverlay: self.commonPolyline];
    
}

//显示轨迹点
- (void)showDriveLocation
{
    for (int i = 0;                                                                                                                            i<orderDetail.locus_point.count; i ++) {
        
        DriverLocationModel * theModel=orderDetail.locus_point[i];
        MAPointAnnotation *thePoint = [[MAPointAnnotation alloc] init];
        thePoint.coordinate = CLLocationCoordinate2DMake(theModel.driver_lat, theModel.driver_lng);
        [thePointArray addObject:thePoint];
        
    }
    
    [self.mapView addAnnotations:thePointArray];
}

#pragma mark - YuYueAndAirPortViewDelegat

-(void)didClickCanCelbtn:(NSString *)order_id{
    
    CancelTripViewController * vc=[[CancelTripViewController alloc]init];
    vc.orderID = order_id;

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (YuYueAndAirPortView *)yuyueAndAirView{
    if (!_yuyueAndAirView) {
        _yuyueAndAirView = [YuYueAndAirPortView createView];
        _yuyueAndAirView.frame = CGRectMake(0, 64, DeviceWidth, 236);
        _yuyueAndAirView.delegate = self;
        [self.view addSubview: _yuyueAndAirView];
    }
    
    return _yuyueAndAirView;
}

@end
