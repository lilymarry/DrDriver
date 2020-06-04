//
//  CardTiXianViewController.m
//  HouseManager
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CardTiXianViewController.h"
#import "CYAlertView.h"
#import "AddBankCardSuccessViewController.h"
#import "ChooseBankCardTableViewCell.h"
#import "BankCardModel.h"

@interface CardTiXianViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    CYAlertView * singleAlertView;//单个按钮弹出视图
    UITableView * myTableView;
    UIView * blackView;
    UIView * bgView;
    NSArray * bankArray;//开户行数组
    NSInteger selectedBank;//选择的银行
  
}

@end

@implementation CardTiXianViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nameTextFiled.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Dname"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"添加银行卡";
    [self setUpNav];//创建导航栏视图
    [self creatAlertView];//创建弹出视图
    [self creatMainView];//创建主要视图
    
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc]initWithString:_nameTextFiled.placeholder attributes:@{NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _nameTextFiled.attributedPlaceholder = nameText;
    _nameTextFiled.enabled = NO;
    NSMutableAttributedString *cardNum = [[NSMutableAttributedString alloc]initWithString:_cardNumTextFiled.placeholder attributes:@{NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _cardNumTextFiled.attributedPlaceholder = cardNum;
    
    NSMutableAttributedString *yinHang = [[NSMutableAttributedString alloc]initWithString:_yinHangTextFiled.placeholder attributes:@{NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _yinHangTextFiled.attributedPlaceholder = yinHang;
    
    NSMutableAttributedString *moneyText = [[NSMutableAttributedString alloc]initWithString:_moneyTextFiled.placeholder attributes:@{NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _moneyTextFiled.attributedPlaceholder = moneyText;
    
    _nameTextFiled.delegate=self;
    _nameTextFiled.returnKeyType=UIReturnKeyDone;
    
    _cardNumTextFiled.delegate=self;
    _cardNumTextFiled.returnKeyType=UIReturnKeyDone;
    _cardNumTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    _yinHangTextFiled.delegate=self;
    _yinHangTextFiled.returnKeyType=UIReturnKeyDone;
    _yinHangTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    _moneyTextFiled.delegate=self;
    _moneyTextFiled.returnKeyType=UIReturnKeyDone;
//    _moneyTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    
    [self creatHttp];//请求开户行
    
}

//创建弹出视图
-(void)creatAlertView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    singleAlertView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    singleAlertView.titleStr=@"信息填写错误";
    singleAlertView.alertStr=@"您的信息填写错误，请核对后重试。";
    singleAlertView.cancleButtonStr=@"";
    singleAlertView.sureButtonStr=@"我知道了";
    [singleAlertView setTextFiled:YES];
    [singleAlertView setSingleButton];
    [window addSubview:singleAlertView];
    
    __weak typeof (singleAlertView) weakSingleAlertView = singleAlertView;
    singleAlertView.phoneBlock = ^{
        
        [weakSingleAlertView hideAlertView];
        
    };
    
}

-(void)dealloc
{
    [singleAlertView removeFromSuperview];
}

//请求开户行
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_BANK_CLASS_LIST params:@{} tost:NO special:0 success:^(id responseObject) {
        
        bankArray=[BankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [myTableView reloadData];
        
        BankCardModel * bank=bankArray[0];
        _moneyTextFiled.text=bank.bank_name;
        
        [self hideBankView];
        
    } failure:^(NSError *error) {
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameTextFiled resignFirstResponder];
    [_cardNumTextFiled resignFirstResponder];
    [_yinHangTextFiled resignFirstResponder];
    [_moneyTextFiled resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextFiled resignFirstResponder];
    [_cardNumTextFiled resignFirstResponder];
    [_yinHangTextFiled resignFirstResponder];
    [_moneyTextFiled resignFirstResponder];
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
    
}

//导航栏返回按钮
-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提现按钮点击事件
- (IBAction)buyButtonClicked:(id)sender
{
    if ([_nameTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请输入持卡人姓名"];
        return;
    }
    if ([_cardNumTextFiled.text isEqualToString:@""] && _cardNumTextFiled.text.length>=15) {
        [CYTSI otherShowTostWithString:@"请输入银行卡卡号"];
        return;
    }
    if ([_yinHangTextFiled.text intValue]==0) {
        [CYTSI otherShowTostWithString:@"请再次输入银行卡号"];
        return;
    }
    if ([_moneyTextFiled.text isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请选择开户行"];
        return;
    }
    
    if (![_cardNumTextFiled.text isEqualToString:_yinHangTextFiled.text]) {
//        [CYTSI otherShowTostWithString:@"两次输入的卡号不一致"];
        [singleAlertView showAlertView];
        return;
    }
    
    BankCardModel * bank=bankArray[selectedBank];
    
    [AFRequestManager postRequestWithUrl:DRIVER_DRIVERBANK_ADD_DRIVER_BANK params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"person_name":_nameTextFiled.text,@"bank_class_id":bank.bank_class_id,@"account":_cardNumTextFiled.text,@"bank_address":bank.bank_name,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        AddBankCardSuccessViewController * vc=[[AddBankCardSuccessViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
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
    titleLable.text=@"选择银行";
    [bgView addSubview:titleLable];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + k_Height_NavBar, DeviceWidth-80, 180) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [bgView addSubview:myTableView];

    
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
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseBankCardTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"choosebankcardcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ChooseBankCardTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.chooseButton.tag=10+indexPath.row;
    [cell.chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row==selectedBank) {
        cell.chooseButton.selected=YES;
    }
    
    BankCardModel * bank=bankArray[indexPath.row];
    [cell.bankImageView sd_setImageWithURL:[NSURL URLWithString:bank.bank_logo]];
    cell.bankNameLable.text=bank.bank_name;
    
    return cell;
}

//选择开户行按钮点击事件
- (IBAction)chooseBankButtonClicked:(id)sender
{
    [_nameTextFiled resignFirstResponder];
    [_cardNumTextFiled resignFirstResponder];
    [_yinHangTextFiled resignFirstResponder];
    
    [self showBankView];
}

//选择按钮点击事件
-(void)chooseButtonClicked:(UIButton *)btn
{
    selectedBank=btn.tag-10;
    [myTableView reloadData];
    
    BankCardModel * bank=bankArray[selectedBank];
    _moneyTextFiled.text=bank.bank_name;
    
    [self hideBankView];
}

//显示银行卡选择
-(void)showBankView
{
    CGFloat height=60*bankArray.count+40;
    if (height>DeviceHeight-64-80) {
        height=DeviceHeight-64-80;
    }
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    blackView.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        
        bgView.frame=CGRectMake(40, (window.frame.size.height-height)/2, DeviceWidth-80, height);
        
    }];
}

//隐藏银行卡选择
-(void)hideBankView
{
    CGFloat height=60*bankArray.count+40;
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
