//
//  AboutUsViewController.m
//  takeOut
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [AFRequestManager postRequestWithUrl:INDEX_ABOUT_US params:@{} tost:NO special:NO success:^(id responseObject) {
//        
//        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//            
////            AboutUsModel * aboutUs=[AboutUsModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
//            
////            _companyName.text=aboutUs.company_name;
////            _totalLable.text=aboutUs.copyright;
////            [_appLogoIamgeView sd_setImageWithURL:[NSURL URLWithString:aboutUs.app_logo]];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"关于我们";
    self.view.backgroundColor=VIEW_BACKGROUND_COLOR;
    
    _appLogoIamgeView.layer.cornerRadius=20;
    _appLogoIamgeView.layer.masksToBounds=YES;
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 20, 40);
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * lefItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=lefItem;
    
}

//返回按钮
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
