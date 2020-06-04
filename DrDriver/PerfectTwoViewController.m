//
//  PerfectTwoViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PerfectTwoViewController.h"
#import "RegisterProgressView.h"
#import "PerfectTwoTableViewCell.h"
#import "PerfectThreeViewController.h"
#import "ChooseCarTypeViewController.h"

@interface PerfectTwoViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView * myTableView;
    NSArray * titleArray;//标题数组
    
    UITextField * carNumTextFiled;//车牌号输入框
    UITextField * carTypeTextFiled;//车辆品牌输入框
    UITextField * carColorTextFiled;//车辆颜色输入框
    
    NSMutableDictionary * chooseDic;//选择的字典
}

@end

@implementation PerfectTwoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"完善信息";
    titleArray=@[@"车牌号",@"车辆品牌",@"车辆颜色"];
    chooseDic=[[NSMutableDictionary alloc]init];
    
    [self setUpNav];//创建导航栏
    [self creatMainView];//创建主要视图
    
}

//创建导航栏
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

//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
    
    RegisterProgressView * progressView=[[RegisterProgressView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 68)];
    progressView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [myTableView setTableHeaderView:progressView];
    
    [progressView setProgress:2];
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
    footerView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIButton * nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(12, 27, DeviceWidth-24, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:16];
    nextButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    nextButton.layer.cornerRadius=5;
    nextButton.layer.masksToBounds=YES;
    [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    [myTableView setTableFooterView:footerView];
    
}

//下一步按钮点击事件
-(void)nextButtonClicked
{
    [carNumTextFiled resignFirstResponder];
    [carTypeTextFiled resignFirstResponder];
    [carColorTextFiled resignFirstResponder];
    
    if (chooseDic[@"car_number"]==nil) {
        [CYTSI otherShowTostWithString:@"请输入车牌号"];
        return;
    }
    if (_carBrandName==nil || _vehicleStyle==nil) {
        [CYTSI otherShowTostWithString:@"请选择车辆品牌"];
        return;
    }
    if (_carColor==nil) {
        [CYTSI otherShowTostWithString:@"请选择车辆颜色"];
        return;
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_REGISTER_VEHICLE_INFO params:@{@"vehicle_number":chooseDic[@"car_number"],@"vehicle_brand":_carBrandName,@"vehicle_style":_vehicleStyle,@"vehicle_color":_carColor.color_name,@"driver_id":_driver.driver_id,@"token":_driver.token} tost:YES special:0 success:^(id responseObject) {
        
        PerfectThreeViewController * vc=[[PerfectThreeViewController alloc]init];
        vc.driver=_driver;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITextFiled 的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [carNumTextFiled resignFirstResponder];
    [carTypeTextFiled resignFirstResponder];
    [carColorTextFiled resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    myTableView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-216);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    myTableView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    
    if (textField==carNumTextFiled) {
        
        if (![carNumTextFiled.text isEqualToString:@""]) {
            
            [chooseDic setObject:carNumTextFiled.text forKey:@"car_number"];
            [myTableView reloadData];
            
        }
        
    }
//    if (textField==carTypeTextFiled) {
//        
//        if (![carTypeTextFiled.text isEqualToString:@""]) {
//            
//            [chooseDic setObject:carTypeTextFiled.text forKey:@"car_type"];
//            [myTableView reloadData];
//            
//        }
//        
//    }
//    if (textField==carColorTextFiled) {
//        
//        if (![carColorTextFiled.text isEqualToString:@""]) {
//            
//            [chooseDic setObject:carColorTextFiled.text forKey:@"car_color"];
//            [myTableView reloadData];
//            
//        }
//        
//    }
    
}

//点击区头结束键盘第一响应
-(void)cancleButtolClicked
{
    [carNumTextFiled resignFirstResponder];
    [carTypeTextFiled resignFirstResponder];
    [carColorTextFiled resignFirstResponder];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 38)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, DeviceWidth-24, 18)];
    lable.font=[UIFont systemFontOfSize:13];
    lable.text=titleArray[section];
    lable.textColor=[CYTSI colorWithHexString:@"#666666"];
    [bgView addSubview:lable];
    
    UIButton * cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame=CGRectMake(0, 0, DeviceWidth, 38);
    [cancleButton addTarget:self action:@selector(cancleButtolClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleButton];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PerfectTwoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"perfecttwocell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PerfectTwoTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0://车牌号
        {
            cell.rightArrowImageView.hidden=YES;
            cell.closeButton.hidden=YES;
            cell.theTextFiled.placeholder=@"请输入车牌号 例如：津A12345";
            carNumTextFiled=cell.theTextFiled;
            carNumTextFiled.returnKeyType=UIReturnKeyDone;
            carNumTextFiled.delegate=self;
            
            if (chooseDic[@"car_number"]!=nil) {
                cell.theTextFiled.text=chooseDic[@"car_number"];
            }
            
        }
            break;
        case 1://车辆品牌
        {
            cell.rightArrowImageView.hidden=YES;
            cell.closeButton.hidden=YES;
            cell.theTextFiled.placeholder=@"请选择车辆品牌";
            [cell setCellType];
//            carTypeTextFiled=cell.theTextFiled;
//            carTypeTextFiled.returnKeyType=UIReturnKeyDone;
//            carTypeTextFiled.delegate=self;
            
            cell.clickedButton.tag=100;
            [cell.clickedButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
//            if (chooseDic[@"car_type"]!=nil) {
//                cell.theTextFiled.text=chooseDic[@"car_type"];
//            }
            
            if (_carBrandName!=nil) {
                cell.theTextFiled.text=[NSString stringWithFormat:@"%@-%@",_carBrandName,_vehicleStyle];
            }
            
        }
            break;
        case 2://车辆颜色
        {
            cell.rightArrowImageView.hidden=YES;
            cell.closeButton.hidden=YES;
            cell.theTextFiled.placeholder=@"请选择车辆颜色";
            [cell setCellType];
//            carColorTextFiled=cell.theTextFiled;
//            carColorTextFiled.returnKeyType=UIReturnKeyDone;
//            carColorTextFiled.delegate=self;
            
            cell.clickedButton.tag=200;
            [cell.clickedButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
//            if (chooseDic[@"car_color"]!=nil) {
//                cell.theTextFiled.text=chooseDic[@"car_color"];
//            }
            
            if (_carColor!=nil) {
                cell.theTextFiled.text=[NSString stringWithFormat:@"%@",_carColor.color_name];
            }
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

//选择按钮点击事件
-(void)chooseButtonClicked:(UIButton *)btn
{
    ChooseCarTypeViewController * vc=[[ChooseCarTypeViewController alloc]init];
    if (btn.tag==100) {
        vc.type=1;
    }else{
        vc.type=2;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
