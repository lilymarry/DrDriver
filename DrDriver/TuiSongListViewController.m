//
//  TuiSongListViewController.m
//  DrDriver
//
//  Created by fy on 2019/7/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TuiSongListViewController.h"
#import "TuiSongTableViewCell.h"
#import "TuiSongOrderAlertView.h"
#import "FaceAlertView.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceViewController.h"
#import "LivenessViewController.h"
#import "AFNetworking.h"
#import "UIImage+FixIMG.h"
#import "OrdeModel.h"
#import "RobSuccessViewController.h"
#import "CYAlertView.h"
#import "GetOrderAlertView.h"
#import "ITTripDetailViewController.h"


@interface TuiSongListViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSMutableArray * orderArray;
    NSString * currentPage;//当前分页数
}

@property(nonatomic,strong)TuiSongOrderAlertView *alertView;
@property(nonatomic,strong)FaceAlertView *alert;
@property(nonatomic,strong)CYAlertView *successAppointView;
@property(nonatomic,strong)GetOrderAlertView *getOrderalertView;
@end

@implementation TuiSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentPage=@"1";
    orderArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.title = @"推送订单";
    [self setUpNav];
    
    [self creatMainView];//创建主要视图
    
    
    [self creatHttp];//请求界面数据
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alert];

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
//请求界面数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_ORDERPUSH_LIST params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        NSLog(@"ITTripViewController%@",responseObject);
        NSArray * array = responseObject[@"data"];
        
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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - Top_Height - Bottom_Height) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[TuiSongTableViewCell class] forCellReuseIdentifier:@"TuiSongTableViewCell"];
    
    //添加下拉刷新及上拉加载
    myTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    myTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    myTableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 34 : 0;
    
    
    
    self.getOrderalertView = [[GetOrderAlertView alloc] initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
    __weak typeof(self) weakSelf = self;
    self.getOrderalertView.popViewBlock = ^(NSString * _Nonnull travel_id) {
        ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
        vc.travelID = travel_id;
        vc.state = @"user";
        vc.isCanListen = YES;
        vc.getDateBlock = ^{
            
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:self.alertView];
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
    return 143;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TuiSongTableViewCell *ITShouYecell = [myTableView dequeueReusableCellWithIdentifier:@"TuiSongTableViewCell" forIndexPath:indexPath];
    [ITShouYecell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [ITShouYecell setDataDic:orderArray[indexPath.section]];
    return ITShouYecell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    self.alertView = [[TuiSongOrderAlertView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.alertView setDataDic:orderArray[indexPath.section]];
    self.alertView.takeOrderBlock = ^(NSString * _Nonnull order_ID, NSString * _Nonnull order_type, NSString * _Nonnull appoint_type) {
        [weakSelf.alertView removeFromSuperview];
        [weakSelf takeOrderAction:order_ID type:order_type typeName:appoint_type];
    };
    self.alertView.closeBlock = ^{
        [weakSelf.alertView removeFromSuperview];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
}
-(void)takeOrderAction:(NSString *)order_id type:(NSString *)order_type typeName:(NSString *)appoint_type{
    __weak typeof(self) weakSelf = self;
    //普通订单
    if ([order_type isEqualToString:@"0"]) {
        [AFRequestManager postRequestWithUrl:DRIVER_TAKE_JOURNEY_ORDER params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":order_id,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:1 success:^(id responseObject) {
            NSLog(@"responseObjectresponseObjectresponseObjectresponseObject%@",responseObject);
            //普通订单抢单成功
            if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                NSLog(@"weakSelf.receipt_face_stateweakSelf.receipt_face_state%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"]);
                //预约接机
                if ([appoint_type isEqualToString:@"1"] || [appoint_type isEqualToString:@"2"]) {
                    UIWindow * window=[UIApplication sharedApplication].delegate.window;
                    weakSelf.successAppointView=[[CYAlertView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
                    weakSelf.successAppointView.titleStr=@"抢单成功";
                    weakSelf.successAppointView.alertStr=@"您已经抢单成功，可到订单列表查看";
                    weakSelf.successAppointView.cancleButtonStr=@"";
                    weakSelf.successAppointView.sureButtonStr=@"我知道了";
                    [weakSelf.successAppointView setSingleButton];
                    [weakSelf.successAppointView setTextFiled:YES];
                    [window addSubview:weakSelf.successAppointView];
                    
                    weakSelf.successAppointView.phoneBlock = ^{
                        //重新加载数据
                        [weakSelf.successAppointView hideAlertView];
                        [weakSelf creatHttp];
                    };
                }else{
                    //即时
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_face_state"] isEqualToString:@"1"]) {
                        [weakSelf.alert showFaceAlertView:responseObject state:@"" orderid:order_id btnSate:0];
                        
                    }else{
                        [self robOrderAction:responseObject order:order_id];
                    }
                    [weakSelf creatHttp];
                };
            }else {
                //抢单失败
//                [CYTSI otherShowTostWithString:@"抢单失败"];
                [weakSelf creatHttp];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        //自由行订单
        NSDictionary *dic = [NSDictionary dictionary];
        dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":order_id};
        [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_GRAB_ORDER params:dic tost:YES special:0 success:^(id responseObject) {
            if ([responseObject[@"message"] isEqualToString:@"抢单成功"]) {
                [self.getOrderalertView showOrderAlertView:responseObject[@"data"][@"travel_id"]];
                ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
                vc.state = @"driver";
                vc.isCanListen = YES;
                vc.getDateBlock = ^{
                    [weakSelf refreshUp];
                };
                vc.travelID = responseObject[@"data"][@"travel_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [weakSelf creatHttp];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
-(FaceAlertView *)alert{
    if (!_alert) {
        _alert = [[FaceAlertView alloc] initWithFrame:CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight)];
        __weak typeof(self) weakSelf = self;
        _alert.scanFaceBlock = ^(NSDictionary *dataDic, NSString *str, NSString *orderID, NSInteger btnState) {
            [weakSelf scanFaceAction:orderID responseObject:dataDic];
        };
    }
    return _alert;
}
#pragma mark -- 扫脸认证
-(void)scanFaceAction:(NSString *)order_id responseObject:(NSDictionary *)dic{
    if ([[FaceSDKManager sharedInstance] canWork]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络并重启APP" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击确认");
            exit(1);
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
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
                dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":order_id};
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
                            [self robOrderAction:dic order:order_id];
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
}
//抢单成功
-(void)robOrderAction:(NSDictionary *)dic order:(NSString *)order_id{
    
    OrdeModel *qiangOrder=[OrdeModel mj_objectWithKeyValues:dic[@"data"]];
    [CYTSI otherShowTostWithString:@"抢单成功，快去接驾吧~"];
    
    RobSuccessViewController * vc=[[RobSuccessViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.AlreadyListenBlock = ^{
        
    };
    vc.orderID=order_id;
    vc.endCoordinate=CLLocationCoordinate2DMake(qiangOrder.end_lat, qiangOrder.end_lng);
    vc.endAddress=qiangOrder.end_address;
    vc.endName = qiangOrder.end_name;
    vc.userStartCoordinate=CLLocationCoordinate2DMake(qiangOrder.start_lat, qiangOrder.start_lng);
    vc.userStartAddress=qiangOrder.start_address;
    vc.userStartname = qiangOrder.start_name;
    vc.userName=qiangOrder.passenger_name;
    vc.userPhone=qiangOrder.passenger_phone;
    vc.flight_date= qiangOrder.appoint_time;
    vc.m_card_number = qiangOrder.m_card_number;
    vc.m_header=qiangOrder.m_head;
    vc.appoint_time = qiangOrder.appoint_time;
    vc.remarkStr = qiangOrder.remark;
    vc.journey_fee=qiangOrder.journey_fee;
    vc.submit_class = qiangOrder.submit_class;
    vc.order_class= qiangOrder.order_class;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:order_id forKey:@"order_id"];
    [self.navigationController pushViewController:vc animated:YES];
    [self.alert removeFromSuperview];
}
//创建导航栏视图
-(void)setUpNav
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 20, 40);
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * lefItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=lefItem;
}
-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
