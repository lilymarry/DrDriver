//
//  PeakAndTodayHoursViewController.m
//  DrDriver
//
//  Created by fy on 2018/10/18.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "PeakAndTodayHoursViewController.h"
#import <WebKit/WebKit.h>

@interface PeakAndTodayHoursViewController ()<WKUIDelegate>
@property(nonatomic,strong)WKWebView *WebView;
@end

@implementation PeakAndTodayHoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNav];//设置导航栏
    self.view.backgroundColor = [UIColor whiteColor];
    self.WebView = [[WKWebView alloc] init];
    [self.view addSubview:self.WebView];
    [self.WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.view);
    }];
    self.WebView.UIDelegate = self;
    
    NSString *URLString;
    if ([self.state isEqualToString:@"peak"]) {
        self.title = @"高峰在线";
        URLString = [NSString stringWithFormat:@"%@Driver/OnTime/online_times/driver_id/%@/token/%@/isgf/%@/currdate/%@",HTTP_URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"1",[CYTSI getToday]];
    }else{
        self.title = @"今日在线";
        URLString = [NSString stringWithFormat:@"%@Driver/OnTime/online_times/driver_id/%@/token/%@/isgf/%@/currdate/%@",HTTP_URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"0",[CYTSI getToday]];
    }
    
    NSLog(@"%@",URLString);
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
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
