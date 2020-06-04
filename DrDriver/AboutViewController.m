//
//  AboutViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutUsViewController.h"
#import "PhoneUsViewController.h"

@interface AboutViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"关于";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    
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

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
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
        cell.textLabel.textColor=[CYTSI colorWithHexString:@"#333333"];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        UIImageView * rightImageView=[[UIImageView alloc]init];
        rightImageView.image=[UIImage imageNamed:@"left_cell_arrow"];
        [cell addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right).with.offset(-12);
            make.centerY.equalTo(cell.mas_centerY);
            make.width.equalTo(@5);
            make.height.equalTo(@11);
        }];
        
        UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(12, 43.5, DeviceWidth-12, 0.5)];
        lineView.tag=1;
        lineView.backgroundColor=[CYTSI colorWithHexString:@"#999999"];
        [cell addSubview:lineView];
        
    }
    
    UIView * lineView=[cell viewWithTag:1];
    if (indexPath.row==1) {
        lineView.hidden=YES;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=@"联系我们";
        }
            break;
        case 1:
        {
            cell.textLabel.text=@"关于我们";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://联系我们
        {
            PhoneUsViewController * vc=[[PhoneUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1://关于我们
        {
            AboutUsViewController * vc=[[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
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
