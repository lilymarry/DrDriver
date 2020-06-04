//
//  TripViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "TripViewController.h"
#import "TripTableViewCell.h"
#import "TripDetailViewController.h"
#import "OrdeModel.h"
#import "RobSuccessViewController.h"
#import "ScanTripDetailViewController.h"
#import "ScanTripTableViewCell.h"

#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "AFNetworking.h"
#import "AppointAirListViewController.h"

#import "OrderRuningViewController.h"
#import "ITListModel.h"
#import "ITTripDetailViewController.h"
#import "ITShouYeTableViewCell.h"
#import "IndependentTravelView.h"

@interface TripViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSMutableArray * orderArray;
    NSString * currentPage;//当前分页数
    BOOL isNeedReload;
}

@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"行程";
    isNeedReload = NO;
    currentPage=@"1";
    orderArray=[[NSMutableArray alloc]init];
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self requestOrder];//请求订单列表
    
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
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
//        NSArray * vcArray=self.navigationController.viewControllers;
//        for (IndependentTravelView * vc in vcArray) {
//
//            if ([vc isKindOfClass:[IndependentTravelView class]]) {
//
//                vc.isNeedReload = isNeedReload;
//
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//
//        }
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

//下拉刷新
-(void)refreshDown
{
    currentPage=@"1";
    [self requestOrder];
}

//上拉加载
-(void)refreshUp
{
    currentPage=[NSString stringWithFormat:@"%d",[currentPage intValue]+1];
    [self requestOrder];
}

//请求订单列表
-(void)requestOrder
{
    NSLog(@"09090909090909%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"]);
    NSString *urlStr;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
        urlStr = DRIVER_INTERCITY_JOURNEY_ORDER_LIST;
    }
//    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
//        urlStr = DRIVER_TRAVEL_TRAVEL_LIST;
//    }
    else {//其他司机
        urlStr = DRIVER_JOURNEY_ORDER_LIST;
    }
    NSLog(@"driver_id=%@&token=%@&p=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],currentPage);

    [AFRequestManager postRequestWithUrl:urlStr params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"p":currentPage} tost:YES special:0 success:^(id responseObject) {

        NSLog(@"%@",responseObject);
        NSArray *array = [NSArray array];
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
//            array = responseObject[@"data"];
//        }else{
            array = [OrdeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        }
        
        if ([currentPage intValue]==1) {
            [orderArray removeAllObjects];
        }
        [orderArray addObjectsFromArray:array];
        
        [myTableView reloadData];
        
        [myTableView.mj_header endRefreshing];
        if ([currentPage intValue]>[responseObject[@"total_page"] intValue]) {
            [myTableView .mj_footer endRefreshingWithNoMoreData];
        }else{
            [myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [myTableView.mj_header endRefreshing];
        [myTableView.mj_footer endRefreshing];
        
    }];
}

//创建主要视图
-(void)creatMainView
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]){
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 114 - Top_Height - Bottom_Height) style:UITableViewStylePlain];
//    }else{
//        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
//    }
    
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[ScanTripTableViewCell class] forCellReuseIdentifier:@"ScanTripTableViewCell"];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
    UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    footView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [myTableView setTableFooterView:footView];
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
//        return 225;
//    }else{
        return 93;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
//        static NSString *cellIdentifier = @"cellIdentifier";
//        ITShouYeTableViewCell *ITShouYecell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (ITShouYecell == nil) {
//            ITShouYecell = [[ITShouYeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }else
//        {
//            //删除cell的所有子视图
//            while ([ITShouYecell.contentView.subviews lastObject] != nil)
//            {
//                [(UIView*)[ITShouYecell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }
//        [ITShouYecell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        ITShouYecell.state = orderArray[indexPath.section][@"state"];
//        [ITShouYecell setDataDic:orderArray[indexPath.section]];
//
//
//        return ITShouYecell;
//
//    }else{
        OrdeModel * order=orderArray[indexPath.section];
        if (order.order_class>=100){
            ScanTripTableViewCell *ScanTripTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ScanTripTableViewCell" forIndexPath:indexPath];
            ScanTripTableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            ScanTripTableViewCell.timeLB.text = order.ctime;
            ScanTripTableViewCell.expensesLB.text = [NSString stringWithFormat:@"费用：%@",order.actual_price];
            ScanTripTableViewCell.orderIDLB.text = [NSString stringWithFormat:@"订单号：%@",order.order_sn];
            return ScanTripTableViewCell;
        }else{
            TripTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"tripcell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"TripTableViewCell" owner:nil options:nil] firstObject];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.lineView.hidden=YES;
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {
                cell.dateLable.text=order.ctime;
                cell.startLable.text=[NSString stringWithFormat:@"%@:%@",order.start_city_name,order.start_site_name];;
                cell.endLable.text=[NSString stringWithFormat:@"%@:%@",order.end_city_name,order.end_site_name];;
                cell.stateLable.text=order.state_name;
                cell.stateLable.textColor=[CYTSI colorWithHexString:@"#386ac6"];
                cell.appoint_type_LB.text =@"";
            }else{
                cell.dateLable.text=order.ctime;
                cell.startLable.text=order.start_address;
                cell.endLable.text=order.end_address;
                cell.stateLable.text=order.state_name;
                NSLog(@"order.state_nameorder.state_name%@",order.state_name);
                cell.stateLable.textColor=[CYTSI colorWithHexString:@"#386ac6"];
                if ([order.appoint_type isEqualToString:@"0"]) {//及时单
                    cell.appoint_type_LB.text =@"";
                }else if ([order.appoint_type isEqualToString:@"1"]){//预约单
                    cell.appoint_type_LB.text =@"(预约单)";
                }else if ([order.appoint_type isEqualToString:@"2"]){//接机单
                    cell.appoint_type_LB.text =@"(接机单)";
                }
            }
            return cell;
        }
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"8"]) {
//        NSDictionary *dic=orderArray[indexPath.section];
//        ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
//        vc.travelID = dic[@"travel_id"];
//        vc.dateStr = dic[@"travel_date"];
//        vc.timeStr = dic[@"travel_time"];
//        vc.state = @"driver";
//        vc.isCanListen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isCanListen"];
//        __weak typeof(self) weakSelf = self;
//        vc.getDateBlock = ^{
//            [weakSelf refreshDown];
//            isNeedReload = YES;
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
        OrdeModel * order=orderArray[indexPath.section];
        //    NSLog(@"order.journey_state ===============%ld",(long)order.journey_state);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车类型
            if (order.journey_state==1 || order.journey_state==2) {//1乘客未上车 2以开始行程
                if ([order.driver_face_state isEqualToString:@"1"]) {
                    [self scanFaceActionModel:order];
                }else{
                    [self unfinishOrder:order];
                }
            } else{//已完成订单
                TripDetailViewController * vc=[[TripDetailViewController alloc]init];
                vc.orderID=order.order_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{//快车、出租车、豪华车、专车
            if (order.order_class <= 100) {
                NSLog(@"indexPath.section%ld",indexPath.section);
                
                if (order.journey_state==1 || order.journey_state==2 || order.journey_state==3 || order.journey_state==4) {
                    if ([order.driver_face_state isEqualToString:@"1"]) {
                        [self scanFaceActionModel:order];
                    }else{
                        [self unfinishOrder:order];
                    }
                } else if(order.journey_state == 11){
                    AppointAirListViewController * vc=[[AppointAirListViewController alloc]init];
                    vc.AlreadyListenBlock = ^{
                        
                    };
                    vc.orderID=order.order_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    TripDetailViewController * vc=[[TripDetailViewController alloc]init];
                    vc.orderID=order.order_id;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{//扫码车
                ScanTripDetailViewController *scan = [[ScanTripDetailViewController alloc] init];
                scan.order_id = order.order_id;
                [self.navigationController pushViewController:scan animated:YES];
            }
        }
        
//    }
}
#pragma mark -- 扫脸认证
-(void)scanFaceActionModel:(OrdeModel *)order{
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
            NSDictionary  *dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":order.order_id};
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
                    if ([responseObject[@"message"] isEqualToString:@"认证成功"]){
                       [self unfinishOrder:order];
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
    [lvc livenesswithList:@[] order:0  numberOfLiveness:[[[NSUserDefaults standardUserDefaults] objectForKey:@"face_number"] integerValue]];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)unfinishOrder:(OrdeModel *)order{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"driver_class"] isEqualToString:@"6"]) {//包车司机
        OrderRuningViewController * vc=[[OrderRuningViewController alloc]init];
        vc.orderID=order.order_id;
        vc.endCoordinate=CLLocationCoordinate2DMake(order.end_lat, order.end_lng);
        vc.endAddress=order.end_address;
        vc.userStartCoordinate=CLLocationCoordinate2DMake(order.start_lat, order.start_lng);
        vc.userStartAddress=order.start_address;
        vc.userName=order.passenger_name;
        vc.userPhone=order.passenger_phone;
        vc.m_header=order.m_head;
        vc.isOrderList=YES;
        vc.orderState=order.journey_state;
        vc.appoint_type = order.appoint_type;
        vc.appoint_time = order.appoint_time;
        vc.flight_number = order.flight_number;
        vc.flight_date = order.appoint_time;
        vc.remarkStr = order.remark;
        vc.submit_class = order.submit_class;
        vc.order_class=order.order_class;
        vc.journey_fee=order.journey_fee;
        vc.AlreadyListenBlock = ^{
            
        };
        [[NSUserDefaults standardUserDefaults] setObject:order.order_id forKey:@"order_id"];
        //    NSLog(@"order.journey_stateorder.journey_state%ld",order.journey_state);
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)order.journey_state],@"orderState", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{//其他司机
        RobSuccessViewController * vc=[[RobSuccessViewController alloc]init];
        vc.orderID=order.order_id;
        vc.endCoordinate=CLLocationCoordinate2DMake(order.end_lat, order.end_lng);
        vc.endAddress=order.end_address;
        vc.endName = order.end_name;
        vc.userStartCoordinate=CLLocationCoordinate2DMake(order.start_lat, order.start_lng);
        vc.userStartAddress=order.start_address;
        vc.userStartname = order.start_name;
        vc.userName=order.passenger_name;
        vc.userPhone=order.passenger_phone;
        vc.m_card_number = order.m_card_number;
        vc.m_header=order.m_head;
        vc.isOrderList=YES;
        vc.orderState=order.journey_state;
        vc.appoint_type = order.appoint_type;
        vc.appoint_time = order.appoint_time;
        vc.flight_number = order.flight_number;
        vc.flight_date = order.appoint_time;
        vc.remarkStr = order.remark;
        vc.submit_class = order.submit_class;
        vc.order_class=order.order_class;
        vc.journey_fee=order.journey_fee;
        vc.AlreadyListenBlock = ^{
            
        };
        [[NSUserDefaults standardUserDefaults] setObject:order.order_id forKey:@"order_id"];
        //    NSLog(@"order.journey_stateorder.journey_state%ld",order.journey_state);
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)order.journey_state],@"orderState", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderState" object:self userInfo:dict];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
