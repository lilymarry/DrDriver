//
//  SLContractDetialController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/16.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLContractDetialController.h"
#import "SLContractDetialCell.h"
#import "SLChildViewController.h"
#import "SLStudent.h"
#import "SLContract.h"
@interface SLContractDetialController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic,readwrite) UITableView *tableView;
@property (strong, nonatomic,readwrite) SLContract *contract;
@property (strong, nonatomic,readwrite) UIView *headerView;
@property (strong, nonatomic,readwrite) UILabel *timeLabel;
@property (strong, nonatomic,readwrite) UILabel *statuLabel;
@property (strong, nonatomic,readwrite) UILabel *typeLabel;
@end

@implementation SLContractDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpHeaderView];
    [self setUpTableView];
    [self setUpNav];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self creatHttp];
}

//请求数据
-(void)creatHttp
{
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStr= @"";
    NSDictionary *dict = @{};
       if ([self.whichType isEqualToString:@"0"]) {
           urlStr = DRIVER_SCHOOLBUS_CONTRACT_DETAIL;

       }else{
           urlStr = DRIVER_WORK_CONTRACT_DETAIL;
       }
    dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"contract_id":self.contract_id};
    [AFRequestManager postRequestWithUrl:urlStr params:dict tost:YES special:0 success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"DRIVER_SCHOOLBUS_CONTRACT_DETAIL --- %@",responseObject[@"data"]);
                   weakSelf.contract = [SLContract mj_objectWithKeyValues:responseObject[@"data"]];
                   weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@——%@",weakSelf.contract.startdate,weakSelf.contract.enddate];
                   if ([weakSelf.contract.state isEqualToString:@"2"]) {
                        weakSelf.statuLabel.textColor = CATECOLOR_SELECTED;
                    }else{
                        weakSelf.statuLabel.textColor = [UIColor grayColor];
                    }
                   weakSelf.statuLabel.text = weakSelf.contract.state_name;
                   weakSelf.typeLabel.text = weakSelf.contract.type_name;
                   [weakSelf.tableView reloadData];

        });
       
        
    } failure:^(NSError *error) {
        
//       CYLog(@"error ===== %@",error)
    }];
    
}
- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self.view addSubview:self.tableView];

    [self.tableView setTableHeaderView:self.headerView];
}

- (void)setUpHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 165)];
    self.headerView.backgroundColor = TABLEVIEW_BACKCOLOR;
//    日期的view
    UIView *timeView = [[UIView alloc] init];
    timeView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left);
        make.right.mas_equalTo(self.headerView.mas_right);
        make.top.mas_equalTo(self.headerView.mas_top);
        make.height.mas_equalTo(95);
    }];
    UIView *timeLineView = [[UIView alloc] init];
    timeLineView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [timeView addSubview:timeLineView];
    [timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeView.mas_left).mas_offset(15);
        make.right.mas_equalTo(timeView.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    UIImageView *canlnderImg = [[UIImageView alloc] init];
    canlnderImg.image = [UIImage imageNamed:@"riqi"];
    [timeView addSubview:canlnderImg];
    [canlnderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(25);
        make.left.mas_equalTo(timeView.mas_left).mas_offset(15);
        make.top.mas_equalTo(timeView.mas_top).mas_offset(10);
    }];
    UILabel *timeNameLable = [[UILabel alloc] init];
    timeNameLable.text = @"起止日期";
    timeNameLable.font = [UIFont systemFontOfSize:15];
    timeNameLable.textColor = [UIColor darkGrayColor];
    [timeView addSubview:timeNameLable];
    [timeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(canlnderImg.mas_centerY);
        make.left.mas_equalTo(canlnderImg.mas_right).mas_offset(10);
    }];
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.text = @"---------";
    timeLable.font = [UIFont systemFontOfSize:15];
    timeLable.textColor = [UIColor darkGrayColor];
    [timeView addSubview:timeLable];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(canlnderImg.mas_left);
        make.top.mas_equalTo(timeLineView.mas_bottom).mas_offset(10);
    }];
    self.timeLabel = timeLable;
    UILabel *statuLabel = [[UILabel alloc] init];
    statuLabel.text = @"--";
    statuLabel.font = [UIFont systemFontOfSize:15];
    statuLabel.textColor = CATECOLOR_SELECTED;
    [timeView addSubview:statuLabel];
    [statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(timeLineView.mas_right);
        make.top.mas_equalTo(timeLineView.mas_bottom).mas_offset(10);
    }];
    self.statuLabel = statuLabel;
    //车View
    UIView *carView = [[UIView alloc] init];
    carView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:carView];
    [carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeView.mas_bottom).offset(10);
        make.left.mas_equalTo(timeView.mas_left);
        make.right.mas_equalTo(timeView.mas_right);
        make.height.mas_equalTo(44);
    }];

    UIImageView *carImg = [[UIImageView alloc] init];
    carImg.image = [UIImage imageNamed:@"car"];
    [carView addSubview:carImg];
    [carImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(25);
        make.left.mas_equalTo(carView.mas_left).mas_offset(15);
        make.top.mas_equalTo(carView.mas_top).mas_offset(10);
    }];
    UILabel *carLable = [[UILabel alloc] init];
    carLable.text = @"---";
    carLable.font = [UIFont systemFontOfSize:15];
    carLable.textColor = [UIColor darkGrayColor];
    [carView addSubview:carLable];
    [carLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(carImg.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(carImg.mas_centerY);
    }];
    self.typeLabel = carLable;
}

//设置导航栏
- (void)setUpNav
{
    UIButton *navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame = CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//导航栏返回按钮
- (void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contract.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLContractDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLContractDetialCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SLContractDetialCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.student = self.contract.details[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 35)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    UIImageView *canlnderImg = [[UIImageView alloc] init];
    canlnderImg.image = [UIImage imageNamed:@"child"];
    [sectionHeader addSubview:canlnderImg];
    [canlnderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(sectionHeader.mas_left).mas_offset(15);
        make.centerY.mas_equalTo(sectionHeader.mas_centerY);
    }];
    UILabel *timeNameLable = [[UILabel alloc] init];
    if ([self.whichType isEqualToString:@"0"]) {
        timeNameLable.text = @"学生信息";
    }else{
        timeNameLable.text = @"乘车人信息";
    }
    timeNameLable.font = [UIFont systemFontOfSize:15];
    timeNameLable.textColor = [UIColor darkGrayColor];
    [sectionHeader addSubview:timeNameLable];
    [timeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(canlnderImg.mas_centerY);
        make.left.mas_equalTo(canlnderImg.mas_right).mas_offset(10);
    }];
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLChildViewController *childVC = [[SLChildViewController alloc] init];
    childVC.timeStr = self.timeLabel.text;
    childVC.statuStr = self.statuLabel.text;
    childVC.typeStr = self.typeLabel.text;
    childVC.contract_id =  self.contract.contract_id;
    childVC.statu = self.contract.state;
    childVC.student = self.contract.details[indexPath.row];
    childVC.whichType = self.whichType;
    [self.navigationController pushViewController:childVC animated:YES];
}

@end
