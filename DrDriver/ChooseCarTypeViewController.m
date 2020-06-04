//
//  ChooseCarTypeViewController.m
//  DrDriver
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChooseCarTypeViewController.h"
#import "CarModel.h"
#import "Add_TWO_ViewController.h"
#import "Register_TWO_ViewController.h"
@interface ChooseCarTypeViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    UITableView * detailTableView;
    
    NSArray * carTypeArray;//汽车品牌数组
    NSArray * colorArray;//汽车颜色数组
    
    NSInteger currentSelectedType;//当前选择的品牌分类
}

@end

@implementation ChooseCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.type==1) {
        self.title=@"选择车辆品牌";
    } else {
        self.title=@"选择车辆颜色";
    }
    [self setUpNav];//创建导航栏
    [self creatMainView];//创建主要视图
    [self creatHttp];//请求数据
    
}

//请求数据
-(void)creatHttp
{
    if (self.type==1) {
        
        [AFRequestManager postRequestWithUrl:DRIVER_VEHICLE_BRAND_LIST params:@{} tost:YES special:0 success:^(id responseObject) {
            
            [CarModel mj_setupObjectClassInArray:^NSDictionary *{
                
                return @{@"vehicle_style":@"CarModel"};
                
            }];
            carTypeArray=[CarModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [myTableView reloadData];
            [detailTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        [AFRequestManager postRequestWithUrl:DRIVER_VEHICLE_COLOR_LIST params:@{} tost:YES special:0 success:^(id responseObject) {
            
            colorArray=[CarModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [myTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
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
    
    if (_type==1) {
        
        myTableView.frame=CGRectMake(0, 0, DeviceWidth/2, DeviceHeight);
        
        detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(DeviceWidth/2, 64, DeviceWidth/2, DeviceHeight-64) style:UITableViewStylePlain];
        detailTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
        detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        detailTableView.delegate = self;
        detailTableView.dataSource = self;
        detailTableView.showsVerticalScrollIndicator=NO;
        [self.view addSubview:detailTableView];
        
    }
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==myTableView) {
        
        if (_type==1) {
            return carTypeArray.count;
        } else {
            return colorArray.count;
        }
        
    } else {
        
        if (carTypeArray.count!=0) {
            CarModel * car=carTypeArray[currentSelectedType];
            return car.vehicle_style.count;
        } else {
            return 0;
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID=@"cellID";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.textColor=[CYTSI colorWithHexString:@"#333333"];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
    }
    
    if (tableView==myTableView) {
        
        if (_type==1) {
            
            CarModel * car=carTypeArray[indexPath.section];
            cell.textLabel.text=car.brand_name;
            if (currentSelectedType==indexPath.section) {
                cell.backgroundColor=TABLEVIEW_BACKCOLOR;
            }else{
                cell.backgroundColor=[UIColor whiteColor];
            }
            
        } else {
            
            CarModel * car=colorArray[indexPath.section];
            cell.textLabel.text=car.color_name;
            
        }
        
    } else {
        
        CarModel * car=carTypeArray[currentSelectedType];
        CarModel * theCar=car.vehicle_style[indexPath.section];
        cell.textLabel.text=theCar.brand_name;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==myTableView) {
        
        if (_type==1) {//选择品牌
            
            currentSelectedType=indexPath.section;
            [myTableView reloadData];
            [detailTableView reloadData];
            
        } else {//选择颜色
            
            NSArray * vcArray=self.navigationController.viewControllers;
            if (_OtherType!=1) {
                for (Register_TWO_ViewController * vc in vcArray) {
                    
                    if ([vc isKindOfClass:[Register_TWO_ViewController class]]) {
                        
                        vc.carColor=colorArray[indexPath.section];
                        [self.navigationController popToViewController:vc animated:YES];
                        
                    }
                    
                }

            }else{
                for (Add_TWO_ViewController * vc in vcArray) {
                    
                    if ([vc isKindOfClass:[Add_TWO_ViewController class]]) {
                        
                        vc.carColor=colorArray[indexPath.section];
                        [self.navigationController popToViewController:vc animated:YES];
                        
                    }
                    
                }

                
            }
            
        }
        
    } else {//选择子品牌
        
        NSArray * vcArray=self.navigationController.viewControllers;
        if (_OtherType!=1) {
            for (Register_TWO_ViewController * vc in vcArray) {
                
                if ([vc isKindOfClass:[Register_TWO_ViewController class]]) {
                    
                    CarModel * car=carTypeArray[currentSelectedType];
                    CarModel * theCar=car.vehicle_style[indexPath.section];
                    vc.carBrandName=car.brand_name;
                    vc.vehicleStyle=theCar.brand_name;
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
                
            }

        }else{
            for (Add_TWO_ViewController * vc in vcArray) {
                
                if ([vc isKindOfClass:[Add_TWO_ViewController class]]) {
                    
                    CarModel * car=carTypeArray[currentSelectedType];
                    CarModel * theCar=car.vehicle_style[indexPath.section];
                    vc.carBrandName=car.brand_name;
                    vc.vehicleStyle=theCar.brand_name;
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
                
            }

            
        }
        
    }
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
