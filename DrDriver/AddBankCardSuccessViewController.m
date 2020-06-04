//
//  AddBankCardSuccessViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "AddBankCardSuccessViewController.h"
#import "BankCardViewController.h"
#import "TripDetailViewController.h"
#import "OrderDetailModel.h"
@interface AddBankCardSuccessViewController ()
{
    
    OrderDetailModel * orderDetail;

}
@end

@implementation AddBankCardSuccessViewController
-(void)viewWillAppear:(BOOL)animated{
     [self setUpNav];//创建导航栏视图
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"添加成功";
   
    if (DeviceHeight>737) {
        self.topLine.constant = 64+44;
    }
    if (_isOrder) {
        
        self.title=@"乘客支付成功";
        [AFRequestManager postRequestWithUrl:DRIVER_JOURNEY_ORDER_DETAIL_INFO params:@{@"order_id":_orderId,@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
            
            
            orderDetail=[OrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.theLable.text=[NSString stringWithFormat:@"支付%@元",orderDetail.journey_fee];

            
        } failure:^(NSError *error) {
            
        }];

        
    }
    
}

//创建导航栏视图
-(void)setUpNav
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 20, 40);
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * lefItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=lefItem;
    
    UIButton *  changeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame=CGRectMake(0, 0, 40, 20);
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeButton setTitle:@"完成" forState:UIControlStateNormal];
    changeButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:changeButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//导航栏返回按钮
-(void)backButtonClicked
{
    if (_isOrder) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        NSArray * vcArray=self.navigationController.viewControllers;
        for (BankCardViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[BankCardViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            }
            
        }
        
    }
    
}

//完成按钮点击事件
-(void)changeButtonClicked
{
    if (_isOrder) {
        
        TripDetailViewController * vc=[[TripDetailViewController alloc]init];
        vc.orderID=_orderId;
        vc.isSuccess=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        NSArray * vcArray=self.navigationController.viewControllers;
        for (BankCardViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[BankCardViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
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
