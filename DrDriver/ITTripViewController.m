//
//  ITTripViewController.m
//  DrDriver
//
//  Created by fy on 2019/5/23.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITTripViewController.h"
#import "TripViewController.h"
#import "ITScanTripViewController.h"

@interface ITTripViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property(nonatomic,strong)TripViewController *tripVC;
@property(nonatomic,strong)ITScanTripViewController *scanTripVC;
@property(nonatomic,strong)UIButton *tripBtn;
@property(nonatomic,strong)UIButton *scanTripBtn;

@end

@implementation ITTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"行程";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self setUpNav];
    [self createUI];
}
- (void)createUI
{
    [self.view addSubview:self.bgScrollView];
    
    //普通行程
    self.tripVC.view.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 114);
    [self addChildViewController:self.tripVC];
    [self.bgScrollView addSubview:self.tripVC.view];//把子控制器的 view 添加到父控制器的 view 上面
    //包车行程
    self.scanTripVC.view.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight - 114);
    [self addChildViewController:self.scanTripVC];
    [self.bgScrollView addSubview:self.scanTripVC.view];

    self.bgScrollView.contentSize = CGSizeMake(2*DeviceWidth, DeviceHeight - 200);
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, 50)];
    if (DeviceHeight>737) {
        view.frame = CGRectMake(0, 64 + 24, DeviceWidth, 50);
    }
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.shadowColor = [UIColor colorWithRed:110/255.0 green:109/255.0 blue:124/255.0 alpha:1].CGColor;//阴影颜色
    view.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    view.layer.shadowOpacity = 0.3;//不透明度
    view.layer.shadowRadius = 3;//半径
    
    self.tripBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [view addSubview:self.tripBtn];
    [self.tripBtn setTitle:@"自由行" forState:(UIControlStateNormal)];
    [self.tripBtn addTarget:self action:@selector(moneyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tripBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.tripBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.width.mas_offset(DeviceWidth / 2);
    }];
    
    self.scanTripBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [view addSubview:self.scanTripBtn];
    [self.scanTripBtn addTarget:self action:@selector(discountAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scanTripBtn setTintColor:[UIColor blackColor]];
    [self.scanTripBtn setTitle:@"扫码支付" forState:(UIControlStateNormal)];
    [self.scanTripBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(view);
        make.left.equalTo(self.tripBtn.mas_right);
        make.width.mas_offset(DeviceWidth / 2);
    }];
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
-(void)moneyAction{
    [self.tripBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.scanTripBtn setTintColor:[UIColor blackColor]];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollView.contentOffset = CGPointMake(0, 0);
    }];
}
-(void)discountAction{
    [self.tripBtn setTintColor:[UIColor blackColor]];
    [self.scanTripBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollView.contentOffset = CGPointMake(DeviceWidth, 0);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self.tripBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
        [self.scanTripBtn setTintColor:[UIColor blackColor]];
    }else if(scrollView.contentOffset.x == DeviceWidth){
        [self.tripBtn setTintColor:[UIColor blackColor]];
        [self.scanTripBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    }
}

- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 114 + Top_Height, DeviceWidth, DeviceHeight - 114)];
        _bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.bounces = NO;
        _bgScrollView.delegate = self;
    }
    return _bgScrollView;
}

-(TripViewController *)tripVC{
    if (!_tripVC){
        _tripVC = [[TripViewController alloc] init];
    }
    return _tripVC;
}

-(ITScanTripViewController *)scanTripVC{
    if (!_scanTripVC){
        _scanTripVC = [[ITScanTripViewController alloc] init];
    }
    return _scanTripVC;
}


//导航栏返回按钮
-(void)backButtonClicked
{
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
