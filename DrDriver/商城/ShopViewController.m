//
//  ShopViewController.m
//  DrDriver
//
//  Created by fy on 2019/4/19.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ShopViewController.h"
#import <WebKit/WebKit.h>

@interface ShopViewController ()<WKUIDelegate>
@property(nonatomic,strong)WKWebView *WebView;

@end

@implementation ShopViewController

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
    self.title = @"易出行商城";
    URLString = @"http://www.e1860.com/";
    
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
    
    UIButton *Button=[UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame=CGRectMake(0, 0, 40, 40);
    Button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [Button setTitle:@"刷新" forState:(UIControlStateNormal)];
    [Button addTarget:self action:@selector(ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *Item=[[UIBarButtonItem alloc] initWithCustomView:Button];
    self.navigationItem.rightBarButtonItem=Item;
}
-(void)ButtonClicked{
    [self.WebView reload];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
