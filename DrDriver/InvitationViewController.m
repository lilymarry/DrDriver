//
//  InvitationViewController.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "InvitationViewController.h"
#import "SGQRCode.h"
#import "MyInvitationViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "APOpenAPI.h"

#import "DriverModel.h"

#import <MessageUI/MessageUI.h>

@interface InvitationViewController () <UITextFieldDelegate,MFMessageComposeViewControllerDelegate>

{
    UITableView * myTableView;
    UIImageView * codeImageView;
    UITextField * phoneTextFiled;
}

@end

@implementation InvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"邀请";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    
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
    
    UIButton *  myButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame=CGRectMake(0, 0, 60, 20);
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setTitle:@"我的邀请" forState:UIControlStateNormal];
    myButton.titleLabel.font=[UIFont systemFontOfSize:13];
    
    [myButton addTarget:self action:@selector(myButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//我的邀请按钮点击事件
-(void)myButtonClicked
{
    MyInvitationViewController * vc=[[MyInvitationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 445+158)];
    headerView.backgroundColor=TABLEVIEW_BACKCOLOR;

    UIButton * hidenButton=[UIButton buttonWithType:UIButtonTypeCustom];
    hidenButton.frame=CGRectMake(0, 0, DeviceWidth, 445+158);
    [hidenButton addTarget:self action:@selector(hidenButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:hidenButton];
    
    UILabel * topLable=[[UILabel alloc]init];
    topLable.text=[NSString stringWithFormat:@"邀请码：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_code"]];
    topLable.font=[UIFont boldSystemFontOfSize:25];
    topLable.textColor=[CYTSI colorWithHexString:@"#2d2d2d"];
    topLable.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:topLable];
    [topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(headerView.mas_right).with.offset(-30);
        make.height.equalTo(@36);
        make.top.equalTo(@25);
    }];
    
    UIView * textFieldBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 83, DeviceWidth, 44)];
    textFieldBgView.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:textFieldBgView];
    
    UILabel * textFiledLable=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 60, 20)];
    textFiledLable.text=@"手机号：";
    textFiledLable.textColor=[CYTSI colorWithHexString:@"#2d2d2d"];
    textFiledLable.font=[UIFont systemFontOfSize:14];
    [textFieldBgView addSubview:textFiledLable];
    
    phoneTextFiled=[[UITextField alloc]init];
    phoneTextFiled.placeholder=@"请输入对方手机号";
    phoneTextFiled.delegate=self;
    phoneTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    phoneTextFiled.font=[UIFont systemFontOfSize:14];
    [textFieldBgView addSubview:phoneTextFiled];
    [phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFiledLable.mas_right);
        make.centerY.equalTo(textFiledLable.mas_centerY);
        make.height.equalTo(@20);
        make.right.equalTo(textFieldBgView.mas_right).with.offset(-12);
    }];
    
    UIButton * sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.frame=CGRectMake(15, 165, DeviceWidth-24, 44);
    sendButton.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    sendButton.titleLabel.font=[UIFont systemFontOfSize:16];
    sendButton.layer.cornerRadius=5;
    sendButton.layer.masksToBounds=YES;
    [sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sendButton];
    
    codeImageView=[[UIImageView alloc]init];
    codeImageView.layer.cornerRadius=3;
    codeImageView.layer.masksToBounds=YES;
//    codeImageView.backgroundColor=[UIColor orangeColor];
    [headerView addSubview:codeImageView];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendButton.mas_bottom).with.offset(36);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.and.height.equalTo(@200);
    }];
    
    //分享视图
    UIView * shareView=[[UIView alloc]init];
    shareView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [headerView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(codeImageView.mas_bottom);
        make.right.equalTo(headerView);
        make.height.equalTo(@158);
    }];
    
    UILabel * shareLable=[[UILabel alloc]init];
    shareLable.text=@"分享到";
    shareLable.textColor=[CYTSI colorWithHexString:@"#333333"];
    shareLable.font=[UIFont systemFontOfSize:13];
    shareLable.textAlignment=NSTextAlignmentCenter;
    [shareView addSubview:shareLable];
    [shareLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareView);
        make.top.equalTo(@37);
        make.width.equalTo(@40);
        make.height.equalTo(@18);
    }];
    
    UIView * leftLineView=[[UIView alloc]init];
    leftLineView.backgroundColor=[UIColor lightGrayColor];
    [shareView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareLable);
        make.width.equalTo(@56);
        make.height.equalTo(@0.5);
        make.right.equalTo(shareLable.mas_left).offset(-5);
    }];
    
    UIView * rightLineView=[[UIView alloc]init];
    rightLineView.backgroundColor=[UIColor lightGrayColor];
    [shareView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareLable);
        make.width.equalTo(@56);
        make.height.equalTo(@0.5);
        make.left.equalTo(shareLable.mas_right).offset(5);
    }];
    
    NSMutableArray * imageArray=[NSMutableArray arrayWithObjects:@"weichat_share",@"QQ_share",@"alipay_share", nil];
    NSMutableArray * titleArray=[NSMutableArray arrayWithObjects:@"微信",@"QQ",@"支付宝", nil];
    
    if ([APOpenAPI isAPAppInstalled]==NO) {
        [imageArray removeObjectAtIndex:2];
        [titleArray removeObjectAtIndex:2];
    }
    if ([TencentOAuth iphoneQQInstalled]==NO) {
        [imageArray removeObjectAtIndex:1];
        [titleArray removeObjectAtIndex:1];
    }
    if ([WXApi isWXAppInstalled]==NO) {
        [imageArray removeObjectAtIndex:0];
        [titleArray removeObjectAtIndex:0];
    }    
    
    CGFloat width=50;
    CGFloat space=(DeviceWidth-50*(imageArray.count))/(imageArray.count+1);
    
    for (int i=0; i<imageArray.count; i++) {
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(space+(width+space)*(i%imageArray.count), 68, 50, 76)];
        bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
        [shareView addSubview:bgView];
        
        UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArray[i]]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.width.and.height.equalTo(@50);
            make.top.equalTo(@0);
        }];
        
        UILabel * lable=[[UILabel alloc]init];
        lable.textColor=[CYTSI colorWithHexString:@"#333333"];
        lable.font=[UIFont systemFontOfSize:13];
        lable.text=titleArray[i];
        lable.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.width.equalTo(@50);
            make.height.equalTo(@18);
            make.top.equalTo(imageView.mas_bottom).with.offset(7);
        }];
        
        UIButton * shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.tag=10+i;
        shareButton.frame=CGRectMake(space+(width+space)*(i%imageArray.count), 68, 50, 76);
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:shareButton];
        
    }
    
    [myTableView setTableHeaderView:headerView];
    
    // 生成二维码(Default)
    [self setupGenerateQRCode];
    
//    // 生成二维码(中间带有图标)
//    [self setupGenerate_Icon_QRCode];
//    
//    // 生成二维码(彩色)
//    [self setupGenerate_Color_QRCode];
    
}

//分享按钮点击事件
-(void)shareButtonClicked:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] == nil) {
        
        [CYTSI otherShowTostWithString:@"登录失效"];
        return;
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_SHARE_DRIVER_APP_SHARE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        
        DriverModel * shareModel=[DriverModel mj_objectWithKeyValues:responseObject[@"data"]];
    
//    shareModel.title=@"e出租司机端";
//    shareModel.desc=@"e出租司机端";
//    shareModel.alink_url=@"http://app.wllives.com/index.php/Api/CouponShare/coupon_share_alink";
    
        switch (btn.tag-10) {
            case 1://QQ
            {
                //开发者分享图片数据
                UIImage * image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user_logo@2x" ofType:@"png"]];
                NSData *imgData = UIImagePNGRepresentation(image);
                QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareModel.alink_url] title:shareModel.title description:shareModel.desc previewImageData:imgData];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
                //将内容分享到qq
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            }
                break;
            case 0://微信
            {
                //分享微信
                WXMediaMessage * message=[WXMediaMessage message];
                message.title=shareModel.title;
                message.description=shareModel.desc;
                [message setThumbImage:[UIImage imageNamed:@"user_logo"]];
                //缩略图
                WXWebpageObject * webObject=[WXWebpageObject object];
                webObject.webpageUrl=shareModel.alink_url;
                message.mediaObject=webObject;
                
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
                message.title=shareModel.title;
                message.desc=shareModel.desc;
                
                //  创建图片类型的消息对象
                APShareWebObject *imgObj = [[APShareWebObject alloc] init];
                imgObj.wepageUrl=shareModel.alink_url;
                
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
                    NSLog(@"发送失败");
                }
            }
                break;
            default:
                break;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)hidenButtonClicked
{
    [phoneTextFiled resignFirstResponder];
}

//发送按钮点击事件
-(void)sendButtonClicked
{
    [phoneTextFiled resignFirstResponder];
    
    BOOL isRight=[CYTSI checkTelNumber:phoneTextFiled.text];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的手机号"];
        return;
    }
    
//    [AFRequestManager postRequestWithUrl:DRIVER_RECOMMEND_SEND_VERIFY params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"phone":phoneTextFiled.text} tost:YES special:0 success:^(id responseObject) {
//        
//        [CYTSI otherShowTostWithString:@"发送成功"];
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    MFMessageComposeViewController *vc =[[MFMessageComposeViewController alloc] init];
    
    // 设置短信内容
    
    vc.body = [NSString stringWithFormat:@"我正在使用网路出行司机端，我的邀请码是：%@，下载地址：http://wx.wllives.com/Wxmp/Index/download_all",[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_code"]];
    
    // 设置收件人列表
    
    vc.recipients = @[phoneTextFiled.text];
    
    // 设置代理
    
    vc.messageComposeDelegate = self;
    
    // 显示控制器
    
    [self  presentViewController:vc animated:YES completion:nil];
    
}

//代理方法，当短信界面关闭的时候调用，发完后会自动回到原应用-
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    
    [controller dismissViewControllerAnimated:YES completion:nil];                                        if (result == MessageComposeResultCancelled) {                                                   NSLog(@"取消发送");                                                                                                           } else if (result == MessageComposeResultSent) {                                                  NSLog(@"已经发出");                                                                                                           } else {                                                                                                                          NSLog(@"发送失败");                                                                                                               }
}

// 生成二维码
- (void)setupGenerateQRCode {
    
    codeImageView.image = [SGQRCodeManager SG_generateWithDefaultQRCodeData:[[NSUserDefaults standardUserDefaults] objectForKey:@"invite_code"] imageViewWidth:200];
    
#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
//    CGFloat scale = 0.22;
//    CGFloat borderW = 5;
//    UIView *borderView = [[UIView alloc] init];
//    CGFloat borderViewW = imageViewW * scale;
//    CGFloat borderViewH = imageViewH * scale;
//    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
//    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
//    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
//    borderView.layer.borderWidth = borderW;
//    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
//    borderView.layer.cornerRadius = 10;
//    borderView.layer.masksToBounds = YES;
//    borderView.layer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    
    //[imageView addSubview:borderView];
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    
    CGFloat scale = 0.2;
    
    // 2、将最终合得的图片显示在UIImageView上
    codeImageView.image = [SGQRCodeManager SG_generateWithLogoQRCodeData:@"唐朝客科技有限公司" logoImageName:@"logo" logoScaleToSuperView:scale];
    
}

#pragma mark - - - 彩色图标二维码生成
- (void)setupGenerate_Color_QRCode {
    
    codeImageView.image = [SGQRCodeManager SG_generateWithColorQRCodeData:@"唐朝客科技有限公司" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
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
