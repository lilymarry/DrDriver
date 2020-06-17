//
//  SelectPathViewController.m
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SelectPathViewController.h"
#import "GFAddressPicker.h"
#import "ITUserSearchModel.h"
#import "ITUserTableViewCell.h"
#import "CreationOrderViewController.h"
#import "ITSelectAddressViewController.h"

@interface SelectPathViewController ()
<UITableViewDelegate,UITableViewDataSource,GFAddressPickerDelegate>{
    NSString * currentPage;//当前分页数
}

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)GFAddressPicker *pickerView;
@property(nonatomic,strong)ITUserSearchModel *searchModel;

@end

@implementation SelectPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"选择线路";
    [self setUpNav];//设置导航栏
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.dataArr = [NSMutableArray array];
    self.searchModel  = [[ITUserSearchModel alloc] init];
    currentPage = @"1";
    [self.searchModel setValue:self.start_province forKey:@"start_province"];
    [self.searchModel setValue:self.start_city forKey:@"start_city"];
    [self.searchModel setValue:@"" forKey:@"start_county"];
    [self.searchModel setValue:self.start_province forKey:@"end_province"];
    [self.searchModel setValue:self.start_city forKey:@"end_city"];
    [self.searchModel setValue:@"" forKey:@"end_county"];
    
    [self.searchModel setValue:@"-" forKey:@"start_name"];
    [self.searchModel setValue:@"-" forKey:@"start_address"];
    [self.searchModel setValue:@"-" forKey:@"start_lat"];
    [self.searchModel setValue:@"-" forKey:@"start_lng"];
    
    [self.searchModel setValue:@"-" forKey:@"end_name"];
    [self.searchModel setValue:@"-" forKey:@"end_address"];
    [self.searchModel setValue:@"-" forKey:@"end_lat"];
    [self.searchModel setValue:@"-" forKey:@"end_lng"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSearch) name:@"changeUserSearch" object:nil];
    
    [self creatTopView];
    [self creatTableView];
    [self creatHttp];
}
-(void)changeSearch{
    currentPage = @"1";
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
-(void)creatHttp{
    NSString *start_province = @"";NSString *start_city = @"";NSString *start_county = @"";NSString *end_province = @"";NSString *end_city = @"";NSString *end_county = @"";NSString *start_name = @"";NSString *start_address = @"";NSString *start_lat = @"";NSString *start_lng = @"";NSString *end_name = @"";NSString *end_address = @"";NSString *end_lat = @"";NSString *end_lng = @"";
    
    if (![self.searchModel.start_province isEqualToString:@"-"] && self.searchModel.start_province != nil) {
        start_province = self.searchModel.start_province;
    }
    if (![self.searchModel.start_city isEqualToString:@"-"] && self.searchModel.start_city != nil) {
        start_city = self.searchModel.start_city;
    }
    if (![self.searchModel.start_county isEqualToString:@"-"] && self.searchModel.start_county != nil) {
        start_county = self.searchModel.start_county;
    }
    if (![self.searchModel.end_province isEqualToString:@"-"] && self.searchModel.end_province != nil) {
        end_province = self.searchModel.end_province;
    }
    if (![self.searchModel.end_city isEqualToString:@"-"] && self.searchModel.end_city != nil) {
        end_city = self.searchModel.end_city;
    }
    if (![self.searchModel.end_county isEqualToString:@"-"] && self.searchModel.end_county != nil) {
        end_county = self.searchModel.end_county;
    }
    
    if (![self.searchModel.start_name isEqualToString:@"-"] && self.searchModel.start_name != nil) {
        start_name = self.searchModel.start_name;
    }
    if (![self.searchModel.start_address isEqualToString:@"-"] && self.searchModel.start_address != nil) {
        start_address = self.searchModel.start_address;
    }
    if (![self.searchModel.start_lat isEqualToString:@"-"] && self.searchModel.start_lat != nil) {
        start_lat = self.searchModel.start_lat;
    }
    if (![self.searchModel.start_lng isEqualToString:@"-"] && self.searchModel.start_lng != nil) {
        start_lng = self.searchModel.start_lng;
    }
    
    if (![self.searchModel.end_name isEqualToString:@"-"] && self.searchModel.end_name != nil) {
        end_name = self.searchModel.end_name;
    }
    if (![self.searchModel.end_address isEqualToString:@"-"] && self.searchModel.end_address != nil) {
        end_address = self.searchModel.end_address;
    }
    if (![self.searchModel.end_lat isEqualToString:@"-"] && self.searchModel.end_lat != nil) {
        end_lat = self.searchModel.end_lat;
    }
    if (![self.searchModel.end_lng isEqualToString:@"-"] && self.searchModel.end_lng != nil) {
        end_lng = self.searchModel.end_lng;
    }
    NSDictionary *dic = @{@"p":currentPage,@"start_province":start_province,@"start_city":start_city,@"start_county":start_county,@"end_province":end_province,@"end_city":end_city,@"end_county":end_county,@"start_name":start_name,@"start_address":start_address,@"start_lat":start_lat,@"start_lng":start_lng,@"end_name":end_name,@"end_address":end_address,@"end_lat":end_lat,@"end_lng":end_lng};
//    NSLog(@"NSDictionary *dic =%@",dic);
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_LINE_LIST params:dic tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"responseObjectresponseObject%@",responseObject);
        
        if ([currentPage intValue]==1) {
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        if ([currentPage intValue]>[responseObject[@"total_page"] intValue]) {
            [self.tableView .mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100 + k_Height_NavBar, DeviceWidth, self.view.frame.size.height - 100 - Bottom_Height - k_Height_NavBar) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ITUserTableViewCell class] forCellReuseIdentifier:@"ITUserTableViewCell"];
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 34 : 0;
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
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ITUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITUserTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setData:self.dataArr[indexPath.row]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    CreationOrderViewController *vc = [[CreationOrderViewController alloc] init];
    vc.line_id = dic[@"line_id"];
    __weak typeof(self) weakSelf = self;
    vc.getData = ^{
        weakSelf.getMainData();
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)creatTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 5 + k_Height_NavBar, DeviceWidth, 90)];
    [self.view addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAddressAction)];
    self.ITstartAddressBtn = [[UIView alloc] init];
    [self.ITstartAddressBtn addGestureRecognizer:startTap];
    [self.topView addSubview:self.ITstartAddressBtn];
    [self.ITstartAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(10);
        make.centerX.mas_offset(-DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2);
        make.height.mas_offset(25);
    }];
    
    self.ITstartLB = [[UILabel alloc] init];
    if (self.start_city == nil) {
        self.ITstartLB.text = @"上车点";
    }else{
        self.ITstartLB.text = self.start_city;
    }
    self.ITstartLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    self.ITstartLB.font = [UIFont systemFontOfSize:15];
    [self.ITstartAddressBtn addSubview:self.ITstartLB];
    [self.ITstartLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITstartAddressBtn);
        make.centerX.equalTo(self.ITstartAddressBtn.mas_centerX).offset(-3);
    }];
    
    self.ITstartImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.ITstartAddressBtn addSubview:self.ITstartImage];
    [self.ITstartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITstartLB);
        make.left.equalTo(self.ITstartLB.mas_right);
    }];
    
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAddressAction)];
    self.ITendAddressBtn = [[UIView alloc] init];
    [self.ITendAddressBtn addGestureRecognizer:endTap];
    [self.topView addSubview:self.ITendAddressBtn];
    [self.ITendAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(10);
        make.centerX.mas_offset(DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2);
        make.height.mas_offset(25);
    }];
    
    self.ITendLB = [[UILabel alloc] init];
    if (self.start_city == nil) {
        self.ITendLB.text = @"到达点";
    }else{
        self.ITendLB.text = self.start_city;
    }
    self.ITendLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    self.ITendLB.font = [UIFont systemFontOfSize:15];
    [self.ITendAddressBtn addSubview:self.ITendLB];
    [self.ITendLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITendAddressBtn);
        make.centerX.equalTo(self.ITendAddressBtn.mas_centerX).offset(-3);
    }];
    
    self.ITendImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.ITendAddressBtn addSubview:self.ITendImage];
    [self.ITendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITendLB);
        make.left.equalTo(self.ITendLB.mas_right);
    }];
    
    UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, DeviceWidth - 20, 1)];
    lineLB.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self.topView addSubview:lineLB];
    //起点地址
    UITapGestureRecognizer *ITTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startplaceAction)];
    self.ITTimeBtn = [[UIView alloc] init];
    [self.ITTimeBtn addGestureRecognizer:ITTimeTap];
    [self.topView addSubview:self.ITTimeBtn];
    [self.ITTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(-DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2);
        make.height.mas_offset(25);
        make.top.equalTo(lineLB.mas_top).offset(10);
    }];
    
    self.ITTimeLB = [[UILabel alloc] init];
    self.ITTimeLB.text = @"上车点";
    self.ITTimeLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    self.ITTimeLB.font = [UIFont systemFontOfSize:15];
    [self.ITTimeBtn addSubview:self.ITTimeLB];
    [self.ITTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITTimeBtn);
        make.centerX.equalTo(self.ITTimeBtn.mas_centerX).offset(-3);
    }];
    
    self.ITTimeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.ITTimeBtn addSubview:self.ITTimeImage];
    [self.ITTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITTimeLB);
        make.left.equalTo(self.ITTimeLB.mas_right);
    }];
    ///////终点z地址
    UITapGestureRecognizer *ITNumberTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endPlaceAction)];
    self.ITNumberBtn = [[UIView alloc] init];
    [self.ITNumberBtn addGestureRecognizer:ITNumberTap];
    [self.topView addSubview:self.ITNumberBtn];
    [self.ITNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(DeviceWidth/4);
        make.width.mas_offset(DeviceWidth/2);
        make.height.mas_offset(25);
        make.top.equalTo(lineLB.mas_top).offset(10);
    }];
    
    self.ITNumberLB = [[UILabel alloc] init];
    self.ITNumberLB.text = @"下车点";
    self.ITNumberLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    self.ITNumberLB.font = [UIFont systemFontOfSize:15];
    [self.ITNumberBtn addSubview:self.ITNumberLB];
    [self.ITNumberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITNumberBtn);
        make.centerX.equalTo(self.ITNumberBtn.mas_centerX).offset(-3);
    }];
    
    self.ITNumberImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.ITNumberBtn addSubview:self.ITNumberImage];
    [self.ITNumberImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ITNumberLB);
        make.left.equalTo(self.ITNumberLB.mas_right);
    }];
}
-(void)startAddressAction{
    [self.view endEditing:YES];
    self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.frame.size.height + 154)];
    self.pickerView.delegate = self;
    self.pickerView.state = @"start";
    self.pickerView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.pickerView];
}
-(void)endAddressAction{
    [self.view endEditing:YES];
    self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.frame.size.height + 154)];
    self.pickerView.delegate = self;
    self.pickerView.state = @"end";
    self.pickerView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.pickerView];
}
//上车点
-(void)startplaceAction{
    ITSelectAddressViewController *vc = [[ITSelectAddressViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.placeBlock = ^(NSString * _Nonnull name, NSString * _Nonnull address, NSString * _Nonnull lat, NSString * _Nonnull lng) {
        if ([name isEqualToString:@"--"]) {
           
            [self.searchModel setValue:@"-" forKey:@"start_name"];
            [self.searchModel setValue:@"-" forKey:@"start_address"];
            [self.searchModel setValue:@"-" forKey:@"start_lat"];
            [self.searchModel setValue:@"-" forKey:@"start_lng"];
            
            self.ITTimeLB.text = @"上车点";
            [self creatHttp];
        }else{
            if (name.length > 6) {
                self.ITTimeLB.text = [NSString stringWithFormat:@"%@..",[name substringToIndex:6]];
            }else{
                self.ITTimeLB.text = name;
            }
            [self.searchModel setValue:name forKey:@"start_name"];
            [self.searchModel setValue:address forKey:@"start_address"];
            [self.searchModel setValue:lat forKey:@"start_lat"];
            [self.searchModel setValue:lng forKey:@"start_lng"];
            
            
            [self creatHttp];
        }
    };
    if ([self.searchModel.start_province isEqualToString:@"北京市"] || [self.searchModel.start_province isEqualToString:@"上海市"] || [self.searchModel.start_province isEqualToString:@"天津市"] || [self.searchModel.start_province isEqualToString:@"重庆市"]) {
        vc.city = self.searchModel.start_province;
        [self presentViewController:vc animated:YES completion:nil];
    }else if([self.searchModel.start_city isEqualToString:@"不限"]){
        [CYTSI otherShowTostWithString:@"请选择上车城市"];
    }else if([self.searchModel.start_city isEqualToString:@"-"]){
        [CYTSI otherShowTostWithString:@"请选择上车城市"];
    }else{
        vc.city = self.searchModel.start_city;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
//下车点
-(void)endPlaceAction{
    ITSelectAddressViewController *vc = [[ITSelectAddressViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.placeBlock = ^(NSString * _Nonnull name, NSString * _Nonnull address, NSString * _Nonnull lat, NSString * _Nonnull lng) {
        if ([name isEqualToString:@"--"]) {
            self.ITNumberLB.text = @"下车点";
            
            [self.searchModel setValue:@"-" forKey:@"end_name"];
            [self.searchModel setValue:@"-" forKey:@"end_address"];
            [self.searchModel setValue:@"-" forKey:@"end_lat"];
            [self.searchModel setValue:@"-" forKey:@"end_lng"];
            
            [self creatHttp];
        }else{
            if (name.length > 6) {
                self.ITNumberLB.text = [NSString stringWithFormat:@"%@..",[name substringToIndex:6]];
            }else{
                self.ITNumberLB.text = name;
            }
            [self.searchModel setValue:name forKey:@"end_name"];
            [self.searchModel setValue:address forKey:@"end_address"];
            [self.searchModel setValue:lat forKey:@"end_lat"];
            [self.searchModel setValue:lng forKey:@"end_lng"];
            
            [self creatHttp];
        }
    };
    if ([self.searchModel.end_province isEqualToString:@"北京市"] || [self.searchModel.end_province isEqualToString:@"上海市"] || [self.searchModel.end_province isEqualToString:@"天津市"] || [self.searchModel.end_province isEqualToString:@"重庆市"]) {
        vc.city = self.searchModel.end_province;
        [self presentViewController:vc animated:YES completion:nil];
    }else if([self.searchModel.end_city isEqualToString:@"不限"]){
        [CYTSI otherShowTostWithString:@"请选择下车城市"];
    }else if([self.searchModel.end_city isEqualToString:@"-"]){
        [CYTSI otherShowTostWithString:@"请选择下车城市"];
    }else{
        vc.city = self.searchModel.end_city;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)GFAddressPickerCancleAction
{
    [self.pickerView removeFromSuperview];
}
#pragma mark --------- 地点选择确认事件
- (void)GFAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city area:(NSString *)area
{
    [self.pickerView removeFromSuperview];
    
    if ([self.pickerView.state isEqualToString:@"start"]) {
        if ([area isEqualToString:@"不限"]) {
            NSString *startStr = [NSString stringWithFormat:@"%@%@",province,city];
            if (startStr.length > 6){
                self.ITstartLB.text = [NSString stringWithFormat:@"%@..",[startStr substringToIndex:6]];
            }else{
                self.ITstartLB.text = startStr;
            }
            if ([city isEqualToString:@"不限"]) {
                NSString *startStr = [NSString stringWithFormat:@"%@",province];
                if (startStr.length > 6){
                    self.ITstartLB.text = [NSString stringWithFormat:@"%@..",[startStr substringToIndex:6]];
                }else{
                    self.ITstartLB.text = startStr;
                }
                if ([province isEqualToString:@"不限"]) {
                    self.ITstartLB.text = @"不限";
                }
            }
        }else{
            NSString *startStr = [NSString stringWithFormat:@"%@%@",city,area];
            if (startStr.length > 6){
                self.ITstartLB.text = [NSString stringWithFormat:@"%@..",[startStr substringToIndex:6]];
            }else{
                self.ITstartLB.text = startStr;
            }
        }
        [self.searchModel setValue:province forKey:@"start_province"];
        [self.searchModel setValue:city forKey:@"start_city"];
        [self.searchModel setValue:area forKey:@"start_county"];
        [self creatHttp];
    }else{
        if ([area isEqualToString:@"不限"]) {
            NSString *endStr = [NSString stringWithFormat:@"%@%@",province,city];
            if (endStr.length > 6){
                self.ITendLB.text = [NSString stringWithFormat:@"%@..",[endStr substringToIndex:6]];
            }else{
                self.ITendLB.text = endStr;
            }
            if ([city isEqualToString:@"不限"]) {
                NSString *endStr = [NSString stringWithFormat:@"%@",province];
                if (endStr.length > 6){
                    self.ITendLB.text = [NSString stringWithFormat:@"%@..",[endStr substringToIndex:6]];
                }else{
                    self.ITendLB.text = endStr;
                }
                if ([province isEqualToString:@"不限"]) {
                    self.ITendLB.text = @"不限";
                }
            }
        }else{
            NSString *endStr = [NSString stringWithFormat:@"%@%@",city,area];
            if (endStr.length > 6){
                self.ITendLB.text = [NSString stringWithFormat:@"%@..",[endStr substringToIndex:6]];
            }else{
                self.ITendLB.text = endStr;
            }
        }
        [self.searchModel setValue:province forKey:@"end_province"];
        [self.searchModel setValue:city forKey:@"end_city"];
        [self.searchModel setValue:area forKey:@"end_county"];
        [self creatHttp];
    }
    
//    NSLog(@"%@  %@  %@",province,city,area);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
