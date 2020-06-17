//
//  ITUserOrderViewController.m
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITUserOrderViewController.h"
#import "ITUserOrderTableViewCell.h"
#import "GFAddressPicker.h"

@interface ITUserOrderViewController ()<UITableViewDelegate,UITableViewDataSource,GFAddressPickerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *dateArr;
    NSMutableArray *hourArr;
    NSMutableArray *minuteArr;
    NSMutableArray *todayHourArr;
    NSMutableArray *todayMinuteArr;
    NSString *dateStr;
    NSString *hourStr;
    NSString *minuteStr;
    NSString *currentPage;//当前分页数
    
}
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIView *timePickBgView;

@property(nonatomic,strong)UIPickerView *numberPickView;
@property(nonatomic,strong)UIView *numberBackView;
@property(nonatomic,strong)UIView *numberLineView2;
@property(nonatomic,strong)UIView *numberPickBgView;
@property(nonatomic,strong)NSMutableArray *numberArr;
@property(nonatomic,copy)NSString  *numberStr;

@property (nonatomic, strong) GFAddressPicker *pickerView;

@end

@implementation ITUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.searchModel  = [[SearchTravelListModel alloc] init];
    self.dataArr = [NSMutableArray array];
    self.numberArr = [NSMutableArray array];
    currentPage = @"1";
    [self.searchModel setValue:@"-" forKey:@"start_province"];
    [self.searchModel setValue:@"-" forKey:@"start_city"];
    [self.searchModel setValue:@"-" forKey:@"start_county"];
    [self.searchModel setValue:@"-" forKey:@"end_province"];
    [self.searchModel setValue:@"-" forKey:@"end_city"];
    [self.searchModel setValue:@"-" forKey:@"end_county"];
    [self.searchModel setValue:@"-" forKey:@"start_date"];
    [self.searchModel setValue:@"-" forKey:@"start_time"];
    [self.searchModel setValue:@"-" forKey:@"end_time"];
    [self.searchModel setValue:@"-" forKey:@"passenger_num"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSearch) name:@"changeSearch" object:nil];
    [self creatTopView];
    [self creatTableView];
}
-(void)changeSearch{
    currentPage = @"1";
}
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
//        NSLog(@"没有登录");
    }else{
        NSString *start_province = @"";NSString *start_city = @"";NSString *start_county = @"";NSString *end_province = @"";NSString *end_city = @"";NSString *end_county = @"";NSString *start_date = @"";NSString *start_time = @"";NSString *end_time = @"";NSString *passenger_num = @"";
        
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
        if (![self.searchModel.start_date isEqualToString:@"-"] && self.searchModel.start_date != nil) {
            start_date = self.searchModel.start_date;
        }
        if (![self.searchModel.start_time isEqualToString:@"-"] && self.searchModel.start_time != nil) {
            start_time = self.searchModel.start_time;
        }
        if (![self.searchModel.end_time isEqualToString:@"-"] && self.searchModel.end_time != nil) {
            end_time = self.searchModel.end_time;
        }
        if (![self.searchModel.passenger_num isEqualToString:@"-"] && self.searchModel.passenger_num != nil) {
            passenger_num = self.searchModel.passenger_num;
        }
        NSDictionary *dic = @{@"p":currentPage,@"start_province":start_province,@"start_city":start_city,@"start_county":start_county,@"end_province":end_province,@"end_city":end_city,@"end_county":end_county,@"start_date":start_date,@"start_time":start_time,@"end_time":end_time,@"passenger_num":passenger_num,@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
//        NSLog(@"NSDictionary *dic =%@",dic);
        [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_USER_TRAVEL_LIST params:dic tost:YES special:0 success:^(id responseObject) {
//            NSLog(@"responseObjectresponseObject%@",responseObject);
            
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
}
-(void)creatTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, DeviceWidth, 90)];
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
    self.ITstartLB.text = @"出发点";
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
    self.ITendLB.text = @"到达点";
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
    
    self.ITTimeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.ITTimeBtn setTitle:@"出发时间" forState:(UIControlStateNormal)];
    [self.ITTimeBtn setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.ITTimeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.ITTimeBtn setImage:[UIImage imageNamed:@"下拉箭头"] forState:(UIControlStateNormal)];
    [self.ITTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (-self.ITTimeBtn.currentImage.size.width - 15)/414 * DeviceWidth, 0, 0)];
    [self.ITTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (self.ITTimeBtn.titleLabel.intrinsicContentSize.width + 35)/414 * DeviceWidth, 0, 0)];
    [self.ITTimeBtn addTarget:self action:@selector(TimeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.ITTimeBtn];
    [self.ITTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLB.mas_top).                                                                       offset(10);
        make.centerX.mas_offset(-DeviceWidth/4);
        make.width.mas_offset((DeviceWidth - 120)/2);
        make.height.mas_offset(25);
    }];
    
    self.ITNumberBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.ITNumberBtn setTitle:@"乘车人数" forState:(UIControlStateNormal)];
    [self.ITNumberBtn setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.ITNumberBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.ITNumberBtn setImage:[UIImage imageNamed:@"下拉箭头"] forState:(UIControlStateNormal)];
    [self.ITNumberBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, (-self.ITTimeBtn.currentImage.size.width - 15)/414 * DeviceWidth, 0, 0)];
    [self.ITNumberBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (self.ITTimeBtn.titleLabel.intrinsicContentSize.width + 35)/414 * DeviceWidth, 0, 0)];
    [self.ITNumberBtn addTarget:self action:@selector(numberAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.ITNumberBtn];
    [self.ITNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLB.mas_top).offset(10);
        make.centerX.mas_offset(DeviceWidth/4);
        make.width.mas_offset((DeviceWidth - 120)/2);
        make.height.mas_offset(25);
    }];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 97, DeviceWidth, self.view.frame.size.height - k_Height_NavBar - Bottom_Height - 306) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ITUserOrderTableViewCell class] forCellReuseIdentifier:@"InTravelTableViewCell"];
    //    self.tableView.tableHeaderView = self.topView;
    
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
    return 175;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ITUserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InTravelTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setData:self.dataArr[indexPath.row]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dic = self.dataArr[indexPath.row];
//    if ([self.searchModel.passenger_num isEqualToString:@"-"]) {
//        self.selectBlock(dic[@"travel_id"],@"1");
//    }else{
//        self.selectBlock(dic[@"travel_id"],self.searchModel.passenger_num);
//    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    self.userPushDetail(dic[@"order_id"], self.isCanListen);
}
#pragma mark ------- 更改人数
-(void)numberAction{
    if ([self.seat_num intValue] >= 6) {
        [self.numberArr removeAllObjects];
        for (int i = 1; i < [self.seat_num intValue]; i++) {
            [self.numberArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.numberArr addObject:@"商务七人座包车"];
    }else{
        [self.numberArr removeAllObjects];
        for (int i = 1; i < [self.seat_num intValue]; i++) {
            [self.numberArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.numberArr addObject:@"轿车包车"];
    }
    [self creatNumberPickView];
    self.numberStr = @"1";
}
-(void)startAddressAction{
    [self.view endEditing:YES];
    [self cancelbtn2Action];
    self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 157)];
    self.pickerView.delegate = self;
    self.pickerView.state = @"start";
    self.pickerView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.pickerView];
}
-(void)endAddressAction{
    [self.view endEditing:YES];
    [self cancelbtn2Action];
    self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 157)];
    self.pickerView.delegate = self;
    self.pickerView.state = @"end";
    self.pickerView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.pickerView];
}
-(void)TimeAction{
    //创建时间pickerView
    [self.view endEditing:YES];
    dateArr = [NSMutableArray arrayWithArray:@[@"今天",@"明天",@"后天"]];
    hourArr = [NSMutableArray arrayWithArray:@[@"上午",@"下午",@"不限"]];
    minuteArr = [NSMutableArray arrayWithArray:@[@"00",@"10",@"20",@"30",@"40",@"50"]];
    [self compareDate];
    dateStr = @"今天";
    hourStr = @"上午";
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
#pragma mark -----  pickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.numberPickView) {
        return 1;
    }else{
        return 2;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        return self.numberArr.count;
    }else{
        if (component == 0) {
            return dateArr.count;
        }else{
            return hourArr.count;
        }
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        return self.numberArr[row];
    }else{
        if (component == 0) {
            return dateArr[row];
        }else{
            return hourArr[row];
        }
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        if (component == 0) {
            self.numberStr = self.numberArr[row];
        }
    }else{
        if (component == 0) {
            dateStr = dateArr[row];
        }else if (component == 1){
            hourStr = hourArr[row];
        }
    }
}
#pragma mark-------- pickerView确认
- (void)centerbtn2Action{
    [UIView animateWithDuration:0.6 animations:^{
        [self.pickView removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.timePickBgView removeFromSuperview];
    }];
    if ([hourStr isEqualToString:@"不限"]) {
        [self.ITTimeBtn setTitle:[NSString stringWithFormat:@"%@",dateStr] forState:(UIControlStateNormal)];
    }else{
        [self.ITTimeBtn setTitle:[NSString stringWithFormat:@"%@ %@",dateStr,hourStr] forState:(UIControlStateNormal)];
    }
    if ([dateStr isEqualToString:@"今天"]) {
        [self.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getCurrentTime]] forKey:@"start_date"];
    }else if ([dateStr isEqualToString:@"明天"]){
        NSDate *today = [CYTSI dateFromString:[CYTSI getCurrentTime]];
        [self.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getTomorrowDay:today]] forKey:@"start_date"];
    }else if ([dateStr isEqualToString:@"后天"]){
        NSDate *today = [CYTSI dateFromString:[CYTSI getCurrentTime]];
        NSString *tomottow = [CYTSI getTomorrowDay:today];
        NSDate *tom = [CYTSI dateFromString:tomottow];
        [self.searchModel setValue:[NSString stringWithFormat:@"%@",[CYTSI getTomorrowDay:tom]] forKey:@"start_date"];
    }
    if ([hourStr isEqualToString:@"上午"]) {
        [self.searchModel setValue:@"6:00" forKey:@"start_time"];
        [self.searchModel setValue:@"12:00" forKey:@"end_time"];
    }else if ([hourStr isEqualToString:@"下午"]){
        [self.searchModel setValue:@"12:00" forKey:@"start_time"];
        [self.searchModel setValue:@"18:00" forKey:@"end_time"];
    }else{
        [self.searchModel setValue:@"00:00" forKey:@"start_time"];
        [self.searchModel setValue:@"23:59" forKey:@"end_time"];
    }
    [self creatHttp];
}
//pickerView取消
- (void)cancelbtn2Action{
    [UIView animateWithDuration:0.6 animations:^{
        [self.pickView removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.timePickBgView removeFromSuperview];
    }];
}
-(void)dismiss{
    [self.view endEditing:YES];
}
//截取时间
-(void)compareDate{
    [self creatPickView];
}
-(void)creatPickView{
    self.timePickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.timePickBgView];
    self.timePickBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210-Bottom_Height, self.view.frame.size.width, 210 +Bottom_Height)];
    [self.timePickBgView addSubview:self.backView];
    self.backView.userInteractionEnabled = YES;
    self.backView.backgroundColor= [UIColor lightGrayColor];
    
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.pickView];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.showsSelectionIndicator = YES;
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-Bottom_Height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(180);
    }];
    
    //黑条
    self.lineView2 = [[UIView alloc]init];
    [self.backView addSubview:self.lineView2];
    self.lineView2.backgroundColor = [UIColor whiteColor];
    self.lineView2.userInteractionEnabled= YES;
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.left.equalTo(self.backView.mas_left);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(40);
    }];
    
    //确定按钮
    UIButton *centerbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    centerbtn2.backgroundColor = [UIColor whiteColor];
    [self.lineView2 addSubview:centerbtn2];
    [centerbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.right.equalTo(self.backView.mas_right);
    }];
    [centerbtn2 setTitle:@"确定" forState:0];
    [centerbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [centerbtn2 addTarget:self action:@selector(centerbtn2Action) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    UIButton *cancelbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn2.backgroundColor = [UIColor whiteColor];
    [self.lineView2 addSubview:cancelbtn2];
    [cancelbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.left.equalTo(self.backView.mas_left);
    }];
    [cancelbtn2 setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [cancelbtn2 addTarget:self action:@selector(cancelbtn2Action) forControlEvents:UIControlEventTouchUpInside];
    //中间label
    UILabel *chooseL2 = [[UILabel alloc]init];
    chooseL2.text = @"选择上车时间";
    chooseL2.textAlignment = NSTextAlignmentCenter;
    chooseL2.backgroundColor = [UIColor whiteColor];
    chooseL2.textColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    [self.lineView2 addSubview:chooseL2];
    [chooseL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.left.equalTo(cancelbtn2.mas_right);
        make.right.equalTo(centerbtn2.mas_left);
        make.height.mas_offset(40);
    }];
}
-(void)creatNumberPickView{
    self.numberPickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.numberPickBgView];
    self.numberPickBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.numberBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210-Bottom_Height, self.view.frame.size.width, 210+Bottom_Height)];
    [self.numberPickBgView addSubview:self.numberBackView];
    self.numberBackView.userInteractionEnabled = YES;
    self.numberBackView.backgroundColor= [UIColor lightGrayColor];
    
    self.numberPickView = [[UIPickerView alloc] init];
    self.numberPickView.backgroundColor = [UIColor whiteColor];
    [self.numberBackView addSubview:self.numberPickView];
    self.numberPickView.delegate = self;
    self.numberPickView.dataSource = self;
    self.numberPickView.showsSelectionIndicator = YES;
    [self.numberPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-Bottom_Height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(180);
    }];
    
    //黑条
    self.numberLineView2 = [[UIView alloc]init];
    [self.numberBackView addSubview:self.numberLineView2];
    self.numberLineView2.backgroundColor = [UIColor whiteColor];
    self.numberLineView2.userInteractionEnabled= YES;
    [self.numberLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.left.equalTo(self.numberBackView.mas_left);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(40);
    }];
    
    //确定按钮
    UIButton *centerbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    centerbtn2.backgroundColor = [UIColor whiteColor];
    [self.numberLineView2 addSubview:centerbtn2];
    [centerbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.right.equalTo(self.numberBackView.mas_right);
    }];
    [centerbtn2 setTitle:@"确定" forState:0];
    [centerbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [centerbtn2 addTarget:self action:@selector(numCAction) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    UIButton *cancelbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn2.backgroundColor = [UIColor whiteColor];
    [self.numberLineView2 addSubview:cancelbtn2];
    [cancelbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.left.equalTo(self.numberBackView.mas_left);
    }];
    [cancelbtn2 setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [cancelbtn2 addTarget:self action:@selector(numberCancelAction) forControlEvents:UIControlEventTouchUpInside];
    //中间label
    UILabel *chooseL2 = [[UILabel alloc]init];
    chooseL2.text = @"选择上车人数";
    chooseL2.textAlignment = NSTextAlignmentCenter;
    chooseL2.backgroundColor = [UIColor whiteColor];
    chooseL2.textColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    [self.numberLineView2 addSubview:chooseL2];
    [chooseL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.left.equalTo(cancelbtn2.mas_right);
        make.right.equalTo(centerbtn2.mas_left);
        make.height.mas_offset(40);
    }];
}
-(void)numCAction{
    if ([self.numberStr isEqualToString:@"3人以上"]) {
        [self.searchModel setValue:@"4" forKey:@"passenger_num"];
    }else if ([self.numberStr isEqualToString:@"轿车包车"]){
        [self.searchModel setValue:@"-1" forKey:@"passenger_num"];
    }else if ([self.numberStr isEqualToString:@"商务七人座包车"]){
        [self.searchModel setValue:@"-2" forKey:@"passenger_num"];
    }else{
        [self.searchModel setValue:self.numberStr forKey:@"passenger_num"];
    }
    if ([self.numberStr isEqualToString:@"商务七人座包车"]) {
        [self.ITNumberBtn setTitle:@"商务七人.." forState:(UIControlStateNormal)];
    }else{
        [self.ITNumberBtn setTitle:self.numberStr forState:(UIControlStateNormal)];
    }
    [self numberCancelAction];
    [self refreshDown];
}
-(void)numberCancelAction{
    [UIView animateWithDuration:0.6 animations:^{
        [self.numberPickView removeFromSuperview];
        [self.numberBackView removeFromSuperview];
        [self.numberPickBgView removeFromSuperview];
    }];
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
