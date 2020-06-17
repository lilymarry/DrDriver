//
//  ITUserDetailViewController.m
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITUserDetailViewController.h"
#import "ITOrderDriverDetailView.h"
#import "ITOrderDetailView.h"
#import "ITOrderView.h"
#import "InTravelMapViewController.h"
#import "GetOrderAlertView.h"
#import "ITTripDetailViewController.h"


@interface ITUserDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)ITOrderDriverDetailView *ITDriverDetailView;
@property(nonatomic,strong)ITOrderDetailView *orderDetailView;
@property(nonatomic,strong)ITOrderView *orderView;
@property(nonatomic,strong)UIButton *orderBtn;
@property(nonatomic,strong)GetOrderAlertView *alertView;
@end

@implementation ITUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    [self setUpNav];
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k_Height_NavBar, DeviceWidth, DeviceHeight - k_Height_NavBar - Bottom_Height)];
    self.scrollView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.scrollView.layer.cornerRadius = 6;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(DeviceWidth, 695 + Bottom_Height);
    [self.view addSubview:self.scrollView];
    
    self.orderDetailView = [[ITOrderDetailView alloc] initWithFrame:CGRectMake(0, 10, DeviceWidth, 255)];
    __weak typeof(self) weakSelf = self;
    self.orderDetailView.mapBlock = ^(NSDictionary * _Nonnull dataDic) {
        InTravelMapViewController *mapView = [[InTravelMapViewController alloc] init];
        mapView.dic = dataDic;
        [weakSelf.navigationController pushViewController:mapView animated:YES];
    };
    [self.scrollView addSubview:self.orderDetailView];
    
    self.ITDriverDetailView = [[ITOrderDriverDetailView alloc] initWithFrame:CGRectMake(0, 275, DeviceWidth, 150)];
    [self.scrollView addSubview:self.ITDriverDetailView];
    
    self.orderView = [[ITOrderView alloc] initWithFrame:CGRectMake(0, 435, DeviceWidth, 100)];
//    self.orderView.kefuBlock = ^{
//
//    };
    [self.scrollView addSubview:self.orderView];
    
    self.orderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderBtn addTarget:self action:@selector(OrderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.orderBtn setImage:[UIImage imageNamed:@"抢单按钮"] forState:(UIControlStateNormal)];
    [self.scrollView addSubview:self.orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.and.height.mas_offset(100);
        make.top.equalTo(self.orderView.mas_bottom).offset(60);
    }];
    
    self.alertView = [[GetOrderAlertView alloc] initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight)];
    self.alertView.popViewBlock = ^(NSString * _Nonnull travel_id) {
        if ([weakSelf.state isEqualToString:@"find"]) {
            NSArray * vcArray=weakSelf.navigationController.viewControllers;
            for (ITTripDetailViewController * vc in vcArray) {
                if ([vc isKindOfClass:[ITTripDetailViewController class]]) {
                    vc.state = @"getdata";
                    [vc getData];
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{
            weakSelf.getMainData();
            ITTripDetailViewController *vc = [[ITTripDetailViewController alloc] init];
            vc.travelID = travel_id;
            vc.state = @"user";
            vc.isCanListen = weakSelf.isCanListen;
            vc.getDateBlock = ^{
                
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.view addSubview:self.alertView];
    
    [self creatHttp];
}
-(void)creatHttp{
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_USER_ORDER_DETAIL params:@{@"order_id":self.order_id} tost:YES special:0 success:^(id responseObject) {
        NSDictionary *dic = responseObject[@"data"];
//        NSLog(@"dicdic%@",dic);
        [self.orderDetailView setData:dic];
        [self.ITDriverDetailView setData:dic];
        [self.orderView setData:dic];
        if ([dic[@"order_state"] isEqualToString:@"11"]) {
            self.orderBtn.hidden = NO;
        }else{
           self.orderBtn.hidden = YES;
        }
        if ([dic[@"order_type"] isEqualToString:@"1"]) {
            self.orderBtn.userInteractionEnabled = YES;
        }else{
            self.orderBtn.userInteractionEnabled = NO;
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)OrderButtonClicked{
    if (self.isCanListen) {
        NSDictionary *dic = [NSDictionary dictionary];
        if ([self.state isEqualToString:@"find"]) {
            dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":self.order_id,@"travel_id":self.travel_id};
        }else{
            dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_id":self.order_id};
        }
        [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_GRAB_ORDER params:dic tost:YES special:0 success:^(id responseObject) {
            if ([responseObject[@"message"] isEqualToString:@"抢单成功"]) {
                [self.alertView showOrderAlertView:responseObject[@"data"][@"travel_id"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能抢单"];
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
}
-(void)navBackButtonClicked{
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
