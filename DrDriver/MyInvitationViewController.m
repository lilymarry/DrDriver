//
//  MyInvitationViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "MyInvitationViewController.h"
#import "MyInvitationTableViewCell.h"
#import "InvitationModel.h"
#import "CYShareView.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "APOpenAPI.h"

@interface MyInvitationViewController () <UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;
    NSArray * recordArray;//邀请记录数组
    UILabel * numberLable;
    CYShareView * shareView;//分享视图
}

@end

@implementation MyInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"我的邀请";
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self requestInvitation];//请求邀请记录
    [self creatShareView];//创建分享视图
    
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
    
//    UIButton * shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    shareButton.frame=CGRectMake(0, 0, 40, 20);
//    shareButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
//    [shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:shareButton];
//    self.navigationItem.rightBarButtonItem=rightItem;
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享按钮点击事件
-(void)shareButtonClicked
{
    [shareView showShareView];
}

//创建分享视图
-(void)creatShareView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    shareView=[[CYShareView alloc]initWithFrame:CGRectMake(0, window.frame.size.height, window.frame.size.width, window.frame.size.height) imageArray:@[@"QQ_share",@"weichat_share",@"alipay_share"] titleArray:@[@"QQ",@"微信",@"支付宝"]];
    [window addSubview:shareView];
    
    shareView.shareClicked = ^(NSInteger index) {
        
        switch (index) {
            case 0://QQ
            {
                //qq分享
                //开发者分享图片数据
                UIImage * image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"driver_logo@2x" ofType:@"png"]];
                NSData *imgData = UIImagePNGRepresentation(image);
                QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                           previewImageData:imgData
                                                                      title:@"网路出行司机"
                                                               description :@"快乐出行每一天！"];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
                //将内容分享到qq
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            }
                break;
            case 1://微信
            {
                //分享微信
                WXMediaMessage * message=[WXMediaMessage message];
                [message setThumbImage:[UIImage imageNamed:@"driver_logo"]];
                //缩略图
                WXImageObject * imageObject=[WXImageObject object];
                NSString * filePath=[[NSBundle mainBundle] pathForResource:@"driver_logo@2x" ofType:@"png"];
                imageObject.imageData=[NSData dataWithContentsOfFile:filePath];
                message.mediaObject=imageObject;
                
                SendMessageToWXReq * req=[[SendMessageToWXReq alloc]init];
                req.bText=NO;
                req.message=message;
                req.scene=WXSceneSession;
                [WXApi sendReq:req];
            }
                break;
            case 2://支付宝
            {
                //分享到支付宝
                //  创建消息载体 APMediaMessage 对象
                APMediaMessage *message = [[APMediaMessage alloc] init];
                
                //  创建图片类型的消息对象
                APShareImageObject *imgObj = [[APShareImageObject alloc] init];
                imgObj.imageUrl = @"http://img1.skqkw.cn:888/2014/12/06/08/21ofdtyslqn-62877.jpg";
                //图片也可使用imageData字段分享本地UIImage类型图片，必须填充有效的image NSData类型数据，否则无法正常分享
                //例如 imgObj.imageData = UIImagePNGRepresentation(Your UIImage Obj);
                
                //  回填 APMediaMessage 的消息对象
                message.mediaObject = imgObj;
                
                //  创建发送请求对象
                APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
                //  填充消息载体对象
                request.message = message;
                //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至当前版本，分享入口已合并，scene参数并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题，建议还是照常传入。
                request.scene = 0;
                //  发送请求
                BOOL result = [APOpenAPI sendReq:request];
                if (!result) {
                    //失败处理
//                    NSLog(@"发送失败");
                }
            }
                break;
            default:
                break;
        }
        
    };
}

//请求邀请记录
-(void)requestInvitation
{
    [AFRequestManager postRequestWithUrl:DRIVER_INVITE_INFO params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        recordArray=[InvitationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [myTableView reloadData];
        numberLable.text=[NSString stringWithFormat:@"%d",recordArray.count];
        
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
    
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 93)];
    headView.backgroundColor=[UIColor whiteColor];
    
    numberLable=[[UILabel alloc]init];
    numberLable.text=@"0";
    numberLable.textColor=[CYTSI colorWithHexString:@"#386ac6"];
    numberLable.font=[UIFont systemFontOfSize:25];
    numberLable.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:numberLable];
    [numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.height.equalTo(@36);
        make.width.equalTo(@120);
        make.top.equalTo(@18);
    }];
    
    UILabel * peopleLable=[[UILabel alloc]init];
    peopleLable.text=@"邀请人数(人)";
    peopleLable.textColor=[CYTSI colorWithHexString:@"#666666"];
    peopleLable.font=[UIFont systemFontOfSize:14];
    peopleLable.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:peopleLable];
    [peopleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
        make.top.equalTo(numberLable.mas_bottom);
    }];
    
    [myTableView setTableHeaderView:headView];
    
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordArray.count;
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
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInvitationTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"myinvitationcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MyInvitationTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    InvitationModel * invitation=recordArray[indexPath.row];
    cell.dateLable.text=invitation.ctime;
    cell.nameLable.text=invitation.nickname;
    cell.typeLable.text=invitation.invite_class;
    cell.phoneLable.text=invitation.account;
    
    if (indexPath.row == recordArray.count-1) {
        
        cell.lineView.hidden = YES;
    }
    
    return cell;
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
