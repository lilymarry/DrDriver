//
//  SchoolViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/14.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SchoolViewController.h"
#import "SLContratViewController.h"
#import "SLTripListViewController.h"

@interface SchoolViewController ()
@property (weak, nonatomic) IBOutlet UIView *contractView;//合约View
@property (weak, nonatomic) IBOutlet UIView *tripView;//行程View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;//距顶部距离
@end

@implementation SchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.whichType isEqualToString:@"0"]) {
         self.title = @"校园拼";
    }else{
         self.title = @"通勤行";
    }
   
    //添加手势
    UITapGestureRecognizer *ContratTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contractDidTap)];
    [self.contractView addGestureRecognizer:ContratTap];
    
    UITapGestureRecognizer *tripTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripDidTap)];
    [self.tripView addGestureRecognizer:tripTap];
    self.heightCon.constant = IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 100 : 66;
    [self setUpNav];
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
//跳转到合约列表
- (void)contractDidTap{
    SLContratViewController *contractVC = [[SLContratViewController alloc] init];
    contractVC.whichType = self.whichType;
    [self.navigationController pushViewController:contractVC animated:YES];
}

- (void)tripDidTap{
    SLTripListViewController *listVC = [[SLTripListViewController alloc] init];
    listVC.whichType = self.whichType;
    [self.navigationController pushViewController:listVC animated:YES];
    
}
//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
