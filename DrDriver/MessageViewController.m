//
//  MessageViewController.m
//  DrUser
//
//  Created by fy on 2018/10/12.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "MessageViewController.h"
#import "MineMessageModel.h"
#import "MessageTableViewCell.h"
#import "MineMessageViewController.h"
#import <WebKit/WebKit.h>

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate>

{
    UITableView * myTableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)WKWebView *WebView;






@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title=@"消息中心";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.dataArray = [NSMutableArray array];
    [self setUpNav];//设置导航栏
//    [self creatHttp];//请求界面数据
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"jpushMessage"];
    
    self.WebView = [[WKWebView alloc] init];
    [self.view addSubview:self.WebView];
    [self.WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
    }];
    self.WebView.UIDelegate = self;
    
    NSString *URLString = [NSString stringWithFormat:@"%@Driver/DriverMessage/notice/driver_id/%@/token/%@",HTTP_URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
//    NSLog(@"%@",URLString);
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    self.WebView.UIDelegate = self;
    [self.WebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

//WkWebView的 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.WebView) {
            self.title = self.WebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
}

- (void)dealloc{
    [self.WebView removeObserver:self forKeyPath:@"title"];
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
    if ([self.WebView canGoBack]) {
        [self.WebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//请求界面数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERMESSAGE_DRIVER_MESSAGE_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        //分出日期添加的数组dateArr中
        NSMutableArray *dateArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSString *ctime = dic[@"ctime"];
            NSArray *array = [ctime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
            NSString *str = array[0];
            if (![dateArr containsObject:str]) {
                [dateArr addObject:str];
            }
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSString *str in dateArr) {
            NSMutableArray *arr = [NSMutableArray array];
            [dataArr addObject:@{str:arr}];
        }
        //对应日期添加当天的消息到数组中
        for (NSDictionary *datadic in responseObject[@"data"]) {
            NSString *ctime = datadic[@"ctime"];
            NSArray *array = [ctime componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
            NSString *str = array[0];
            for (NSDictionary *dic in dataArr) {
                if ([dic.allKeys[0] isEqualToString:str]) {
                    NSMutableArray *arr = dic.allValues[0];
                    [arr addObject:datadic];
                }
            }
        }
        [self.dataArray addObjectsFromArray:dataArr];
        [self creatMainView];//创建主要视图
        
        
    } failure:^(NSError *error) {

    }];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.detailLB.text=dic.allValues[0][indexPath.row][@"content"];
    cell.timeLB.text = dic.allValues[0][indexPath.row][@"ctime"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineMessageViewController *vc = [[MineMessageViewController alloc] init];
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
