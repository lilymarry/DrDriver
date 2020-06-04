//
//  ChangeCarTypeViewController.m
//  DrDriver
//
//  Created by fy on 2019/4/8.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ChangeCarTypeViewController.h"
#import "CityAndTypeTableViewCell.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "LoginViewController.h"

@interface ChangeCarTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,copy)NSString *class_name;
@property(nonatomic,copy)NSString *driver_class;

@end

@implementation ChangeCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"切换";
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.driver_class = @"-";
    self.class_name = @"-";
    [self setUpNav];//设置导航栏
    [self creatMainView];
    [self creatHttp];
}
-(void)setUpNav{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}
-(void)creatHttp{
    [AFRequestManager postRequestWithUrl:DRIVER_SHOW_DRIVER_CLASS params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]} tost:YES special:0 success:^(id responseObject) {
        if ([responseObject[@"message"] isEqualToString:@"请求成功"]) {
            self.dataArr = [NSArray arrayWithArray:responseObject[@"data"]];
            [self.tableView reloadData];
            if (self.dataArr.count == 0) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                               message:@"没有可更改的车辆类型"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [self  navBackButtonClicked];
                                                                      }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)creatMainView{
    UILabel *titleLB = [[UILabel alloc] init];
    [self.view addSubview:titleLB];
    titleLB.text = @"运营类型";
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(k_Height_NavBar + 15);
    }];
    
    UILabel *starLB = [[UILabel alloc] init];
    [self.view addSubview:starLB];
    starLB.text = @"*";
    starLB.textColor = [UIColor redColor];
    [starLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLB.mas_right);
        make.centerY.equalTo(titleLB);
    }];
    
    UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:affirmBtn];
    affirmBtn.layer.cornerRadius = 5;
    affirmBtn.layer.masksToBounds = YES;
    [affirmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [affirmBtn setBackgroundColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [affirmBtn addTarget:self action:@selector(affirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(44);
        make.bottom.equalTo(self.view).offset(-20 - Bottom_Height);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52 + k_Height_NavBar, DeviceWidth, self.view.frame.size.height - 52 - Bottom_Height - k_Height_NavBar) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CityAndTypeTableViewCell class] forCellReuseIdentifier:@"CityAndTypeTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLB.mas_bottom).offset(10);
        make.bottom.equalTo(affirmBtn.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
        make.width.mas_offset(DeviceWidth - 20);
    }];
}
-(void)affirmAction{
    if ([self.driver_class isEqualToString:@"-"]) {
        [CYTSI otherShowTostWithString:@"请选择要更改的车辆类型"];
    }else{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"请确保当前没有未完成的订单或不影响短时间内的预约单。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [AFRequestManager postRequestWithUrl:DRIVER_SWITCH_DRIVER_CLASS params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"driver_class":self.driver_class} tost:YES special:0 success:^(id responseObject) {
                                                                  if ([responseObject[@"message"] isEqualToString:@"请求成功"]) {
                                                                      [self excitAction];
                                                                  }
                                                              } failure:^(NSError *error) {
                                                                  
                                                              }];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                           
                                                         }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)excitAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Dname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_class"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stop_listen" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdate" object:self userInfo:nil];
    
    AppDelegate * appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=appDelegate.shouyeNav;
    [appDelegate.leftSlider closeLeftView];//关闭左侧视图
    
    
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        CYLog(@"取消推送注册:%@",iAlias);
        
    }];
    
    BOOL isHave=NO;
    NSArray * vcArray=self.navigationController.viewControllers;
    for (LoginViewController * vc in vcArray) {
        
        if ([vc isKindOfClass:[LoginViewController class]]) {
            
            isHave=YES;
            [nav popToViewController:vc animated:YES];
            
        }
        
    }
    
    if (isHave==NO) {
        
        LoginViewController * vc=[[LoginViewController alloc]init];
        vc.isMainJump=YES;
        [nav pushViewController:vc animated:YES];
        
    }
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",self.dataArr);
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityAndTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityAndTypeTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.typeTitleLB.text = dic[@"class_name"];
    if (![self.class_name isEqualToString:@"-"]) {
        if ([self.class_name isEqualToString:dic[@"class_name"]]) {
            cell.typeTitleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
            cell.typeImageView.image = [UIImage imageNamed:@"选择q"];
        }else{
            cell.typeTitleLB.textColor = [UIColor lightGrayColor];
            cell.typeImageView.image = [UIImage imageNamed:@"未选择q"];
        }
    }else{
        cell.typeTitleLB.textColor = [UIColor lightGrayColor];
        cell.typeImageView.image = [UIImage imageNamed:@"未选择q"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    self.class_name = dic[@"class_name"];
    self.driver_class = [NSString stringWithFormat:@"%@",dic[@"driver_class"]];
    [self.tableView reloadData];
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


