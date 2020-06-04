//
//  SureTiXianViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "SureTiXianViewController.h"
#import "BankCardTableViewCell.h"
#import "BankCardModel.h"

@interface SureTiXianViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView * myTableView;
    UIView * blackView;
    UIView * bgView;
    NSArray * bankArray;//开户行数组
    NSInteger selectedBank;//选择的银行
}

@end

@implementation SureTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"申请提现";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self creatHttp];//请求银行卡列表
    
    _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    _codeButton.layer.cornerRadius=3;
    _codeButton.layer.masksToBounds=YES;
    _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
    _codeButton.layer.borderWidth=2;
    
    _codeTextFiled.delegate=self;
    _codeTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    _moneyTextFiled.delegate=self;
    _moneyTextFiled.keyboardType=UIKeyboardTypeDecimalPad;
    
    _submitButton.layer.cornerRadius=3;
    _submitButton.layer.masksToBounds=YES;
    
    _moneyTextFiled.placeholder=[NSString stringWithFormat:@"可提现余额为%@元",_moneyStr];
    
}
#pragma mark textFiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSRange rangeItem = [textField.text rangeOfString:@"."];//判断字符串是否包含
    
    if (rangeItem.location!=NSNotFound){
        if ([string isEqualToString:@"."]) {
            return NO;
        }else{
            //rangeItem.location == 0   说明“.”在第一个位置
            if (range.location>rangeItem.location+2) {
                return NO;
            }
        }
    }else{
        if ([string isEqualToString:@"."]) {
            if (textField.text.length<1) {
                textField.text = @"0.";
                return NO;
            }
            return YES;
        }
    }
    
    return YES;
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

//请求银行卡列表
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERBANK_LIST params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:NO special:0 success:^(id responseObject) {
        
        bankArray=[BankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [myTableView reloadData];
        
        BankCardModel * bank=bankArray[0];
        [_bankCardImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_IMG_URL,bank.bank_logo]]];
        _bankCardLable.text=bank.bank_name;
        _bankCardNumberLable.text=bank.account;
        
        [self hideBankView];
        
        
    } failure:^(NSError *error) {
        
    }];
}

//创建主要视图
-(void)creatMainView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    blackView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    blackView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
    [window addSubview:blackView];
    
    UIButton * hideButton=[UIButton buttonWithType:UIButtonTypeCustom];
    hideButton.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [hideButton addTarget:self action:@selector(hideBankView) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:hideButton];
    
    bgView=[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth, (window.frame.size.height-220)/2, DeviceWidth-80, 220)];
    bgView.backgroundColor=[CYTSI colorWithHexString:@"#383635"];
    [window addSubview:bgView];
    
    UILabel * titleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, DeviceWidth-100, 20)];
    titleLable.font=[UIFont systemFontOfSize:14];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.textColor=[UIColor whiteColor];
    titleLable.text=@"选择银行卡";
    [bgView addSubview:titleLable];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, DeviceWidth-80, 180) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [bgView addSubview:myTableView];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_moneyTextFiled resignFirstResponder];
    [_codeTextFiled resignFirstResponder];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"bankcardcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BankCardTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    BankCardModel * bank=bankArray[indexPath.row];
    [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_IMG_URL,bank.bank_logo]]];
    cell.nameLable.text=bank.bank_name;
    cell.numberLable.text=bank.account;
    
    return cell;
}

//选择按钮点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBank=indexPath.row;
    [myTableView reloadData];
    
    BankCardModel * bank=bankArray[selectedBank];
    [_bankCardImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTP_IMG_URL,bank.bank_logo]]];
    _bankCardLable.text=bank.bank_name;
    _bankCardNumberLable.text=bank.account;
    
    [self hideBankView];
}

//选择银行卡按钮点击事件
- (IBAction)chooseBankCardButtonClicked:(id)sender
{
    [self showBankView];
}

//显示银行卡视图
-(void)showBankView
{
    CGFloat height=64*bankArray.count+40;
    if (height>DeviceHeight-64-80) {
        height=DeviceHeight-64-80;
    }
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    blackView.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        
        bgView.frame=CGRectMake(40, (window.frame.size.height-height)/2, DeviceWidth-80, height);
        
    }];
}

//隐藏银行卡视图
-(void)hideBankView
{
    CGFloat height=64*bankArray.count+40;
    if (height>DeviceHeight-64-80) {
        height=DeviceHeight-64-80;
    }
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    blackView.frame=CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        
        bgView.frame=CGRectMake(DeviceWidth, (window.frame.size.height-height)/2, DeviceWidth-80, height);
        
    }];
    myTableView.frame=CGRectMake(0, 40, DeviceWidth-80, height-40);
}

//验证码按钮点击事件
- (IBAction)codeButtonClicked:(id)sender
{
    [_moneyTextFiled resignFirstResponder];
    
    if ([_moneyTextFiled.text floatValue]<=0.00) {
        [CYTSI otherShowTostWithString:@"请输入提现金额"];
        return;
    }

    if ([_moneyTextFiled.text floatValue]>[_moneyStr floatValue]) {
        [CYTSI otherShowTostWithString:@"余额不足"];
        return;
    }
    [self startTime];
    
    NSString * ipAddress=[CYTSI deviceWANIPAdress];
    
    [AFRequestManager postRequestWithUrl:DRIVER_WITHDRAW_SEND_VERIFY params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"network_ip":ipAddress,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        [CYTSI otherShowTostWithString:@"验证码已发送"];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

//提交按钮点击事件
- (IBAction)submitButtonClicked:(id)sender
{
    [_moneyTextFiled resignFirstResponder];
    [_codeTextFiled resignFirstResponder];
    
    if ([_moneyTextFiled.text floatValue]<=0.00) {
        [CYTSI otherShowTostWithString:@"请输入提现金额"];
        return;
    }
    
    if ([_moneyTextFiled.text floatValue]>[_moneyStr floatValue]) {
        [CYTSI otherShowTostWithString:@"余额不足"];
        return;
    }
    
    if ([_codeTextFiled.text intValue]==0) {
        [CYTSI otherShowTostWithString:@"请输入验证码"];
        return;
    }
    
    BankCardModel * bank=bankArray[selectedBank];
    
    [AFRequestManager postRequestWithUrl:DRIVER_WITHDRAW params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"money":_moneyTextFiled.text,@"bank_id":bank.bank_id,@"verify_code":_codeTextFiled.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        [CYTSI otherShowTostWithString:@"申请成功，请耐心等待！"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)startTime{
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                _codeButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
                _codeButton.layer.borderColor=RGBA(129, 185, 251, 1).CGColor;
                
                _codeButton.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [_codeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                _codeButton.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
                _codeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
                
                [UIView commitAnimations];
                
                _codeButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
            
            
        }
        
    });
    
    dispatch_resume(_timer);
    
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
