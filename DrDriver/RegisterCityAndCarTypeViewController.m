//
//  RegisterCityAndCarTypeViewController.m
//  DrDriver
//
//  Created by fy on 2019/3/12.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "RegisterCityAndCarTypeViewController.h"
#import "CityAndTypeTableViewCell.h"
#import "CityListViewController.h"
#import "Add_ONE_ViewController.h"
#import "Register_ONE_ViewController.h"

@interface RegisterCityAndCarTypeViewController ()<UITableViewDelegate,UITableViewDataSource,CityListViewDelegate>
@property(nonatomic,strong)UILabel *cityTitlelb;
@property(nonatomic,strong)UIView *cityBgView;
@property(nonatomic,strong)UILabel *cityLB;
@property(nonatomic,strong)UIImageView *cityImageView;

@property(nonatomic,strong)UILabel *typeLB;

@property(nonatomic,strong)UIView *chuzuBgView;
@property(nonatomic,strong)UILabel *chuzuTitleLB;
@property(nonatomic,strong)UIImageView *chuzuImageView;

@property(nonatomic,strong)UIView *kuaicheBgView;
@property(nonatomic,strong)UILabel *kuaicheTitleLB;
@property(nonatomic,strong)UIImageView *kuaicheImageView;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *btn;

@property(nonatomic,strong)NSMutableArray *chuzuArr;
@property(nonatomic,strong)NSMutableArray *kuaicheArr;

@property(nonatomic,copy)NSString *selectType;
@property(nonatomic,copy)NSString *class_name;
@property(nonatomic,copy)NSString *driver_class;
@property(nonatomic,copy)NSString *city;

@property(nonatomic,strong)UILabel *noDataLB;

@property(nonatomic,strong)UILabel *failLB;

@end

@implementation RegisterCityAndCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.selectType = @"0";
    self.class_name = @"";
    self.driver_class = @"";
    self.city = @"";
    self.kuaicheArr = [NSMutableArray array];
    self.chuzuArr = [NSMutableArray array];
    [self setUpNav];
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self creatMainView];
    
    if ([self.type isEqualToString:@"login"]) {
        if ([self.ModelDic[@"city_name"] isEqualToString:@""]) {
            
        }else{
            self.city = self.ModelDic[@"city_name"];
            self.cityLB.text = self.ModelDic[@"city_name"];
        }
//        self.driver_class = _ModelDic[@"driver_class"];
//        if ([_ModelDic[@"driver_class"] isEqualToString:@"1"]) {
//            self.class_name = @"快车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"2"]){
//            self.class_name = @"出租车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"3"]){
//            self.class_name = @"扫码车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"4"]){
//            self.class_name = @"专车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"5"]){
//            self.class_name = @"豪华车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"6"]){
//           self.class_name = @"包车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"7"]){
//            self.class_name = @"出租快车";
//        }else if ([_ModelDic[@"driver_class"] isEqualToString:@"8"]){
//            self.class_name = @"城际自由行";
//        }
        self.failLB.hidden = NO;
        self.failLB.text = [NSString stringWithFormat:@" %@",_ModelDic[@"audit_fail_reason"]];
        [self.cityTitlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(10);
            make.top.equalTo(self.failLB.mas_bottom).mas_offset(10);
        }];
        [self creatHttp:self.city];
    }else{
        self.failLB.hidden = YES;
        [self.cityTitlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(10);
            make.top.equalTo(self.view).mas_offset(k_Height_NavBar+10);
        }];
    }
}
-(void)creatHttp:(NSString *)city{
    [AFRequestManager postRequestWithUrl:DRIVER_LOGIN_REGISTER_TYPE params:@{@"city_name":city} tost:YES special:0 success:^(id responseObject) {
        [self.chuzuArr removeAllObjects];
        [self.kuaicheArr removeAllObjects];
        self.chuzuArr = [responseObject[@"data"][@"taxi"] mutableCopy];
        self.kuaicheArr = [responseObject[@"data"][@"notaxi"] mutableCopy];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)selectCityAction{
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
    //定位城市列表
    //    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:@"天津", nil];
    cityListView.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cityListView animated:YES completion:nil];
}
#pragma mark - CityListViewDelegate
- (void)didClickedWithCityName:(NSString*)cityName
{
    self.city  = cityName;
    self.cityLB.text = cityName;
    self.class_name = @"-";
    self.driver_class = @"";
    self.selectType = @"0";
    self.chuzuTitleLB.textColor = [UIColor blackColor];
    self.kuaicheTitleLB.textColor = [UIColor blackColor];
    self.chuzuImageView.image = [UIImage imageNamed:@"右箭头q"];
    self.kuaicheImageView.image = [UIImage imageNamed:@"右箭头q"];
    self.tableView.hidden = YES;
    self.noDataLB.hidden = YES;
    [self creatHttp:cityName];
}
-(void)chuzuAction{
    if ([self.city isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请先选择城市"];
    }else{
        if ([self.selectType isEqualToString:@"0"] || [self.selectType isEqualToString:@"2"]) {
            self.chuzuTitleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
            self.kuaicheTitleLB.textColor = [UIColor blackColor];
            self.chuzuImageView.image = [UIImage imageNamed:@"下箭头q"];
            self.kuaicheImageView.image = [UIImage imageNamed:@"右箭头q"];
            self.selectType = @"1";
            if (self.chuzuArr.count == 0) {
                self.tableView.hidden = YES;
                self.noDataLB.hidden = NO;
            }else{
                self.tableView.hidden = NO;
                self.noDataLB.hidden = YES;
                [self.tableView reloadData];
            }
        }else if ([self.selectType isEqualToString:@"1"]){
            self.chuzuTitleLB.textColor = [UIColor blackColor];
            self.chuzuImageView.image = [UIImage imageNamed:@"右箭头q"];
            self.selectType = @"0";
            self.tableView.hidden = YES;
            self.noDataLB.hidden = YES;
        }
    }
}
-(void)kuaicheAction{
    if ([self.city isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请先选择城市"];
    }else{
        if ([self.selectType isEqualToString:@"0"] || [self.selectType isEqualToString:@"1"]) {
            self.chuzuTitleLB.textColor = [UIColor blackColor];
            self.kuaicheTitleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
            self.chuzuImageView.image = [UIImage imageNamed:@"右箭头q"];
            self.kuaicheImageView.image = [UIImage imageNamed:@"下箭头q"];
            self.selectType = @"2";
            if (self.kuaicheArr.count == 0) {
                self.tableView.hidden = YES;
                self.noDataLB.hidden = NO;
            }else{
                self.tableView.hidden = NO;
                self.noDataLB.hidden = YES;
                [self.tableView reloadData];
            }
        }else if ([self.selectType isEqualToString:@"2"]){
            self.kuaicheTitleLB.textColor = [UIColor blackColor];
            self.kuaicheImageView.image = [UIImage imageNamed:@"右箭头q"];
            self.selectType = @"0";
            self.selectType = @"0";
            self.tableView.hidden = YES;
            self.noDataLB.hidden = YES;
        }
    }
}
-(void)affirmAction{
    if ([self.city isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请选择城市"];
        return;
    }
    if ([self.driver_class isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请选择运营类型"];
        return;
    }
    if ([self.type isEqualToString:@"login"]) {
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Add_ONE_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Add_ONE_id"];
        RVC.driver = self.driver;
        RVC.ModelDic = self.ModelDic;
        RVC.choosedCity=self.city;
        RVC.driver_class = self.driver_class;
        RVC.faceState = @"main";
        [self.navigationController pushViewController:RVC animated:YES];
    }else{
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Register_ONE_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Register_ONE_id"];
        RVC.choosedCity=self.city;
        RVC.driver_class = self.driver_class;
        RVC.driver=self.driver;
        [self.navigationController pushViewController:RVC animated:YES];
    }
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.selectType isEqualToString:@"1"]) {
        return self.chuzuArr.count;
    }else{
        return self.kuaicheArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityAndTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityAndTypeTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([self.selectType isEqualToString:@"1"]) {
        NSDictionary *dic = self.chuzuArr[indexPath.row];
        cell.typeTitleLB.text = dic[@"class_name"];
    }else{
        NSDictionary *dic = self.kuaicheArr[indexPath.row];
        cell.typeTitleLB.text = dic[@"class_name"];
    }
    if (![self.class_name isEqualToString:@"-"]) {
        if ([self.selectType isEqualToString:@"1"]) {
            NSDictionary *dic = self.chuzuArr[indexPath.row];
            if ([self.class_name isEqualToString:dic[@"class_name"]]) {
                cell.typeTitleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
                cell.typeImageView.image = [UIImage imageNamed:@"选择q"];
            }else{
                cell.typeTitleLB.textColor = [UIColor lightGrayColor];
                cell.typeImageView.image = [UIImage imageNamed:@"未选择q"];
            }
        }else{
            NSDictionary *dic = self.kuaicheArr[indexPath.row];
            if ([self.class_name isEqualToString:dic[@"class_name"]]) {
                cell.typeTitleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
                cell.typeImageView.image = [UIImage imageNamed:@"选择q"];
            }else{
                cell.typeTitleLB.textColor = [UIColor lightGrayColor];
                cell.typeImageView.image = [UIImage imageNamed:@"未选择q"];
            }
        }
    }else{
        cell.typeTitleLB.textColor = [UIColor lightGrayColor];
        cell.typeImageView.image = [UIImage imageNamed:@"未选择q"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectType isEqualToString:@"1"]) {
        NSDictionary *dic = self.chuzuArr[indexPath.row];
        self.class_name = dic[@"class_name"];
        self.driver_class = [NSString stringWithFormat:@"%@",dic[@"driver_class"]];
    }else{
        NSDictionary *dic = self.kuaicheArr[indexPath.row];
        self.class_name = dic[@"class_name"];
        self.driver_class = [NSString stringWithFormat:@"%@",dic[@"driver_class"]];
    }
    [self.tableView reloadData];
}
-(void)creatMainView{
    self.failLB = [[UILabel alloc] init];
    [self.view addSubview:self.failLB];
    self.failLB.layer.cornerRadius = 4;
    self.failLB.layer.borderWidth = 1;
    self.failLB.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.failLB.backgroundColor = [UIColor whiteColor];
    self.failLB.textColor = [UIColor redColor];
    [self.failLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(40);
        make.top.equalTo(self.view).mas_offset(k_Height_NavBar+10);
    }];
    
    self.cityTitlelb = [[UILabel alloc] init];
    self.cityTitlelb.text = @"服务城市";
    self.cityTitlelb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.cityTitlelb];
    [self.cityTitlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(10);
        make.top.equalTo(self.failLB.mas_bottom).mas_offset(10);
    }];
    
    UILabel *cityTitle = [[UILabel alloc] init];
    cityTitle.textColor = [UIColor redColor];
    cityTitle.font = [UIFont systemFontOfSize:15];
    cityTitle.text = @"*";
    [self.view addSubview:cityTitle];
    [cityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityTitlelb);
        make.left.equalTo(self.cityTitlelb.mas_right);
    }];
    
    UITapGestureRecognizer *cityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCityAction)];
    self.cityBgView = [[UIView alloc] init];
    [self.cityBgView addGestureRecognizer:cityTap];
    self.cityBgView.backgroundColor = [UIColor whiteColor];
    self.cityBgView.layer.borderWidth = 1;
    self.cityBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cityBgView.layer.cornerRadius = 5;
    [self.view addSubview:self.cityBgView];
    [self.cityBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityTitlelb.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_offset(44);
    }];
    
    self.cityLB = [[UILabel alloc] init];
    self.cityLB.text = @"请选择城市";
    [self.cityBgView addSubview:self.cityLB];
    self.cityLB.font = [UIFont systemFontOfSize:15];
    [self.cityLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityBgView);
        make.left.equalTo(self.cityBgView).offset(10);
    }];
    
    self.cityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头q"]];
    [self.cityBgView addSubview:self.cityImageView];
    [self.cityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityBgView);
        make.right.equalTo(self.cityBgView.mas_right).offset(-5);
        make.height.and.width.mas_offset(20);
    }];
    
    self.typeLB = [[UILabel alloc] init];
    self.typeLB.text = @"运营类型";
    self.typeLB.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.typeLB];
    [self.typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(10);
        make.top.equalTo(self.cityBgView.mas_bottom).offset(10);
    }];
    
    UILabel *typeTitle = [[UILabel alloc] init];
    typeTitle.textColor = [UIColor redColor];
    typeTitle.font = [UIFont systemFontOfSize:15];
    typeTitle.text = @"*";
    [self.view addSubview:typeTitle];
    [typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLB);
        make.left.equalTo(self.typeLB.mas_right);
    }];
    
    UITapGestureRecognizer *chuzuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chuzuAction)];
    self.chuzuBgView = [[UIView alloc] init];
    [self.chuzuBgView addGestureRecognizer:chuzuTap];
    self.chuzuBgView.backgroundColor = [UIColor whiteColor];
    self.chuzuBgView.layer.borderWidth = 1;
    self.chuzuBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.chuzuBgView.layer.cornerRadius = 5;
    [self.view addSubview:self.chuzuBgView];
    [self.chuzuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLB.mas_bottom).offset(10);
        make.left.equalTo(self.view).mas_offset(10);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.height.mas_offset(44);
    }];
    
    self.chuzuTitleLB = [[UILabel alloc] init];
    self.chuzuTitleLB.text = @"出租车";
    self.chuzuTitleLB.font = [UIFont systemFontOfSize:15];
    [self.chuzuBgView addSubview:self.chuzuTitleLB];
    [self.chuzuTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chuzuBgView);
        make.left.equalTo(self.chuzuBgView).offset(10);
    }];
    
    self.chuzuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头q"]];
    [self.chuzuBgView addSubview:self.chuzuImageView];
    [self.chuzuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chuzuBgView);
        make.right.equalTo(self.chuzuBgView.mas_right).offset(-10);
        make.width.and.height.mas_offset(20);
    }];
    
    UITapGestureRecognizer *kuaicheTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kuaicheAction)];
    self.kuaicheBgView = [[UIView alloc] init];
    [self.kuaicheBgView addGestureRecognizer:kuaicheTap];
    self.kuaicheBgView.backgroundColor = [UIColor whiteColor];
    self.kuaicheBgView.layer.borderWidth = 1;
    self.kuaicheBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.kuaicheBgView.layer.cornerRadius = 5;
    [self.view addSubview:self.kuaicheBgView];
    [self.kuaicheBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLB.mas_bottom).offset(10);
        make.right.equalTo(self.view).mas_offset(-10);
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.height.mas_offset(44);
    }];
    
    self.kuaicheTitleLB = [[UILabel alloc] init];
    self.kuaicheTitleLB.text = @"非出租车";
    self.kuaicheTitleLB.font = [UIFont systemFontOfSize:15];
    [self.kuaicheBgView addSubview:self.kuaicheTitleLB];
    [self.kuaicheTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.kuaicheBgView);
        make.left.equalTo(self.kuaicheBgView).offset(10);
    }];
    
    self.kuaicheImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头q"]];
    [self.kuaicheBgView addSubview:self.kuaicheImageView];
    [self.kuaicheImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.kuaicheBgView);
        make.right.equalTo(self.kuaicheBgView.mas_right).offset(-10);
        make.width.and.height.mas_offset(20);
    }];
    
    self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:self.btn];
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;
    [self.btn setTitle:@"下一步" forState:(UIControlStateNormal)];
    [self.btn setBackgroundColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.btn addTarget:self action:@selector(affirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(44);
        make.bottom.equalTo(self.view).offset(-20 - Bottom_Height);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 300) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CityAndTypeTableViewCell class] forCellReuseIdentifier:@"CityAndTypeTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.kuaicheBgView.mas_bottom).offset(10);
        make.width.mas_offset(DeviceWidth - 20);
        make.bottom.equalTo(self.btn.mas_top).offset(-20);
    }];
    self.tableView.hidden = YES;
    
    
    self.noDataLB = [[UILabel alloc] init];
    self.noDataLB.text = @"该城市未开通此类运营服务";
    self.noDataLB.textColor = [UIColor lightGrayColor];
    self.noDataLB.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.noDataLB];
    [self.noDataLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.kuaicheBgView.mas_bottom).offset(50);
    }];
    self.noDataLB.hidden = YES;
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
