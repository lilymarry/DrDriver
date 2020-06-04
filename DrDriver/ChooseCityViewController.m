//
//  ChooseCityViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "PerfectOneViewController.h"
#import "Register_ONE_ViewController.h"
#import "Add_ONE_ViewController.h"
@interface ChooseCityViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView * myTableView;
    UITextField * searchTextFiled;
    NSMutableArray * cityArray;//城市数组A~Z
    NSArray * cityFirstArray;//城市索引数组A~Z
}

@end

@implementation ChooseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"服务城市";
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
    NSMutableArray *  cityDatas = [[NSMutableArray alloc] init];
    for (NSDictionary *groupDic in array) {
        
        for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
            //  city.cityName = [dic objectForKey:@"city_name"];
            [cityDatas addObject:dic[@"city_name"]];
        }
        
    }

    cityArray=[[NSMutableArray alloc]init];
    
    [self setUpNav];//创建导航栏
    [self creatMainView];//创建主要视图
    [self setUpArray:cityDatas];//整理城市数组
    
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
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 144)];
    headerView.backgroundColor=[CYTSI colorWithHexString:@"#ececec"];
    
    //搜索视图
    searchTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(12, 6, DeviceWidth-24, 44)];
    searchTextFiled.backgroundColor=[UIColor whiteColor];
    searchTextFiled.font=[UIFont systemFontOfSize:14];
    searchTextFiled.placeholder=@"请输入城市名或昵称";
    searchTextFiled.returnKeyType=UIReturnKeySearch;
    searchTextFiled.delegate=self;
    searchTextFiled.layer.cornerRadius=3;
    searchTextFiled.layer.masksToBounds=YES;
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    leftView.backgroundColor=[UIColor whiteColor];
    
    UIImageView * leftImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_leftview"]];
    leftImageView.frame=CGRectMake(13, 13, 19, 19);
    [leftView addSubview:leftImageView];
    
    searchTextFiled.leftView=leftView;
    searchTextFiled.leftViewMode=UITextFieldViewModeAlways;
    [headerView addSubview:searchTextFiled];
    
    //定位城市
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 56, DeviceWidth, 88)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [headerView addSubview:bgView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(12, 13, 60, 18)];
    label.text=@"定位城市";
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[CYTSI colorWithHexString:@"#999999"];
    [bgView addSubview:label];
    
    UIView * smallView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, DeviceWidth, 44)];
    smallView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:smallView];
    
    UILabel * locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 60, 20)];
    locationLabel.text=[NSString stringWithFormat:@"%@",self.locationCityStr];
    locationLabel.font=[UIFont systemFontOfSize:14];
    locationLabel.textColor=[CYTSI colorWithHexString:@"#333333"];
    [smallView addSubview:locationLabel];
    
    UIButton * locationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"location_city"] forState:UIControlStateNormal];
    locationButton.frame=CGRectMake(DeviceWidth-44, 0, 44, 44);
    [smallView addSubview:locationButton];
    
    UIButton * theButton=[UIButton buttonWithType:UIButtonTypeCustom];
    theButton.frame=CGRectMake(0, 0, DeviceWidth, 44);
    [theButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [smallView addSubview:theButton];
    
    [myTableView setTableHeaderView:headerView];
    
}

//定位按钮点击事件
-(void)locationButtonClicked
{
    NSArray * vcArray=self.navigationController.viewControllers;
    if (_Type!=1) {
        for (Register_ONE_ViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[Register_ONE_ViewController class]]) {
                
                vc.choosedCity=[NSString stringWithFormat:@"%@",self.locationCityStr];
                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }

    }else{
        for (Add_ONE_ViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[Add_ONE_ViewController class]]) {
                
                vc.choosedCity=[NSString stringWithFormat:@"%@",self.locationCityStr];
                vc.faceState = @"main";
                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }

        
    }
}

#pragma mark - UITextFiled 的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTextFiled resignFirstResponder];
    
    
    
    return YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [searchTextFiled resignFirstResponder];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cityFirstArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array=cityArray[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]init];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(12, 13, 60, 18)];
    label.text=cityFirstArray[section];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[CYTSI colorWithHexString:@"#999999"];
    [bgView addSubview:label];
    
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textColor=[CYTSI colorWithHexString:@"#333333"];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
    }
    
    NSArray * array=cityArray[indexPath.section];
    cell.textLabel.text=array[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array=cityArray[indexPath.section];
    
    NSArray * vcArray=self.navigationController.viewControllers;
    if (_Type!=1) {
        for (Register_ONE_ViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[Register_ONE_ViewController class]]) {
                
                vc.choosedCity=array[indexPath.row];
                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }

    }else{
        for (Add_ONE_ViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[Add_ONE_ViewController class]]) {
                
                vc.choosedCity=array[indexPath.row];
                [self.navigationController popToViewController:vc animated:YES];
            }
            
        }

        
        
    }

}

//整理城市数组
-(void)setUpArray:(NSMutableArray *)array
{
    NSMutableArray * firstArray=[[NSMutableArray alloc]init];
    for (NSString * city in array) {
        
        NSString * firstStr=[CYTSI firstCharactorWithString:city];
        
        //有哪些首字母
        int isHave=NO;
        for (NSString * str in firstArray) {
            
            if (str==firstStr) {
                isHave=YES;
                break;
            }
            
        }
        if (isHave==NO) {
            [firstArray addObject:firstStr];
        }
        
    }
    CYLog(@"首字母数组：%@",firstArray);
    
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
    for (int i=0; i<firstArray.count; i++) {
        
        NSString * firstStr=firstArray[i];
        NSMutableArray * theCityArray=[[NSMutableArray alloc]init];
        for (NSString * str in array) {
            
            NSString * theStr=[CYTSI firstCharactorWithString:str];

            if ([firstStr isEqualToString:theStr]) {
                
                [theCityArray addObject:str];
                
            }
            
        }
        
        [dic setObject:theCityArray forKey:firstStr];
        
    }
    CYLog(@"城市字典：%@",dic);
    
    for (NSString * str in firstArray) {
        
        NSArray * theArray=dic[str];
        NSArray * newArray=[theArray sortedArrayUsingSelector:@selector(localizedCompare:)];//中文排序
        [dic setObject:newArray forKey:str];
        
    }
    
    CYLog(@"内部排序后的城市字典：%@",dic);
    
    //字母的简单排序
    cityFirstArray = [firstArray sortedArrayUsingSelector:@selector(compare:)];
    CYLog(@"排序后的首字母数组%@",cityFirstArray);
    
    for (NSString * str in cityFirstArray) {
        
        [cityArray addObject:dic[str]];
        
    }
    
    CYLog(@"排序完成的城市数组：%@",cityArray);
    [myTableView reloadData];
    
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
