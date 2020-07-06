//
//  PromotionViewController.m
//  DrDriver
//
//  Created by fy on 2020/7/3.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "PromotionViewController.h"

@interface PromotionViewController ()
@property (strong, nonatomic) IBOutlet UIButton *friendBtn;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *pictureBtn;

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动推广";
    [self setUpNav];
    
    _friendBtn.layer.cornerRadius=15;
    _friendBtn.layer.masksToBounds=YES;
    
    _codeBtn.layer.cornerRadius=15;
    _codeBtn.layer.masksToBounds=YES;
    
    _pictureBtn.layer.cornerRadius=15;
    _pictureBtn.layer.masksToBounds=YES;
    
    
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
-(void)navBackButtonClicked
{
   [self.navigationController popViewControllerAnimated:YES];
   
}
@end
