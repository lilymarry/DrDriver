//
//  ITAddressViewController.m
//  DrDriver
//
//  Created by fy on 2019/1/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITAddressViewController.h"
#import "SearchTopView.h"
#import "ShouYeTableViewCell.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CityListViewController.h"

@interface ITAddressViewController ()<UITextFieldDelegate, AMapLocationManagerDelegate,CityListViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *currentPage;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)SearchTopView *titleTopView;

@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,assign)CLLocationCoordinate2D currentCoordinate;//当前定位经纬度

@property(nonatomic,strong)UILabel *cityLB;//导航栏城市
//轮播图图片数组
@property(nonatomic,strong)NSArray *imageArr;

@property(nonatomic,strong)UILabel *nodataLB;//暂无数据
@property(nonatomic,strong)NSArray *poiArr;
@end

@implementation ITAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleTopView.CommericalTenantTF becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleTopView.CommericalTenantTF resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUpNav];
    
    self.poiArr  = [NSArray array];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    
    [self StartLocation];
}
//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 20, 15);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityAction)];
    
    UIView *cityLBView = [[UIView alloc] init];
    cityLBView.frame = CGRectMake(0, 0, 70.0/414.0 * DeviceWidth, 20);
    
    self.cityLB = [[UILabel alloc] init];
    self.cityLB.frame=CGRectMake(0, 0, 70.0/414.0 * DeviceWidth, 20);
    self.cityLB.userInteractionEnabled = YES;
    self.cityLB.font = [UIFont systemFontOfSize:15];
    self.cityLB.text = @"选择位置";
    self.cityLB.textColor = [UIColor whiteColor];
    self.cityLB.textAlignment = NSTextAlignmentCenter;
    [self.cityLB addGestureRecognizer:titleTap];
    [cityLBView addSubview:self.cityLB];
    UIBarButtonItem *cityButtonItem=[[UIBarButtonItem alloc]initWithCustomView:cityLBView];
    
    UIView *iView = [[UIView alloc] init];
    iView.frame = CGRectMake(0, 0, 20.0/414.0 * DeviceWidth, 20.0/414.0 * DeviceWidth);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"返回"];
    imageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    imageView.frame=CGRectMake(0, 0, 18.0/414.0 * DeviceWidth, 15.0/414.0 * DeviceWidth);
    imageView.center = iView.center;
    [iView addSubview:imageView];
    UIBarButtonItem * locationItem=[[UIBarButtonItem alloc]initWithCustomView:iView];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftItem,cityButtonItem,locationItem,nil]];
    
    
    
    self.titleTopView = [[SearchTopView alloc] initWithFrame:CGRectMake(0, 0, 250.0/414.0 * DeviceWidth, 30) withName:@"搜索商家"];
    self.titleTopView.layer.cornerRadius = 15;
    self.titleTopView.CommericalTenantTF.delegate = self;
    self.navigationItem.titleView = self.titleTopView;
    [self.titleTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(250.0/414.0 * DeviceWidth);
        make.height.mas_offset(30);
        make.top.and.left.equalTo(self.navigationItem.titleView);
    }];
    [self.titleTopView.CommericalTenantTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];

    
    
}
#pragma mark - 表的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArr.count;
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
    
    AMapPOI * poi=self.poiArr[indexPath.row];
    cell.nameLable.text=poi.name;
    cell.detailNameLable.text=poi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.titleTopView.CommericalTenantTF resignFirstResponder];
    AMapPOI * poi=self.poiArr[indexPath.row];
    NSDictionary *dic = @{@"province":poi.province,@"city":poi.city,@"county":poi.district,@"address":poi.address,@"lng":[NSString stringWithFormat:@"%f",poi.location.longitude],@"lat":[NSString stringWithFormat:@"%f",poi.location.latitude],@"name":poi.name};
//    NSLog(@"%@dddddddddd",dic);
    self.addressBlock(dic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFiled 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.titleTopView.CommericalTenantTF resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)textFieldChangeText:(UITextField *)textField
{
    if (textField.text!=nil && ![textField.text isEqualToString:@""]) {
//        NSLog(@"search111111111");
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        
        request.keywords            = textField.text;
        request.city                = self.cityLB.text;
        request.requireExtension    = YES;
        
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        request.cityLimit           = YES;
        request.requireSubPOIs      = YES;
        
        [self.search AMapPOIKeywordsSearch:request];
    }
}
#pragma mark --------- AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    self.poiArr = response.pois;
    if (self.poiArr.count==0) {
        self.tableView.hidden=YES;
    } else {
        self.tableView.hidden=NO;
    }
    
    [self.tableView reloadData];
    
}
#pragma mark - CityListViewDelegate
- (void)didClickedWithCityName:(NSString*)cityName
{
    self.cityLB.text  = cityName;
    self.titleTopView.CommericalTenantTF.text = @"";
    self.poiArr = @[];
    [self.tableView reloadData];
}
-(void)cityAction{
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
    
    //定位城市列表
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:@"天津", nil];
    cityListView.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cityListView animated:YES completion:nil];
}
#pragma mark - 定位相关

//开始定位
-(void)StartLocation
{
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout =2;
    self.locationManager.reGeocodeTimeout = 2;
    __weak typeof(self) weakSelf = self;

    //    AMapLocationErrorCode
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        if (error)
        {

//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            [CYTSI otherShowTostWithString:@"定位失败，请重试"];
//            self.currentCoordinate = CLLocationCoordinate2DMake(self.user_lat, self.user_lng);

            self.cityLB.text = @"选择城市";

            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }else{
            //            NSLog(@"regeocode ========= %f %f",location.coordinate.latitude,location.coordinate.longitude);
            weakSelf.currentCoordinate = location.coordinate;
            weakSelf.cityLB.text = regeocode.city;
//            NSLog(@"regeocode.cityregeocode.city%@",regeocode.city);

        }

    }];
}
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:NSClassFromString(@"CommercialTenantTableViewCell") forCellReuseIdentifier:@"CommercialTenantTableViewCell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(void)navBackButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
