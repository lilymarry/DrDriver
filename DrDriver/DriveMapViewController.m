//
//  DriveMapViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/24.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "DriveMapViewController.h"

@interface DriveMapViewController () <AMapNaviDriveViewDelegate>{
    NSTimer * updatePriceTimer;//更新价格定时器
}


@end

@implementation DriveMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
//    NSLog(@"updatePriceTimerupdatePriceTimerupdatePriceTimer%@    %ld",updatePriceTimer,_orderState);
    if (updatePriceTimer == nil  &&  _orderState == 3) {
        [self savePointAndPlanDistance];
        updatePriceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(savePointAndPlanDistance) userInfo:nil repeats:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden=NO;
    
    [updatePriceTimer invalidate];
    updatePriceTimer = nil;
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
    
    //根据距离请求服务器价格
    [AFRequestManager postRequestWithUrl:DRIVER_JOURNEYORDER_CALC_JOURNEY_FEE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"order_id":_orderID,@"journey_mile":distanceStr,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:1 success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"开始导航";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    
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
    [self.navigationController popViewControllerAnimated:YES];
}


//创建主要视图
-(void)creatMainView
{
    [self.driveView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.view.backgroundColor = [UIColor colorWithRed:30/255.0 green:33/255.0 blue:41/255.0 alpha:1];
    [self.view addSubview:self.driveView];
    
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initDriveView];
    }
    return self;
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] init];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        self.driveView.lineWidth = 18;
        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
        self.driveView.normalTexture = [UIImage imageNamed:@"arrowTexture"];
        self.driveView.statusTextures = @{@(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"arrowTexture"],@(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"arrowTexture"],@(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"arrowTexture"],@(AMapNaviRouteStatusJam): [UIImage imageNamed:@"arrowTexture"],@(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"arrowTexture"]};

//        [self.driveView setCarImage:[UIImage imageNamed:@"navi_car"]];

        //辅助按钮
//        [self creatButtonView];

        [self.driveView setDelegate:self];
    }
}

//创建辅助按钮
-(void)creatButtonView
{
    UIButton * pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    pauseButton.layer.cornerRadius=22;
    pauseButton.layer.masksToBounds=YES;
    pauseButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    pauseButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [pauseButton addTarget:self action:@selector(pauseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    [pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.height.and.width.equalTo(@44);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
    }];
    
    UIButton * resumeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [resumeButton setTitle:@"继续" forState:UIControlStateNormal];
    resumeButton.layer.cornerRadius=22;
    resumeButton.layer.masksToBounds=YES;
    resumeButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    resumeButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [resumeButton addTarget:self action:@selector(resumeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeButton];
    [resumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@160);
        make.height.and.width.equalTo(@44);
        make.right.equalTo(self.view.mas_right).with.offset(-5);
    }];
}

//暂停按钮点击事件
-(void)pauseButtonClicked
{
    self.pauseClicked();
}

//继续按钮点击事件
-(void)resumeButtonClicked
{
    self.resumeClicked();
}

#pragma mark - DriveView Delegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    self.closeDrive();
}

- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    self.moreClicked();
//    //改变地图的追踪模式
//    if (self.driveView.trackingMode == AMapNaviViewTrackingModeCarNorth)
//    {
//        self.driveView.trackingMode = AMapNaviViewTrackingModeMapNorth;//地图指北
//    }
//    else if (self.driveView.trackingMode == AMapNaviViewTrackingModeMapNorth)
//    {
//        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;//车头指北
//    }
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    
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
