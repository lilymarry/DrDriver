//
//  ITTripDetailViewController.m
//  DrDriver
//
//  Created by fy on 2019/1/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITTripDetailViewController.h"
#import "TripDetailTopView.h"
#import "ITOrderDetailTableViewCell.h"
#import "ITUserOrderModel.h"
#import "TravelCancelReasonViewController.h"
#import "DriveMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "SpeechSynthesizer.h"
#import "DCYMapView.h"
#import "InTravelMapViewController.h"
#import "ChangeSeatingCapacityView.h"
#import "ITFindUserOrderViewController.h"
#import "IndependentTravelView.h"
#import "TakeAndSendView.h"
#import "SpeechSynthesizer.h"




@interface ITTripDetailViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate,AMapNaviDriveManagerDelegate,AMapNaviCompositeManagerDelegate,AMapNaviDriveDataRepresentable,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
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
    
    //持续更新的司机的位置
    float driverLong;
    float driverLat;
    double driverTimeTap;//司机实时时间
    double driverCourse;//司机实时角度
    double carSpeed;//司机实时车速
    
    NSTimer * checkTimer;//检查导航是否出问题了
    
    BOOL isNearBy;//是否快到目的地了
    MAPinAnnotationView * userLocationView;//用户位置视图
    MAPointAnnotation *locationAnnotation;//定位的大头针
    MAPointAnnotation *endAnnotation;//终点的大头针
    MAUserLocationRepresentation *representation;//用户位置
    
    NSString *traver_start_name;
    NSString *traver_end_name;
}
@property(nonatomic,strong)TripDetailTopView *topView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UILabel *nullLabel;
@property(nonatomic,copy)NSString *orderState;
@property(nonatomic,copy)NSString *pingjiaOrderID;
@property(nonatomic,copy)NSString *pingjiaOrderHead;
@property(nonatomic,copy)NSString *pingjiaOrderName;
@property(nonatomic,strong)UIButton *rightButton;
//导航界面
@property (strong, nonatomic) DCYMapView * mapView;//地图;
@property (nonatomic,strong) DriveMapViewController * driveVC;//导航视图
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *lm;
@property (nonatomic, strong) AMapSearchAPI *search;//搜索对象
@property (nonatomic,weak) AMapNaviDriveManager * driveManager;//轨迹管理(起点到终点)
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;//当前定位经纬度
@property (nonatomic,strong) MAPolyline * commonPolyline;//轨迹（折现）
@property (nonatomic, assign) CLLocationCoordinate2D agoCurrentCoordinate;//当前定位经纬度之前的点
@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;//终点的经纬度(订单终点)
@property (nonatomic,strong) MAPolyline * takeUserCommonPolyline;//去接乘客的轨迹（折现）
@property(nonatomic,strong)CYStarView * pingStarView;
@property(nonatomic,strong)ChangeSeatingCapacityView *changeView;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *pintuanStr;
@property(nonatomic,strong)NSString *yikojiaStr;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)TakeAndSendView *takeAlertView;

@property(nonatomic,strong)NSMutableArray *wayPointsArr;//乘客下车点数组
@property(nonatomic,copy)NSString *status;//订单状态

@end

@implementation ITTripDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chengjiMessage:) name:@"chengjiMessage" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chengjiMessage" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"行程详情";
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.wayPointsArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    [self startLocation];
    [self setUpNav];//设置导航栏
    [self getData];
    
}
#pragma mark ------  程序在后台运行时是点击通知事件
-(void)chengjiMessage:(NSNotification *)noti
{
    if ([noti.userInfo[@"operate_class"] isEqualToString:@"driver_travel_msg"]) {
        NSString *str =noti.userInfo[@"travel_id"];
        self.travelID = str;
        [self getData];
    }
}
#pragma mark -----------  获取订单详情
-(void)getData{
    if ([self.state isEqualToString:@"getdata"]) {
        self.getDateBlock();
        self.state = @"";
    }
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_TRAVEL_DETAIL params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"travel_id":self.travelID} tost:YES special:0 success:^(id responseObject) {
        
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            NSDictionary *dic = responseObject[@"data"];
//            NSLog(@"orderorder%@",dic);
            [[NSUserDefaults standardUserDefaults] setObject:self.travelID forKey:@"travel_id"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"status"] forKey:@"orderState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.orderState = dic[@"state"];
            self.number = dic[@"remain_seat"];
            self.pintuanStr = dic[@"driver_price"];
            self.yikojiaStr = dic[@"driver_fixed_price"];
            self.remark = dic[@"driver_remark"];
            self.status = dic[@"status"];
            if (self.topView != nil) {
                [self.topView removeFromSuperview];
                [self creatTopViewStatus:dic[@"status"] remain_seat:dic[@"remain_seat"]];
            }else{
                [self creatTopViewStatus:dic[@"status"] remain_seat:dic[@"remain_seat"]];
            }
            [self.topView setTravelDate:dic];
            if (self.tableView != nil) {
                [self.tableView removeFromSuperview];
                [self creatTableView];
            }else{
                [self creatTableView];
            }
            if ([dic[@"status"] isEqualToString:@"0"] || [dic[@"status"] isEqualToString:@"1"]) {
                if ([dic[@"remain_seat"] isEqualToString:@"0"]) {
                    self.topView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, 328);
                    self.tableView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, self.view.frame.size.height - Bottom_Height - k_Height_NavBar);
                }else{
                    self.topView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, 380);
                    self.tableView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, self.view.frame.size.height - Bottom_Height - k_Height_NavBar);
                }
            }else{
                self.topView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, 328);
                 self.tableView.frame = CGRectMake(0, k_Height_NavBar, DeviceWidth, self.view.frame.size.height  - Bottom_Height - k_Height_NavBar);
            }
            if ([dic[@"match_num"] isEqualToString:@"0"]) {
                self.topView.redImageLB.hidden = YES;
                [self.topView.findUserBtn setTitle:@"未发现可匹配订单" forState:UIControlStateNormal];
            }else{
                [self.topView.findUserBtn setTitle:[NSString stringWithFormat:@"发现%@个可匹配订单",dic[@"match_num"]] forState:UIControlStateNormal];
            }
            
            self.endCoordinate = CLLocationCoordinate2DMake([dic[@"end_lat"] floatValue], [dic[@"end_lng"] floatValue]);
            endAnnotation = [[MAPointAnnotation alloc] init];
            endAnnotation.coordinate = self.endCoordinate;
            
            traver_start_name = dic[@"start_name"];
            traver_end_name = dic[@"end_name"];
            NSArray *arr = [ITUserOrderModel mj_objectArrayWithKeyValuesArray:dic[@"order"]];
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:arr];
            
            
            [self.wayPointsArr removeAllObjects];
            
            for (ITUserOrderModel *model in arr) {
                AMapNaviPoint *point = [AMapNaviPoint locationWithLatitude:[model.end_lat floatValue] longitude:[model.end_lng floatValue]];//订单的起点
                [self.wayPointsArr addObject:point];
            }
            if (self.dataArr.count == 0) {
                self.nullLabel = [[UILabel alloc] init];
                self.nullLabel.text = @"暂无乘客";
                self.nullLabel.font = [UIFont systemFontOfSize:22];
                self.nullLabel.textColor = [UIColor lightGrayColor];
                [self.tableView addSubview:self.nullLabel];
                [self.nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(self.tableView.mas_top).offset(410);
                }];
            }else{
                [self.nullLabel removeFromSuperview];
            }
            [self.tableView reloadData];
            
            if ([dic[@"state"] isEqualToString:@"行程中"]) {
//                [self.rightButton setTitle:@"导航" forState:(UIControlStateNormal)];
                self.rightButton.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
            }else if([self.orderState isEqualToString:@"暂无用户叫车"] || [self.orderState isEqualToString:@"待发车"]){
                [self.rightButton setTitle:@"取消行程" forState:(UIControlStateNormal)];
                self.rightButton.hidden = NO;
            }else{
                self.rightButton.hidden = YES;
            }
            self.takeAlertView = [[TakeAndSendView alloc] initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
            [self.view addSubview:self.takeAlertView];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
    }];
}
-(void)creatTopViewStatus:(NSString *)status remain_seat:(NSString *)remain_seat{
    self.topView = [[TripDetailTopView alloc] initWithFrame:CGRectMake(0, k_Height_NavBar, DeviceWidth, 395) status:status remain_seat:remain_seat];
//    [self.view addSubview:self.topView];
    __weak typeof(self) weakSelf = self;
// 接送顺序
    self.topView.btnBlock = ^(NSArray * _Nonnull takeArr, NSArray * _Nonnull sendArr) {
        [weakSelf.takeAlertView showAlertViewTake:takeArr send:sendArr];
    };
    //地图
    self.topView.mapBlock = ^(NSDictionary * _Nonnull dataDic) {
        if ([weakSelf.orderState isEqualToString:@"行程中"]) {
            [weakSelf.driveManager addDataRepresentative:weakSelf.driveVC.driveView];
            [weakSelf.driveManager addDataRepresentative:weakSelf];
            
            [weakSelf startDrawLine];//开始划线
            [weakSelf startDrive];
        }else{
            InTravelMapViewController *mapView = [[InTravelMapViewController alloc] init];
            mapView.dic = dataDic;
            [weakSelf.navigationController pushViewController:mapView animated:YES];
        }
    };
    //开始行程
    self.topView.startBlock = ^{
        [weakSelf startTravel];
    };
    //更改座位数
    self.topView.changeBlock = ^{
        weakSelf.changeView = [[ChangeSeatingCapacityView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) Number:weakSelf.number pintuan:weakSelf.pintuanStr yikojia:weakSelf.yikojiaStr remark:weakSelf.remark];
        weakSelf.changeView.cancelBlock = ^(NSString * _Nonnull number, NSString * _Nonnull remark, NSString * _Nonnull pintuan, NSString * _Nonnull yikojia) {
            if ([CYTSI isNumber:number]) {
                if ([CYTSI isNumber:pintuan]) {
                    if ([CYTSI isNumber:yikojia]) {
                        [weakSelf changeNumber:number pintuan:pintuan yikojia:yikojia remark:remark];
                    }else{
                        [CYTSI otherShowTostWithString:@"请输入正确的一口包车价"];
                    }
                }else{
                    [CYTSI otherShowTostWithString:@"请输入正确的拼团价"];
                }
            }else{
                [CYTSI otherShowTostWithString:@"请输入正确的座位数"];
            }
        };
        weakSelf.changeView.coffimBlock = ^{
            [weakSelf.changeView removeFromSuperview];
        };
        [weakSelf.view addSubview:weakSelf.changeView];
        
    };
    //结束行程
    self.topView.stopBlock = ^{
        [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_END_TRAVEL params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"travel_id":weakSelf.travelID,@"arrive_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],@"arrive_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"]} tost:YES special:0 success:^(id responseObject) {
            if ([responseObject[@"message"] isEqualToString:@"操作成功"]) {
                [weakSelf  cancelGPSNavi];
                [weakSelf getData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:weakSelf userInfo:nil];
                weakSelf.getDateBlock();
            }
        } failure:^(NSError *error) {
            
        }];
    };
    //发现匹配乘客
    self.topView.findUserBlock = ^{
        ITFindUserOrderViewController *vc = [[ITFindUserOrderViewController alloc] init];
        vc.travel_id = weakSelf.travelID;
        vc.isCanListen = weakSelf.isCanListen;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(k_Height_NavBar);
//        make.width.mas_offset(DeviceWidth);
//        make.centerX.equalTo(self.view);
//        make.height.mas_offset(395);
//    }];
    
}
#pragma mark --------- 更改座位数
-(void)changeNumber:(NSString *)number pintuan:(NSString *)pintuanStr yikojia:(NSString *)yikojiaStr remark:(NSString *)remarkStr{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_CHANGE_TRAVEL_INFO params:@{
                                                                                   @"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                                                                   @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                                                   @"travel_id":self.travelID,
                                                                                   @"remain_seat":number,
                                                                                   @"remark":remarkStr,
                                                                                   @"price":pintuanStr,
                                                                                   @"fixed_price":yikojiaStr
                                                                                   } tost:YES special:0 success:^(id responseObject) {
                                                                                       if ([responseObject[@"message"] isEqualToString:@"修改成功"]) {
                                                                                           [self.changeView removeFromSuperview];
                                                                                           self.topView.remainderLB.text = [NSString stringWithFormat:@"剩余座位%@位",number];
                                                                                           self.remark = remarkStr;
                                                                                           self.pintuanStr = pintuanStr;
                                                                                           self.yikojiaStr = yikojiaStr;
                                                                                           self.number = number;
                                                                                           [self getData];
                                                                                           self.getDateBlock();
                                                                                       }
                                                                                       
                                                                                   } failure:^(NSError *error) {
                                                                                       
                                                                                       
                                                                                       
                                                                                   }];
}
#pragma mark ------------- 开始行程
-(void)startTravel{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_START_TRAVEL params:@{
                                                                             @"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                                                             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                                             @"travel_id":self.travelID,
                                                                             @"depart_lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLo"],
                                                                             @"depart_lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"driverLocationLa"]
                                                                             } tost:YES special:0 success:^(id responseObject) {
                                                                                 if ([responseObject[@"message"] isEqualToString:@"操作成功"]) {
                                                                                     [self playVideo:@"行程开始，请前后排乘客系好安全带"];
                                                                                     [self getData];
                                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
                                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"beginUpdate" object:self userInfo:nil];
                                                                                     self.getDateBlock();
                                                                                     [self.driveManager addDataRepresentative:self.driveVC.driveView];
                                                                                     [self.driveManager addDataRepresentative:self];
                                                                                     
                                                                                     [self startDrawLine];//开始划线
                                                                                     [self startDrive];
                                                                                 }
                                                                                 
                                                                             } failure:^(NSError *error) {
                                                                                 
                                                                                 
                                                                                 
                                                                             }];
}
//播放推送标题
-(void)playVideo:(NSString *)title
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:title];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,k_Height_NavBar, DeviceWidth, self.view.frame.size.height - Bottom_Height - k_Height_NavBar) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ITOrderDetailTableViewCell class] forCellReuseIdentifier:@"ITOrderDetailTableViewCell"];
    self.tableView.tableHeaderView = self.topView;
    [self.view addSubview:self.tableView];
    
    //添加下拉刷新及上拉加载
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITOrderDetailTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setWithModel:self.dataArr[indexPath.row] state:self.orderState travelStartName:traver_start_name tarvelEndName:traver_end_name];
    __weak typeof(self) weakSelf = self;
    //去接乘客导航
    cell.userTravelBlock = ^(NSString * _Nonnull start_lat, NSString * _Nonnull start_lng) {
        [weakSelf.driveManager addDataRepresentative:weakSelf.driveVC.driveView];
        [weakSelf.driveManager addDataRepresentative:weakSelf];
        
        [weakSelf startDrawTakeUserLine:start_lat lng:start_lng];//开始划线
        [weakSelf startDrive];
    };
    cell.callCustPhone = ^(NSString * _Nonnull custPhone) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单已超时，并关闭司乘直接通话，为您联系客服" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [CYTSI callPhoneStr:custPhone withVC:weakSelf];
        }];
        
        [alertC addAction:alertA];
        [alertC addAction:alertB];
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    };
    //取消订单
    cell.cancelBlock = ^(NSString * _Nonnull orderID) {
        TravelCancelReasonViewController *vc = [[TravelCancelReasonViewController alloc] init];
        vc.isSchoolBus = @"3";
        vc.orderID = orderID;
        vc.cancelBlock = ^{
            [weakSelf getData];
            weakSelf.getDateBlock();
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.confirmBlock = ^{
        [weakSelf getData];
    };
    cell.pingjiaBlock = ^(NSDictionary * _Nonnull orderDic) {
        
        weakSelf.pingjiaOrderID = orderDic[@"orderID"];
        [weakSelf creatPingJiaView];
        [pingHeadImageView sd_setImageWithURL:[NSURL URLWithString:orderDic[@"head"]] placeholderImage:[UIImage imageNamed:@"default_header"]];
        pingDriverLable.text = orderDic[@"name"];
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        
        blackView.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            
            pingJiaView.frame=CGRectMake(15, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132);
            
        }];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ----------- 评价按钮点击事件
-(void)pingJiaButtonClicked
{
    
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_DRIVER_APPRAISE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"driver_star":pingStar,@"driver_reason":myTextView.text,@"order_id":self.pingjiaOrderID,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        //隐藏评价视图
        UIWindow * window=[UIApplication sharedApplication].delegate.window;
        blackView.frame=CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height);
        pingJiaView.frame=CGRectMake(DeviceWidth, (window.frame.size.height)/2-200, DeviceWidth-30, 239+132);
        [self getData];
        [blackView removeFromSuperview];
        [pingJiaView removeFromSuperview];
        //        pingStar = @"";
        //        myTextView.text = @"";
        //        [placeHolderLable setHidden:NO];
        //        [self.pingStarView setViewWithNumber:0 width:38 space:7 enable:YES];
        
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
    pingHeadImageView.layer.cornerRadius=30;
    pingHeadImageView.layer.masksToBounds=YES;
    //    pingHeadImageView.backgroundColor=[UIColor orangeColor];
    [pingJiaView addSubview:pingHeadImageView];
    [pingHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-25);
        make.centerX.equalTo(pingJiaView.mas_centerX);
        make.width.and.height.equalTo(@60);
    }];
    
    pingDriverLable=[[UILabel alloc]init];
    pingDriverLable.text=@"--------";
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
    pingCompanyLable.text=@"----------";
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
    
    self.pingStarView=[[CYStarView alloc]init];
    [self.pingStarView setViewWithNumber:0 width:38 space:7 enable:YES];
    [pingJiaView addSubview:self.pingStarView];
    [self.pingStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pingCompanyLable.mas_bottom).with.offset(24);
        make.width.equalTo(@218);
        make.height.equalTo(@38);
        make.centerX.equalTo(pingJiaView.mas_centerX);
    }];
    
    //星星按钮点击了
    self.pingStarView.starButtonClicked = ^(NSInteger index) {
        
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
    
    self.rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame=CGRectMake(0, 0, 80, 40);
    [self.rightButton setTitle:@"导航" forState:(UIControlStateNormal)];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)navBackButtonClicked{
    if ([self.state isEqualToString:@"user"]) {
        NSArray * vcArray=self.navigationController.viewControllers;
        for (IndependentTravelView * vc in vcArray) {
            if ([vc isKindOfClass:[IndependentTravelView class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)messageButtonClicked{
    if ([self.orderState isEqualToString:@"行程中"]) {
//        [self.driveManager addDataRepresentative:self.driveVC.driveView];
//        [self.driveManager addDataRepresentative:self];
//
//        [self startDrawLine];//开始划线
//        [self startDrive];
    }else{
        NSString *str = @"取消行程";
       if([self.status isEqualToString:@"1"]){
           str = @"有乘客订单，请先取消乘客订单";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self cancelTravel];
        }];
        UIAlertAction *coffimAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [alert addAction:coffimAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//取消行程
-(void)cancelTravel{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_CANCEL_TRAVEL params:@{
                                                                              @"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                                                              @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                                              @"travel_id":self.travelID
                                                                              } tost:YES special:0 success:^(id responseObject) {
                                                                                  if ([responseObject[@"message"] isEqualToString:@"操作成功"]) {
                                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                                      self.getDateBlock();
                                                                                  }
                                                                                  
                                                                              } failure:^(NSError *error) {
                                                                                  
                                                                                  
                                                                                  
                                                                              }];
}
//开始绘制去接乘客路线
-(void)startDrawTakeUserLine:(NSString *)start_lat lng:(NSString *)start_lng{
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
        AMapNaviPoint * endPoint   = [AMapNaviPoint locationWithLatitude:[start_lat floatValue] longitude:[start_lng floatValue]];
//        NSLog(@"endCoordinate.latitude,self.endCoordinate.longitu%f %f  %f  %f",latitude,longtitude,self.endCoordinate.latitude,self.endCoordinate.longitude);
    
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
}
//开始绘制轨迹
-(void)startDrawLine
{
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
//    NSLog(@"endCoordinate.latitude,self.endCoordinate.longitu%f %f  %f  %f",latitude,longtitude,self.endCoordinate.latitude,self.endCoordinate.longitude);
    
//    AMapNaviPoint * onePoint = [AMapNaviPoint locationWithLatitude:39.14572148 longitude:117.09870100];//订单的起点
//    AMapNaviPoint * twoPoint = [AMapNaviPoint locationWithLatitude:39.12190369 longitude:117.10058927];//订单的起点
//    AMapNaviPoint * threPoint = [AMapNaviPoint locationWithLatitude:39.13764997 longitude:117.13794708];//订单的起点
    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                endPoints:@[endPoint]
                                                wayPoints:self.wayPointsArr
                                          drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
//    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
//                                                endPoints:@[endPoint]
//                                                wayPoints:nil
//                                          drivingStrategy:ConvertDrivingPreferenceToDrivingStrategy(NO,YES,NO,NO,NO)];
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [_mapView removeOverlay:self.commonPolyline];
//    NSLog(@"onCalculateRouteSuccess");
    NSArray * array=driveManager.naviRoute.routeCoordinates;
    CLLocationCoordinate2D commonPolylineCoords[array.count];
    for (int i=0; i<array.count; i++) {
        
        AMapNaviPoint * navipoint=array[i];
        commonPolylineCoords[i].latitude=navipoint.latitude;
        commonPolylineCoords[i].longitude=navipoint.longitude;
        
    }
    
    self.commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:array.count];
    //在地图上添加折线对象
    [_mapView addOverlay:self.commonPolyline];
    
    
    [self.mapView showAnnotations:@[locationAnnotation,endAnnotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
    
    [self startDrive];//开始导航
}
//结束导航
-(void)cancelGPSNavi
{
    //停止导航
    [self.driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}
//开始导航
-(void)startDrive
{
    [self.driveManager stopNavi];
    [self.driveManager startGPSNavi];//开始导航
    //    [self.driveManager startEmulatorNavi];//开始模拟导航
    
    if (![self.navigationController.topViewController isKindOfClass:[DriveMapViewController class]]) {
        
        
        [self.navigationController pushViewController:self.driveVC animated:NO];
        
    }
    
    __weak typeof (self) weakSelf = self;
    
    self.driveVC.closeDrive = ^{
        
                //停止导航
        [weakSelf.driveManager stopNavi];
        
                //停止语音
        [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        
    };
    
    self.driveVC.moreClicked = ^{
        
        //  [self.driveManager readNaviInfoManual];
        
        //模拟偏航重新规划路线
        //        if (isAginDrawLine==NO) {
        //
        //            isAginDrawLine=YES;
        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已为您切换路线"];
        
        [weakSelf aginStartNavi];//重新导航
        
        //        }
        
    };
    
    self.driveVC.pauseClicked = ^{
        [weakSelf.driveManager pauseNavi];
    };
    
    self.driveVC.resumeClicked = ^{
        
        [weakSelf.driveManager resumeNavi];
        
    };
}
//重新导航
-(void)aginStartNavi
{
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
    
    [self.mapView setZoomLevel:15];
    [self.mapView showAnnotations:@[locationAnnotation] edgePadding:UIEdgeInsetsMake(30, 50, 70, 50) animated:YES];
    
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
    //    if (isAginDrawLine==NO) {
    //
    //        isAginDrawLine=YES;
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"已为您切换路线"];
    
    [self aginStartNavi];//重新导航
    
    //    }
}

/**
 * @brief 前方遇到拥堵需要重新计算路径时的回调函数.拥堵后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理.
 * @param driveManager 驾车导航管理类
 */
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    //    if (isAginDrawLine==NO) {
    //
    //        isAginDrawLine=YES;
    //        [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"前方遇到拥堵，正在重新计算路径"];
    [self aginStartNavi];//重新导航
    
    //    }
}

/**
 * @brief 导航到达某个途经点的回调函数
 * @param driveManager 驾车导航管理类
 * @param wayPointIndex 到达途径点的编号，标号从1开始
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    //    if (_orderState==1 || _orderState==0) {
    //
    //        [self.takeUserManager readNaviInfoManual];
    //
    //    } else {
    //
    //        [self.driveManager readNaviInfoManual];
    //
    //    }
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
 * @param soundString 播报文字qu
 * @param soundStringType 播报类型,参考 AMapNaviSoundType .
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
//    NSLog(@"导航播报：%@",soundString);
    
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
    
    [self.driveManager stopNavi];
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}
-(AMapNaviDriveManager *)driveManager
{
    if (!_driveManager) {
        
        _driveManager = [AMapNaviDriveManager sharedInstance];
        [_driveManager setDelegate:self];
        [_driveManager setPausesLocationUpdatesAutomatically:NO];
        [_driveManager setScreenAlwaysBright:YES];
        
    }
    
    return _driveManager;
}
-(DriveMapViewController *)driveVC
{
    if (!_driveVC) {
        
        _driveVC=[[DriveMapViewController alloc]init];
        
    }
    
    return _driveVC;
}
//开始定位
-(void)startLocation
{
    self.locationManager.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
    self.locationManager.locationTimeout =10;
    self.locationManager.reGeocodeTimeout = 10;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"定位失败"];
        }
        
//        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
//            NSLog(@"reGeocode:%@", regeocode);
        }
        locationAnnotation = [[MAPointAnnotation alloc] init];
        locationAnnotation.coordinate = location.coordinate;
        self.currentCoordinate = location.coordinate;
        //        [self startDrawLine];
        
    }];
}
//用户位置更新的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //    double a=userLocation.coordinate.latitude;
    //    NSLog(@"用户位置更新：%.100f,%.100f",a,userLocation.coordinate.longitude);
    
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
    NSLog(@"连续更新车速%f",location.speed);
    //    carAnnotation.coordinate=location.coordinate;
    carSpeed=location.speed;
    
    driverTimeTap=[location.timestamp timeIntervalSince1970];
    //   NSLog(@"======================%f",driverTimeTap);
    driverCourse=location.course;
    
    //更新司机当前位置
    self.currentCoordinate = location.coordinate;
    driverLong=location.coordinate.longitude;
    driverLat=location.coordinate.latitude;
    
    //    carAnnotation.coordinate=location.coordinate;
}
//清除之前的轨迹
-(void)clearAgoLine
{
    [self.mapView removeOverlay:self.takeUserCommonPolyline];
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
